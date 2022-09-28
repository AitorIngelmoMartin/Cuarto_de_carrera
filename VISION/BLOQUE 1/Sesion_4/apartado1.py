# coding: utf-8
import cv2

thickness = 2

#Función para atender los eventos del ratón
def EventoRaton(evento, x, y, flags,datos):
    global color
    global coordenada_inicial
    global thickness
    if evento == cv2.EVENT_MOUSEMOVE:
        pass

    elif evento == cv2.EVENT_RBUTTONDBLCLK:
        print("Doble click botón derecho\n")
        cv2.circle(img, (x,y), 3, color, -1)
    elif evento == cv2.EVENT_LBUTTONDOWN:
        coordenada_inicial = (x,y)
        print("Pulsar botón izquierdo\n")
    elif evento == cv2.EVENT_LBUTTONUP:
        cv2.rectangle(img, coordenada_inicial, (x,y), (0,0,255), thickness)
        print("Soltar botón izquierdo\n")
    else:
        print("Otro evento\n")

    print("Coordenadas: x=", x, ", y=", y, "\n")
    print(color)
    #Refrescamos la imagen en pantalla.
    cv2.imshow("Imagen", img)

#Abrimos la imagen indicada en el primer argumento
try:
    img=cv2.imread("pajaro.jpeg", cv2.IMREAD_UNCHANGED)
except:
    print("ERROR al abrir la imagen\n")

#Comprobamos si la imagen se ha abierto correctamente.
if img is None:
    print("ERROR: Imagen no existe\n")
else:
    #Creamos una ventana donde mostrar la imagen.
    cv2.namedWindow("Imagen", cv2.WINDOW_AUTOSIZE)
    #Mostramos la imagen en pantalla.
    cv2.imshow("Imagen", img)

    color=(0,0,255)
    cv2.setMouseCallback("Imagen", EventoRaton)
    
    #Variable en la que capturaremos la tecla pulsada.
    c=0
    #Creamos un bucle infinito, que sólo finalizará al pulsar Esc.
    while not c==27:
        #Esperamos a que el usuario pulse una tecla.
        c=cv2.waitKey(0) & 0xFF
        if c == ord('g'):
            color =(0,255,0)
            print("Color cambiado a verde")
        if c == ord('r'):
            color =(0,0,255)
            print("Color cambiado a rojo")
        if c == ord('b'):
            color =(255,0,0)    
            print("Color cambiado a azul")
        if c == ord('+'):
            thickness +=1 
            print("thickness aumentado a:",thickness)
        if c == ord('-'):
            if thickness==-1:
                thickness = -1
                print("thickness decrementado a:",thickness)
            else:
                thickness -=1    
                print("thickness decrementado a:",thickness)    
        #Imprimimos la tecla pulsada.
        print(c,"\n")


    #Liberamos la ventana creada.
    cv2.destroyWindow("Imagen")

