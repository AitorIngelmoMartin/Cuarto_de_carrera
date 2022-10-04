###########################################################
# Umbralización de imagenen en escala de gris con umbral fijo
###########################################################

import cv2

#Leemos la imagen
img = cv2.imread("Monedas.jpg")
if img is None:
    print('Imagen no encontrada')

#Convertimos la imagen para asegurarnos que es en escala de grises
img_gris=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
 

#Umbralizamos la imagen y obtenemos la máscara y el umbral usado
ret,mask=cv2.threshold(img_gris, 150, 255, cv2.THRESH_BINARY)

print ('Umbral utilizado: ',ret)

#Mostramos el resultado 
cv2.namedWindow('ImagenGris', cv2.WINDOW_AUTOSIZE )
cv2.imshow('ImagenGris', img_gris)   
cv2.namedWindow( 'Umbralizacion', cv2.WINDOW_AUTOSIZE )
cv2.imshow("Umbralizacion", mask)

cv2.waitKey(0)
cv2.destroyAllWindows()
