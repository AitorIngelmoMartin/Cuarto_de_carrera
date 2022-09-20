import cv2

video = "output.mp4"
print ('Nombre vídeo: ',video )

#Creamos un objeto de la clase video-captura
cap = cv2.VideoCapture(video)

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

#Comprueba si se ha inicializado correctamente la captura (cap.isOpened()) y
#si el frame se ha leído correctamente (ret).
while(cap.isOpened() and ret):

    cv2.imshow("frame",frame)
    if cv2.waitKey(time) & 0xFF == ord('q'):
        break
    #Captura frame a frame    
    ret, frame = cap.read()
    
#Se libera el objeto    
cap.release()
cv2.destroyAllWindows()