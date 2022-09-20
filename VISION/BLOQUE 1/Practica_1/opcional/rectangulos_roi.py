import cv2

imagen = cv2.imread("Aitor.jpeg")
dimension = imagen.shape


nueva_dimension = (int(dimension[0]/2),int(dimension[1]))
imagen_redimensionada = cv2.resize(imagen, nueva_dimension, interpolation = cv2.INTER_LANCZOS4)
cv2.imwrite('Aitor_mediano.jpg',imagen_redimensionada) 

imagen_a_tratar = cv2.imread("Aitor_mediano.jpg")
cv2.imshow('Foto',imagen_a_tratar)

cv2.waitKey(0)
cv2.destroyAllWindows()