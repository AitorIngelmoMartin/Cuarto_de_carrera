###########################################################
# Umbralización de imagenen en escala de gris con umbral varaible
###########################################################
import cv2

#Creamos un objeto de la clase video
cap = cv2.VideoCapture("movil.avi")

#Captura el primer frame
ret, frame = cap.read()

#Obtenemos la tasa de fps del objeto
fps = cap.get(cv2.CAP_PROP_FPS)

#Variable time en ms
time=int(1000/fps) 

Umbral_OTSU_inferior = 150
Umbral_OTSU_superior = 255
#Comprueba si se ha inicializado correctamente la captura (cap.isOpened()) y
#si el frame se ha leído correctamente (ret).
while(cap.isOpened() and ret):

    #Convertimos la imagen para asegurarnos que es en escala de grises
    img_gris=cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) 

    #Umbralizamos la imagen y obtenemos la máscara y el umbral usado
    ret, mask=cv2.threshold(img_gris, 150, 255, cv2.THRESH_BINARY)  
   
    concatenacion_horizontal_1 = cv2.hconcat([img_gris,mask])

    ret2, mask2=cv2.threshold(img_gris, Umbral_OTSU_inferior, Umbral_OTSU_superior, cv2.THRESH_BINARY+cv2.THRESH_OTSU)  
    print("El valor de umbral seleccionado por Otsu es:",ret2)
    concatenacion_horizontal_2 = cv2.hconcat([img_gris,mask2])

    concatenacion_final        = cv2.vconcat([concatenacion_horizontal_1,concatenacion_horizontal_2])

    # Muestro la el video 
    cv2.namedWindow('threshold', cv2.WINDOW_AUTOSIZE )
    cv2.imshow('threshold', concatenacion_final)   

    # Sistema para cerrar el video a mano
    if cv2.waitKey(time) & 0xFF == ord('q'):
        break
    #Captura frame a frame    
    ret, frame = cap.read()