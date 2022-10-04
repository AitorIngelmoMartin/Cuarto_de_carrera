import cv2
import numpy as np

#Leemos la imagen asegurando convertirla a escala de gris. Flag: cv2.IMREAD_GRAYSCALE=0
try:
    img=cv2.imread("imagenes\Morfologico.png", cv2.IMREAD_GRAYSCALE)
except:
    print("ERROR al abrir la imagen\n")


#Creamos el kernel  usar, en este caso una matriz de 1 de 5x5
kernel = np.ones((5,5),np.uint8)
#Realizamos la erosión
erosion = cv2.erode(img,kernel, ancla, iteraciones);

#Mostramos las imágenes
cv2.imshow('Imagen',img)
#cv2.imshow('Erosion',erosion)

cv2.waitKey(0)
cv2.destroyAllWindows()
