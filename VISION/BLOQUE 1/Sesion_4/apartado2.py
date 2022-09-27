# coding: utf-8
import cv2
import numpy as np

r = 0
b = 0
g = 0
s = 1

def nothing(x): #Necesitamos esta función aunque no haga nada
    global s
    s = cv2.getTrackbarPos(switch,'Imagen') 

def red(x): #Necesitamos esta función aunque no haga nada
    global r
    r = cv2.getTrackbarPos('R','Imagen')
def green(x): #Necesitamos esta función aunque no haga nada
    global g
    g = cv2.getTrackbarPos('G','Imagen')
def blue(x): #Necesitamos esta función aunque no haga nada
    global b
    b = cv2.getTrackbarPos('B','Imagen')
   
#Crear una imagen de fondo negro y una ventan
img=np.zeros((480,640,3), np.uint8)
cv2.namedWindow('Imagen')

# Creamos las barras para cada color 
cv2.createTrackbar('R','Imagen',50,255,red)
cv2.createTrackbar('G','Imagen',100,255,green)
cv2.createTrackbar('B','Imagen',150,255,blue)

# Creamos un botón interruptor ON/OFF
switch = '0 : OFF \n1 : ON'
cv2.createTrackbar(switch, 'Imagen',1,1,nothing)

while(1):
    cv2.imshow('Imagen',img)#Mostramos la imagen

    k = cv2.waitKey(1) & 0xFF #Miramos la tecla pulsada. Si es Esc nos salimos
    if k == 27:
        break 
    
    if s == 0:
        img[:] = 0
    else:
        img[:] = [b,g,r]
    
    print(img)
     
   
cv2.destroyAllWindows()
