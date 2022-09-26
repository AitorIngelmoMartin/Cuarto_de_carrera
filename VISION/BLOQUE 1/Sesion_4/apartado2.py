# coding: utf-8
import cv2
import numpy as np

r = 0

def nothing(x): #Necesitamos esta función aunque no haga nada
    pass

def EventoRaton(evento, x, y, flags,datos):
        """FUNCION AQUI"""  
        if evento == cv2.EVENT_LBUTTONDOWN:
            r += 1

#Crear una imagen de fondo negro y una ventan
img=np.zeros((480,640,3), np.uint8)
cv2.namedWindow('Imagen')

# Creamos las barras para cada color 
cv2.createTrackbar('R','Imagen',50,255,nothing)
cv2.createTrackbar('G','Imagen',100,255,nothing)
cv2.createTrackbar('B','Imagen',150,255,nothing)

# Creamos un botón interruptor ON/OFF
switch = '0 : OFF \n1 : ON'
cv2.createTrackbar(switch, 'Imagen',1,1,nothing)

while(1):
    cv2.imshow('Imagen',img)#Mostramos la imagen

    k = cv2.waitKey(1) & 0xFF #Miramos la tecla pulsada. Si es Esc nos salimos
    if k == 27:
        break
    
    #LLamada CallBack
    cv2.setMouseCallback("Imagen", EventoRaton)
    
    # Leemos las posiciones de los 4 trackbars
    r = cv2.getTrackbarPos('R','Imagen')
    g = cv2.getTrackbarPos('G','Imagen')
    b = cv2.getTrackbarPos('B','Imagen')
    s = cv2.getTrackbarPos(switch,'Imagen')     
    
    if s == 0:
        img[:] = 0
    else:
        img[:] = [b,g,r]
     
   
cv2.destroyAllWindows()
