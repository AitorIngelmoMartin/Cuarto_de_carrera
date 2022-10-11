import cv2

#PIVC (Procesado de Imagen y Visión por Computador) 
#Modulo 2-Practica 1 - Detector Viola & Jones

#Funcion para pintar los bounding boxes detectados
def draw_rects(img, rects, color):
    for x1, y1, x2, y2 in rects:
        cv2.rectangle(img, (x1, y1), (x2, y2), color, 2)


def detector(img_color):
    print(">>> Cargando imagen...")
    #Tratamos la imagen
    img_gray = cv2.cvtColor(img_color, cv2.COLOR_RGB2GRAY)
    img_gray = cv2.equalizeHist(img_gray)#Mejora la apariencia de la imagen
    print(img_gray.shape)

    # Carga del modelo de deteccion (previamente entrenado)
    cascade_fn = 'haarcascades/haarcascade_profileface.xml'
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
    rects[:, 2:] += rects[:, :2]   
            
    img_out = img_color.copy()
    draw_rects(img_out, rects, (0, 255, 0))
    return img_out
    
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
        cv2.imwrite("Captura_detectada.png",img_out)
        break
   

cv2.waitKey(0)
cv2.destroyAllWindows()