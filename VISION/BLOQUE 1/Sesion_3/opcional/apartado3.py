import glob
import cv2
import numpy as np

#Creamos un objeto de video-captura
cap   = cv2.VideoCapture(0, cv2.CAP_DSHOW)

fourcc = cv2.VideoWriter_fourcc(*'MJPG')
out = cv2.VideoWriter('opcional/Sensor_movimiento.avi',fourcc, 30.0, (1280,480))

#Leo dos primeras imágenes
ret1,img_ref  = cap.read() 
ret2,img      = cap.read() 

#Dimensiones de la imagen capturada por la cámara
[alto,ancho] = img.shape[0:2]
cuenta =0
img_array=[]
while ret1 and ret2:    
    #Conversión a escala de gris de la imagen actual img:
    img_gray     = cv2.cvtColor(img,  cv2.COLOR_BGR2GRAY)
    #Conversión a escala de gris de la imagen de referencia del frame anterior:
    img_ref_gray = cv2.cvtColor(img_ref,  cv2.COLOR_BGR2GRAY)
    #Calcular diferencia de imágenes: img_gray e img_ref_gray
    diferencia_frames = cv2.absdiff(img_gray,img_ref_gray)    
    
    #Visualizar los dos videos
    concatenacion = cv2.hconcat([img_gray,diferencia_frames])
    cv2.imshow("Deteccion de movimiento",concatenacion)
    
    cv2.imwrite("opcional/fotogramas/frame%d.png" % cuenta ,concatenacion)
    cuenta+=1        
    #En cada iteración, la imagen anterior se convierte en referencia 
    #(clonación de imágenes). Completar código    
    img_ref = img.copy()
    
    #Lectura de imagen actual (img). 
    ret2,img = cap.read()

    # Guardado video superpuesto               
    
    if cv2.waitKey(1) & 0xFF == ord('q'):
        for filename in glob.glob('opcional/fotogramas/*.png'):
            
            img = cv2.imread(filename)
            height, width, layers = img.shape
            size = (width,height)
            img_array.append(img) 
                
        for i in range(len(img_array)):
            out.write(img_array[i])
        break
    
#Liberar objetos
cap.release()
out.release()
cv2.destroyAllWindows()


