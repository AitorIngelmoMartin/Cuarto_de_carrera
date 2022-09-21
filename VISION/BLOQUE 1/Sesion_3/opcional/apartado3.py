# -*- coding: utf-8 -*-
import cv2
import numpy as np

#Creamos un objeto de video-captura
video = "movimiento.mp4"
cap   = cv2.VideoCapture(video)

fourcc = cv2.VideoWriter_fourcc(*'MJPG')
out    = cv2.VideoWriter('Superposicion.avi',fourcc, 29, (1080,1920))
#Leo dos primeras imágenes
ret1, img_ref = cap.read() 
ret2,img      = cap.read() 

#Obtenemos la tasa de fps del objeto
fps = cap.get(cv2.CAP_PROP_FPS)

#Variable time en ms
time = int(1000/fps) 
print("Nº de frames por segundo: ",fps)

#Líneas a añadir para determinar anchura y altura
width  = cap.get(cv2.CAP_PROP_FRAME_WIDTH)   
height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)  
print('Dimensiones de la imagen:',(width,height))


#Dimensiones de la imagen capturada por la cámara
[alto,ancho]=img.shape[0:2]

while ret1 and ret2:
    
    #Conversión a escala de gris de la imagen actual img (completar código)
    img_gray     = cv2.cvtColor(img,  cv2.COLOR_BGR2GRAY)
    #Conversión a escala de gris de la imagen de referencia del frame anterior img_ref (completar código)
    img_ref_gray = cv2.cvtColor(img_ref,  cv2.COLOR_BGR2GRAY)
    #Calcular diferencia de imágenes: img_gray e img_ref_gray
    diferencia_frames = cv2.absdiff(img_gray,img_ref_gray)    
       
    cv2.imshow('Img Original',img)
    
    #Visualizar la imagen de detección de movimiento en otra ventana (completar código)
    cv2.imshow("Deteccion de movimiento",diferencia_frames)  

    #En cada iteración, la imagen anterior se convierte en referencia 
    #(clonación de imágenes). Completar código    
    ref = diferencia_frames.copy()
    
    #Lectura de imagen actual (img). 
    ret2,img=cap.read()
    
    # Guardado video superpuesto

    frame_superpuesto = np.dstack((img,diferencia_frames))
    out.write(frame_superpuesto)        
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    
#Liberar objetos
cap.release()
cv2.destroyAllWindows()


