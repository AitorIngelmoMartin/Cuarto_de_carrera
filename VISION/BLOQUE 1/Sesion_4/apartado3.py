'''
Las partes del código para editar/modificar vienen marcadas con el tag TODO
'''

import cv2
import numpy as np

r = 0
b = 0
g = 0
s = 1
i = 0
dibujo = []
def limpiar(x): #Necesitamos esta función aunque no haga nada
    global s
    s = cv2.getTrackbarPos(switch,'Paint') 

def nada(x):
    global grosor
    grosor = cv2.getTrackbarPos("Grosor",'Paint') 
def red(x): #Necesitamos esta función aunque no haga nada
    global r
    r = cv2.getTrackbarPos('R','Paint')
def green(x): #Necesitamos esta función aunque no haga nada
    global g
    g = cv2.getTrackbarPos('G','Paint')
def blue(x): #Necesitamos esta función aunque no haga nada
    global b
    b = cv2.getTrackbarPos('B','Paint')

#Función para atender a los eventos del ratón
def EventoRaton(evento, x, y, flags,datos):
    #Variables globales: color y grosor de trazo. 
    #La variable start controla activación/desactivación del pincel.    
    global color
    global grosor
    global start
    global coordenada_inicial
    
    #Al pulsar el botón izquierdo se activa la representación del pincel'
    if evento == cv2.EVENT_LBUTTONDOWN:
        #TODO:
        #######################################################################        
        #Sustituya pass por activar la representación del pincel mediante una
        #asignación de la variable start.
        start = True
        #######################################################################
    #Al soltar el botón izquierdo se desactiva la representación del pincel    
    elif evento == cv2.EVENT_LBUTTONUP:
        #TODO:
        #######################################################################        
        #Sustituya pass por desactivar la representación del pincel mediante una
        #asignación de la variable start.
        start = False
        #######################################################################
   #Al mover el ratón en modo activado de representación se dibuja un círculo
    elif start==True and evento==cv2.EVENT_MOUSEMOVE:
         #TODO:
        #######################################################################        
        #Sustituya pass por el comando de dibujar cv2.circle.
        cv2.circle(img, (x,y), 1, color, grosor)

        #######################################################################
    if evento == cv2.EVENT_RBUTTONDOWN:
        coordenada_inicial = (x,y)
        print("Pulsar botón izquierdo\n")
    elif evento == cv2.EVENT_RBUTTONUP:
        if dibujo == "Linea":
            cv2.line(img, coordenada_inicial, (x,y), color, grosor)  
        if dibujo == "Recnángulo":         
            cv2.rectangle(img, coordenada_inicial, (x,y), color, grosor)
        print("Soltar botón izquierdo\n")        


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
cv2.createTrackbar('R','Paint',255,255,red)
cv2.createTrackbar('G','Paint',255,255,green)
cv2.createTrackbar('B','Paint',255,255,blue)

#TODO:
###############################################################################       
#Crear barra de desplazamiento para definir el grosor del pincel con valor 
#inicial=2. Rango [0-15]
###############################################################################
cv2.createTrackbar('Grosor','Paint',2,15,nada)
switch = '0 : OFF \n1 : ON'
cv2.createTrackbar(switch, 'Paint',1,1,limpiar)
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
    if k == ord('f'):
        cv2.imwrite("captura%d.png" % i ,img)
        i+=1    
        print("Guardado del dibujo realizado")
    if k == ord("l"):
        dibujo = "Linea"
    if k == ord("r"):
        dibujo = "Recnángulo"
    #TODO:
    ###########################################################################
    #Leemos las posiciones de los trackbars RGB y el grosor. 
    ###########################################################################
    color=(b,g,r) 
    if s == 0:
       img[:] = 0

cv2.destroyAllWindows()