###############################################
#Detector de bordes mediante algoritmo de Canny
###############################################

import cv2
Umbral_1 = 50
Umbral_2 = 200
def red(x): # Actualizo "color" con la variable de la barra roja
    global Umbral_1
    Umbral_1 = x
    print(x)
    pass
def green(x):# Actualizo "color" con la variable de la barra verde
    global Umbral_2
    Umbral_2 = x
    print(x)
    pass

img = cv2.imread("Politecnica1.png")
if img is None:
    print('Imagen no encontrada')
img_original = img.copy()
bordes = cv2.Canny(img,50,200,apertureSize = 3)

cv2.imshow('Original',img)
cv2.imshow('Bordes',bordes)
img[bordes==255]=(0,255,0)
cv2.imshow('BordesImg',img)

#Declaro las barras
cv2.createTrackbar('inferior','BordesImg',50,1000,red)
cv2.createTrackbar('superior','BordesImg',200,1000,green)


while(1):
    img = cv2.imread("Politecnica1.png")
    k = cv2.waitKey(1) & 0xFF #Miramos la tecla pulsada. Si es Esc nos salimos
    if k == 27:
        break 
    bordes = cv2.Canny(img,Umbral_1,Umbral_2,apertureSize = 3)

    cv2.imshow('Original',img_original)
    cv2.imshow('Bordes',bordes)
    img[bordes==255]=(0,255,0)
    cv2.imshow('BordesImg',img)

    """Representar mapa de borde y con la de borde a la vez"""
    concatenacion =  cv2.hconcat([img_original,img])
    cv2.imshow('Final',concatenacion)

cv2.waitKey(0)
cv2.destroyAllWindows()