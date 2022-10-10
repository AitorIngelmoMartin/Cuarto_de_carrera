# coding: utf-8
import cv2
import numpy as np

r = 0
b = 0
g = 0
s = 1

def nothing(x): 
    global s
    s = x

def red(x): # Actualizo "color" con la variable de la barra roja
    global r
    r = x
def green(x):# Actualizo "color" con la variable de la barra verde
    global g
    g = x
def blue(x): # Actualizo "color" con la variable de la barra azul
    global b
    b = x
   
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

   
cv2.destroyAllWindows()
