import cv2
import numpy as np

#Leemos la imagen asegurando convertirla a escala de gris. Flag: cv2.IMREAD_GRAYSCALE=0
try:
    img=cv2.imread("imagenes\Morfologico.png", cv2.IMREAD_GRAYSCALE)
except:
    print("ERROR al abrir la imagen\n")
img_original = img.copy()

#Creamos el kernel  usar, en este caso una matriz de 1 de 5x5
kernel = np.ones((5,5),np.uint8)

#Realizamos la erosión 4 veces seguidas
for iteraciones in range(4):
    #fotogramas/frame%d.png" % cuenta ,concatenacion)
    erosionada = cv2.erode(img,kernel,iteraciones)
    cv2.imwrite("Output/erosion%d.png" %(iteraciones+1) ,erosionada)
    img = erosionada    

#VARIACION KERNEL

valor_kernel = 0 
#Realizamos la erosión 4 veces seguidas
for iteraciones in range(3): 
    valor_kernel = iteraciones+3
    kernel = np.ones((valor_kernel,valor_kernel),np.uint8)
    print("El tamaño del kernel es:",valor_kernel)
    erosionada = cv2.erode(img_original,kernel,iteraciones)
    cv2.imwrite("Output/kernel%d.png" %(iteraciones+1) ,erosionada)

#DILATACION

kernel = np.ones((5,5),np.uint8)
#Realizamos la erosión 4 veces seguidas
for iteraciones in range(3): 
    #fotogramas/frame%d.png" % cuenta ,concatenacion)
    erosionada = cv2.dilate(img,kernel,iteraciones)
    cv2.imwrite("Output/dilatacion%d.png" %(iteraciones+1) ,erosionada)
    img = erosionada        




#Mostramos las imágenes
cv2.imshow('Imagen',img)
cv2.imshow('Erosion',erosionada)

cv2.waitKey(0)
cv2.destroyAllWindows()
