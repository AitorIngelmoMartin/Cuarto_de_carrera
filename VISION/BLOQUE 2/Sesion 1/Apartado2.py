import cv2
import numpy as np
#PIVC (Procesado de Imagen y Visión por Computador) 
#Modulo 2-Practica 1 - Detector Viola & Jones

colores = []
#Funcion para pintar los bounding boxes detectados
def draw_rects(img, rects, color):
    for x1, y1, x2, y2 in rects:
        cv2.rectangle(img, (x1, y1), (x2, y2), color, 2)


def detector(img_color):
    global colores
    vueltas = 0
    print(">>> Cargando imagen...")
    #Tratamos la imagen
    img_gray = cv2.cvtColor(img_color, cv2.COLOR_RGB2GRAY)
    img_gray = cv2.equalizeHist(img_gray)#Mejora la apariencia de la imagen
    print(img_gray.shape)

    # Carga del modelo de deteccion (previamente entrenado)
    cascade_fn = 'haarcascades/haarcascade_frontalface_alt.xml'
    cascade = cv2.CascadeClassifier(cascade_fn)    
        
    #Llamada al detector               
    print(">>> Detectando caras...")
    
    rects =  cascade.detectMultiScale(
        img_gray,
        scaleFactor  = 1.1,
        minNeighbors = 5,
        minSize = (30, 30),
        flags   = cv2.CASCADE_SCALE_IMAGE
    )
    
    if len(rects) == 0:
        return img_color
    print(rects)

    for (x, y, w, h) in rects:
        cv2.rectangle(img_color, (x, y), (x + w, y + h), (int(colores[vueltas][0]),int(colores[vueltas][1]),int(colores[vueltas][2])), 2)
        vueltas+=1
    print("El numero de colores es",(np.size(colores))/3)
    return img_color
    
#Creamos el objeto capturador de video
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)

#Objeto para grabar
fourcc = cv2.VideoWriter_fourcc(*'MJPG')                                  #Establezco el formato de grabación
out    = cv2.VideoWriter('videoAitorIngelmo.avi',fourcc, 60.0, (640,480)) # Introduzco los parámetros del video que estoy grabando


#Creamos aleatoriamente 20 caras
for i in range(20):
    color = tuple(np.random.choice(range(256), size=3))
    colores.append(color)

while(True):
    # Captura frame a frame
    ret, frame = cap.read()
    # Trabajamos con los frames
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
    copia_frame = frame.copy()
    # LLamo al detector
    img_out = detector(copia_frame)

    # Muestro el resultado
    cv2.imshow('resultado_deteccion', img_out)

    # Guardo el "frame"
    out.write(img_out)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        #cv2.imwrite("Captura_detectada.png",img_out)
        break
   

cv2.waitKey(0)
cv2.destroyAllWindows()