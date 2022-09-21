# -*- coding: utf-8 -*-
import cv2


#Creamos un objeto de video-captura
cap = cv2.VideoCapture(0)


fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter('output.avi',fourcc, 20.0, (640,480))
#Leo dos primeras imágenes
ret1, img_ref = cap.read() 
ret2,img=cap.read() 


#Dimensiones de la imagen capturada por la cámara
[alto,ancho]=img.shape[0:2]


while ret1 and ret2:
    
    #Conversión a escala de gris de la imagen actual img (completar código)
    #img_gray=cv2.cvtColor...
    #Conversión a escala de gris de la imagen de referencia del frame anterior img_ref (completar código)
    #img_ref_gray=cv2.cvtColor...
    #Calcular diferencia de imágenes: img_gray e img_ref_gray
    #dif=cv2.absdiff...
    
       
    cv2.imshow('Img Original',img)
    
    #Visualizar la imagen de detección de movimiento en otra ventana (completar código)
    #cv2.imshow()    
     
    #En cada iteración, la imagen anterior se convierte en referencia 
    #(clonación de imágenes). Completar código    
    #ref=...
    
    #Lectura de imagen actual (img). 
    ret2,img=cap.read()
    
        
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    
#Liberar objetos
cap.release()
cv2.destroyAllWindows()


