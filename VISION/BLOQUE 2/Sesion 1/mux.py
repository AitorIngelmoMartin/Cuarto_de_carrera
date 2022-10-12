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
        minSize=(30, 30),
        flags = cv2.CASCADE_SCALE_IMAGE
    )
    
    if len(rects) == 0:
        return img_color
    print(rects)
    for (x, y, w, h) in rects:
        color = tuple(np.random.choice(range(256), size=3))
        colores.append(color)
        cv2.rectangle(img_color, (x, y), (x + w, y + h), (int(color[0]),int(color[1]),int(color[2])), 2)
    print(colores[0])
    print(colores[0][2])
    return img_color
    
#Creamos el objeto capturador de video
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)

while(True):
 # Capture frame-by-frame
    ret, frame = cap.read()
    # Our operations on the frame come here
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
    copia_frame = frame.copy()
    # Display the resulting frame
    img_out = detector(copia_frame)
    cv2.imshow('resultado_deteccion', img_out)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        #cv2.imwrite("Captura_detectada.png",img_out)
        break
   

cv2.waitKey(0)
cv2.destroyAllWindows()