import cv2

#select ROI function
img=cv2.imread('Aitor_mediano.jpg')
roi = cv2.selectROI(img)

#print rectangle points of selected roi
print(roi)

#Crop selected roi from raw image
roi_cropped = img[int(roi[1]):int(roi[1]+roi[3]), int(roi[0]):int(roi[0]+roi[2])]

#show cropped image
cv2.imshow("ROI_ojo_izquierdo", roi_cropped)

#cv2.imwrite("ROI_boca.jpeg",roi_cropped)
#cv2.imwrite("ROI_ojo_izquierdo.jpeg",roi_cropped)
#cv2.imwrite("ROI_ojo_derecho.jpeg",roi_cropped)



cv2.waitKey(0)
cv2.destroyAllWindows()