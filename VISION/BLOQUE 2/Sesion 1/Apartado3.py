import cv2
import numpy as np

#PIVC (Procesado de Imagen y Visión por Computador) 
#Modulo 2-Practica 1 - Detector Viola & Jones

#Funcion para pintar los bounding boxes detectados
def draw_rects(img, rects, color):
    for x1, y1, x2, y2 in rects:
        cv2.rectangle(img, (x1, y1), (x2, y2), color, 2)
        
        # Difumino con un desenfoque gausiano la zona de la cara
        roi = img[y1:y2, x1:x2]
        roi = cv2.GaussianBlur(roi, (23, 23), 30)

        # LLamo a la función pixelate_face
        roi_pixelado = pixelado (roi,rects,tam_bloque)

        # Superpongo en la imagen a la original la roi con desenfoque y pixelado
        img[y1:y1+roi_pixelado.shape[0], x1:x1+roi_pixelado.shape[1]] = roi_pixelado

def pixelado(img, rects,tam_bloque):
    for x1, y1 in rects:
        # Dividimos la imagen en bloques de tam_bloquextam_bloque
        (h,w) = img.shape[:2]
        pasos_X = np.linspace(0, w, tam_bloque + 1, dtype="int")
        pasos_Y = np.linspace(0, h, tam_bloque + 1, dtype="int")
        # Bucle que recorre los bloques tanto en la dirección x como en y
        for i in range(1, len(pasos_Y)):
            for j in range(1, len(pasos_X)):                
                inicio_X = pasos_X[j - 1]
                inicio_Y = pasos_Y[i - 1]
                fin_X    = pasos_X[j]
                fin_Y    = pasos_Y[i]
                # Extraemos una ROI sobre la cual hacer "mean" en sus componentes RGB
                roi = img[inicio_Y:fin_Y, inicio_X:fin_X]
                (B, G, R) = [int(x) for x in cv2.mean(roi)[:3]]
                cv2.rectangle(img, (inicio_X, inicio_Y), (fin_X, fin_Y),
                    (B, G, R), -1)
        # Superponemos esta nueva imagen pixelada a la dada por parámetro
        img[y1:y1+roi.shape[0], x1:x1+roi.shape[1]] = roi
    # Devolvemos la imagen
    return img


def detector(img_color):
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
        scaleFactor=1.1,
        minNeighbors=5,
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

#Objeto para grabar
fourcc = cv2.VideoWriter_fourcc(*'MJPG')                                  #Establezco el formato de grabación
out    = cv2.VideoWriter('video_pixelado.avi',fourcc, 60.0, (640,480)) # Introduzco los parámetros del video que estoy grabando
 
#Definimos el tamaño de la rejilla 
tam_bloque = 20

while(True):
 # Capture frame-by-frame
    ret, frame = cap.read()
    # Our operations on the frame come here
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
    copia_frame = frame.copy()
    # Display the resulting frame
    img_out = detector(copia_frame)
    cv2.imshow('resultado_deteccion', img_out)
    # Guardo el "frame"
    out.write(img_out)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        #cv2.imwrite("Captura_detectada.png",img_out)
        break
   

cv2.waitKey(0)
cv2.destroyAllWindows()



