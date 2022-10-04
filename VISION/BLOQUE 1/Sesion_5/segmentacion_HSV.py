############################################
#Segmentación por color (RGB)
############################################

import numpy as np
import cv2

#Función para atender a los eventos del ratón
def EventoRaton(evento, x, y, flags,datos):
     global color
     if evento == cv2.EVENT_LBUTTONDOWN:
          color       = img[y,x]
          img_color[:]= color
          total       = cv2.absdiff(img,img_color)
          mask_total  = (total[:,:,0]<Umbral)&(total[:,:,1]<Umbral)&(total[:,:,2]<Umbral)
          img2        = img.copy()

          img2[mask_total] = (0,255,0)
          cv2.imshow("Imagen", img2)

#Iniciamos aquí el programa

# Cargar la imagen
img_normal = cv2.imread("pokemon.png")
if img_normal is None:
    print ('ERROR: La imagen no existe\n')

img = cv2.cvtColor(img_normal,cv2.COLOR_BGR2HSV)
Umbral = 25

# Leemos el umbral para segmentar
umbralH = 50
umbralS = 50
umbralV = 50

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
#RANGO CANAL H
low_H=np.float32(color)-umbralH 
high_H=np.float32(color)+umbralH

#Los que son negativos los ponemos a 0
low_H[low_H<0]=0 
#Los que son mayores que 255 los ponemos a 255
high_H[high_H>255]=180

print ('Color seleccionado:',color)
print ('Color lowH:',low_H,'Color highH:',high_H) 
mask_H=cv2.inRange(img,low_H,high_H)

#RANGO CANAL S
low_S=np.float32(color)-umbralS 
high_S=np.float32(color)+umbralS

#Los que son negativos los ponemos a 0
low_S[low_S<0]=0 
#Los que son mayores que 255 los ponemos a 255
high_S[high_S>255]=255

print ('Color lowS:',low_S,'Color highS:',high_S) 
mask_S=cv2.inRange(img,low_S,high_S)

#RANGO CANAL V
low_V=np.float32(color)-umbralV 
high_V=np.float32(color)+umbralV

#Los que son negativos los ponemos a 0
low_V[low_V<0]=0 
#Los que son mayores que 255 los ponemos a 255
high_V[high_V>255]=255

print ('Color lowV:',low_V,'Color highV:',high_V) 
mask_V=cv2.inRange(img,low_V,high_V)

#Obtenemos la máscara total

mask_HS    = cv2.bitwise_or(mask_H,mask_S)
mask_total = cv2.bitwise_or(mask_HS,mask_V)
#Pintamos de verde los colores que queremos segmentar
img[mask_total==255]=(0,255,0)
concatenacion =  cv2.hconcat([img_normal,img])
#Mostramos el resultado
cv2.imshow("Pasado por HSV",concatenacion)
cv2.waitKey(0)

cv2.destroyAllWindows()