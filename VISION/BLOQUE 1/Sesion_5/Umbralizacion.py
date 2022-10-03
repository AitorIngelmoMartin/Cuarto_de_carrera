###########################################################
# Umbralización de imagenen en escala de gris con umbral fijo
###########################################################

import cv2

#Creamos un objeto de la clase video-captura
video = "video.mp4"
cap = cv2.VideoCapture(video)

#Leemos la imagen
img = cv2.imread("Monedas.jpg")
if img is None:
    print('Imagen no encontrada')

while(cap.isOpened()):
    #Capturo el primer frame
    ret, frame = cap.read()
    #Convertimos la imagen para asegurarnos que es en escala de grises
    img_gris=cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) 

    #Umbralizamos la imagen y obtenemos la máscara y el umbral usado
    mask=cv2.threshold(img_gris, 150, 255, cv2.THRESH_BINARY)  
    
    # Muestro el "frame"
    cv2.namedWindow('ImagenGris', cv2.WINDOW_AUTOSIZE )
    cv2.imshow('ImagenGris', img_gris)   
    cv2.namedWindow( 'Umbralizacion', cv2.WINDOW_AUTOSIZE )
    cv2.imshow("Umbralizacion", mask)


#Mostramos el resultado 
"""
cv2.namedWindow('ImagenGris', cv2.WINDOW_AUTOSIZE )
cv2.imshow('ImagenGris', img_gris)   
cv2.namedWindow( 'Umbralizacion', cv2.WINDOW_AUTOSIZE )
cv2.imshow("Umbralizacion", mask)
"""

cv2.waitKey(0)
cv2.destroyAllWindows()
