############################################
#Segmentación por color (RGB)
############################################

# coding: utf-8
import numpy as np
import sys
import cv2

#Función para atender a los eventos del ratón
def EventoRaton(evento, x, y, flags,datos):
     global color
     if evento == cv2.EVENT_LBUTTONDOWN:
          color=img[y,x]
          img_color[:]=color
          total = cv2.absdiff(img,img_color)
          mask=(total[:,:,0]<Umbral)&(total[:,:,1]<Umbral)&(total[:,:,2]<Umbral)
          img2=img.copy()
          img2[mask] = (0,255,0)
          cv2.imshow("Imagen", img2)

#Iniciamos aquí el programa

# Cargar la imagen
img = cv2.imread(sys.argv[1])
if img is None:
    print ('ERROR: Imagen '+ sys.argv[1]+' no existe\n')
    sys.exit(0)

    
# Leemos el umbral para segmentar
Umbral=int(sys.argv[2])
#Creamos una imagen vacía que nos sevirá después como referencia de color
img_color = np.zeros(img.shape, np.uint8)
#Creamos una ventana donde mostrar la imagen.
cv2.namedWindow("Imagen", cv2.WINDOW_AUTOSIZE)
#Mostramos la imagen en pantalla.
cv2.imshow("Imagen", img)
#Creamos el Callback para el ratón
cv2.setMouseCallback("Imagen", EventoRaton)

c=0
#Creamos un bucle infinito, que sólo finalizará al pulsar Esc.
while not c==27:
	#Esperamos a que el usuario pulse una tecla.
	c=cv2.waitKey(0) & 0xFF

'''
Aquí vamos a utilizar el color que hemos extraído y el umbral pasado para segmentar
con la función inRange(). Para ello debemos fijar un umbral inferior de color
y un umbral superior. Entre ellos estarán los colores que queremos.
'''	
#Deben ser float para poder tratar el signo
low=np.float32(color)-Umbral 
high=np.float32(color)+Umbral

#Los que son negativos los ponemos a 0
low[low<0]=0 
#Los que son mayores que 255 los ponemos a 255
high[high>255]=255 

print ('Color seleccionado:',color)
print ('Color low:',low,'Color high:',high) 

#Obtenemos la máscara
mask=cv2.inRange(img,low,high)
#Pintamos de verde los colores que queremos segmentar
img[mask==255]=(0,255,0)
#Mostramos el resultado
cv2.imshow("Con inRange",img)
cv2.waitKey(0)

cv2.destroyAllWindows()

