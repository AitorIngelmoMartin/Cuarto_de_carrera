from asyncio import QueueEmpty
import cv2

video = "Videos/video.avi"
print ('Nombre vídeo: ',video )

#Creamos un objeto de la clase video-captura
cap = cv2.VideoCapture(video)

fourcc = cv2.VideoWriter_fourcc(*'MJPG')
out = cv2.VideoWriter('videoAitorIngelmo.avi',fourcc, 25.0, (720,576))

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

#Definimos el tipo de fuente para escribir texto en vídeo
font = cv2.FONT_HERSHEY_SIMPLEX
Abajo_izquierda = (10,500)
fontScale              = 1
fontColor              = (0,255,0)
thickness              = 2
lineType               = 2

logo_original = cv2.imread("Videos/logo.png")
logo = cv2.resize(logo_original,(150,150))

#Comprueba si se ha inicializado correctamente la captura (cap.isOpened()) y
#si el frame se ha leído correctamente (ret).
while(cap.isOpened() and ret):
    cv2.putText(frame,"Aitor Ingelmo Martin",
    Abajo_izquierda, 
    font, 
    fontScale,
    fontColor,
    thickness,
    lineType)
    frame[0:150,0:150] = logo
    #nuevo_frame=cv2.addWeighted(frame,0.9,logo,0.1,0)
    out.write(frame)
    cv2.imshow("frame",frame)
    if cv2.waitKey(time) & 0xFF == ord('q'):
        break
    #Captura frame a frame    
    ret, frame = cap.read()
    
#Se libera el objeto    
cap.release()
cv2.destroyAllWindows()
