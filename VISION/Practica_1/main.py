"""
Created on Mon Sep 19 19:11:45 2022
@author: Aitor
"""
import cv2
import sys #Cargamos las llamadas a sistema

#Leemos la imagen.
image=cv2.imread(sys.argv[1], cv2.IMREAD_UNCHANGED)

#Creamos la ventana donde visualizar la imagen
cv2.namedWindow("Ejemplo1", cv2.WINDOW_AUTOSIZE)

if image is None: #Si la imagen está vacía es que no se ha leído
 print('Imagen no encontrada\n')
else:
 #Mostrar número de pixeles
 pixeles = image.size
 print("El número de píxeles de la imagen es:",pixeles)

 #Dimension de laimagen
 dimension = image.shape
 print("La dimensión de la imagen es:",dimension)
 
 #Mostrar el tipo de dato de la imagen
 print("El tipo de dato de la imagen es:", type(image))
 
 
 cv2.imshow('Ejemplo1', image) #Visualizamos la imagen 
 #La visualización espera hasta que el usuario presione una tecla.
 cv2.waitKey(0)
 
#Cerramos todas las ventanas creadas
cv2.destroyAllWindows()





