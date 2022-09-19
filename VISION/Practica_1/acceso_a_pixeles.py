"""
Created on Mon Sep 19 20:01:27 2022
@author: Aitor
"""
import cv2
import sys

img=cv2.imread('Imagenes/Minion.jpg') # Leemos la imagen

if img is None: #Si está vacía es que no se ha leído
 print('Imagen no encontrada\n')
 sys.exit(0)
 
#img[105:245,170:293]=(0,0,255)# Ponemos la ROI en color rojo (linea original)
 temp = "ROI_boca.jpeg"
 

 src2 = img.copy()
 result = cv2.matchTemplate(src2, temp, method)
 min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
 print(min_loc, max_loc)

 bottom_right = (location[0] + W, location[1] + H)
 cv2.rectangle(src2, location,bottom_right, 255, 5)
 cv2_imshow(src2)


cv2.imshow('ROI',img)
cv2.waitKey(0)
cv2.destroyAllWindows()




#select ROI function
roi = cv2.selectROI(img)

#print rectangle points of selected roi
print(roi)

#Crop selected roi from raw image
roi_cropped = img[int(roi[1]):int(roi[1]+roi[3]), int(roi[0]):int(roi[0]+roi[2])]

#show cropped image
cv2.imshow("ROI_ojo_izquierdo", roi_cropped)

cv2.imwrite("ROI_boca.jpeg",roi_cropped)

#hold window
cv2.waitKey(0)



