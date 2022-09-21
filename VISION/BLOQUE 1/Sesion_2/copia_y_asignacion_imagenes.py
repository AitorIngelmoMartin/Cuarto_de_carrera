"""
Created on Mon Sep 19 20:29:31 2022
@author: Aitor
"""
import cv2
import sys
img=cv2.imread('Imagenes/Minion.jpg') # Leemos la imagen

if img is None: #Si está vacía es que no se ha leído
 print('Imagen no encontrada\n')
 sys.exit(0)
 
img2=img.copy()# Ahora img ES UNA COPIA DE img2
img2[105:245,170:293]=(0,255,0)

cv2.imwrite("Copia.png",img)
cv2.imwrite("Modificada.png",img2)


