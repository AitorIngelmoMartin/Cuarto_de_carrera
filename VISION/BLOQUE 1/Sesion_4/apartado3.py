# coding: utf-8
'''
Las partes del código para editar/modificar vienen marcadas con el tag TODO
'''

import cv2
import numpy as np

def nada(x):
    pass


#Función para atender a los eventos del ratón
def EventoRaton(evento, x, y, flags,datos):
    #Variables globales: color y grosor de trazo. 
    #La variable start controla activación/desactivación del pincel.    
    global color
    global grosor
    global start
     
    #Al pulsar el botón izquierdo se activa la representación del pincel'
    if evento == cv2.EVENT_LBUTTONDOWN:
        #TODO:
        #######################################################################        
        #Sustituya pass por activar la representación del pincel mediante una
        #asignación de la variable start.
        pass
        #######################################################################
    #Al soltar el botón izquierdo se desactiva la representación del pincel    
    elif evento == cv2.EVENT_LBUTTONUP:
        #TODO:
        #######################################################################        
        #Sustituya pass por desactivar la representación del pincel mediante una
        #asignación de la variable start.
        pass
        #######################################################################
   #Al mover el ratón en modo activado de representación se dibuja un círculo
    elif start==True and evento==cv2.EVENT_MOUSEMOVE:
         #TODO:
        #######################################################################        
        #Sustituya pass por el comando de dibujar cv2.circle.
        pass
        #######################################################################
        


#Creamos una imagen de fondo negro sobre la que se pintará
img = np.zeros((600, 800, 3), np.uint8)

#Creamos una ventana donde mostrar la imagen.
cv2.namedWindow('Paint',cv2.WINDOW_AUTOSIZE)

#Asociamos la función de manejo de eventos a esta ventana.
cv2.setMouseCallback("Paint", EventoRaton)


#TODO:
###############################################################################       
#Crear 3 barras de desplazamiento RGB para definir el color del pincel 
#considerando blanco como color inicial de representación (R=255,G=255,B=255)
###############################################################################
cv2.createTrackbar('R','Paint',255,255,nada)

#TODO:
###############################################################################       
#Crear barra de desplazamiento para definir el grosor del pincel con valor 
#inicial=2. Rango [0-15]
###############################################################################



#Inicializar variables globales: color=blanco, grosor=2 y modo de 
#pincel desactivado (False)
color=(255,255,255)
grosor=2
start=False


while True:
    #Mostramos la imagen en pantalla.
    cv2.imshow('Paint',img)
    #Finalizamos el bucle con la tecla Esc
    k = cv2.waitKey(1) & 0xFF 
    if k == 27:
        break
    #TODO:
    ###########################################################################
    #Leemos las posiciones de los trackbars RGB y el grosor. 
    ###########################################################################
    r=g=b= 0
    color=(b,g,r)
    
 

cv2.destroyAllWindows()
