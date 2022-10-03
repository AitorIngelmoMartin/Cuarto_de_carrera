from asyncio import QueueEmpty
import cv2

video = "Videos/video.avi"
print ('Nombre vídeo: ',video)

#Creamos un objeto de la clase video-captura
cap = cv2.VideoCapture(video)

fourcc = cv2.VideoWriter_fourcc(*'MJPG')                                  #Establezco el formato de grabación
out    = cv2.VideoWriter('videoAitorIngelmo.avi',fourcc, 25.0, (720,576)) # Introduzco los parámetros del video que estoy grabando

#Obtenemos la tasa de fps del objeto
fps = cap.get(cv2.CAP_PROP_FPS)

#Variable time en ms
time=int(1000/fps) 
print("Nº de frames por segundo: ",fps)

#Líneas a añadir para determinar anchura y altura
width  = cap.get(cv2.CAP_PROP_FRAME_WIDTH)   
height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)  
print('Dimensiones de la imagen:',(width,height))

#Captura el primer frame
ret, frame = cap.read()

#Defino los parámetros para el texto que aparece en el vídeo:

font = cv2.FONT_HERSHEY_SIMPLEX    # Tipo de fuente
Abajo_izquierda = (10,500)         # Posición del texto
fontScale              = 1         # Escala de la fuente
fontColor              = (0,255,0) # Color del texto
thickness              = 2         # Grosor del texto

# Introducción del logo:
logo_original = cv2.imread("Videos/logo.png") # Leo el logo
logo = cv2.resize(logo_original,(150,150))    # Re-escalo el logo

#Comprueba si se ha inicializado correctamente la captura (cap.isOpened()) y
#si el frame se ha leído correctamente (ret).
while(cap.isOpened() and ret):
    # Imprime el texto
    cv2.putText(frame,"Aitor Ingelmo Martin",
                Abajo_izquierda, 
                font, 
                fontScale,
                fontColor,
                thickness)
    # Inserta el logo
    frame[(576-150):576,(720-150):720] = logo
    # Guardo el "frame"
    out.write(frame)
    # Muestro el "frame"
    cv2.imshow("frame",frame)

    # Sistema para cerrar el video a mano
    if cv2.waitKey(time) & 0xFF == ord('q'):
        break
    #Captura frame a frame    
    ret, frame = cap.read()
    
#Se libera el objeto    
cap.release()
cv2.destroyAllWindows()