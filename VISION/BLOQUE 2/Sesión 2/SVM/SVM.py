import cv2 as cv
import numpy as np
from sklearn.datasets import load_svmlight_file
import time

def get_data(file_name):
    data = load_svmlight_file(file_name)
    return np.float32(data[0].todense()), np.int32(data[1])

start_time = time.time()
# Set up training data
## [setup1]
trainingData, labels = get_data("Puntos.txt")
print('\nPuntos de entrenamiento\n',trainingData)


######################################################################
# Configuración de SVM
######################################################################
svm = cv.ml.SVM_create()

svm.setType(cv.ml.SVM_C_SVC)

svm.setTermCriteria((cv.TERM_CRITERIA_MAX_ITER, 100, 1e-6))

#Elección del kernel
svm.setKernel(cv.ml.SVM_LINEAR)
#svm.setKernel( cv.ml.SVM_RBF)
svm.setGamma(0.0001)
svm.setC(100)


######################################################################
# Entrenamiento de SVM
######################################################################
svm.train(trainingData, cv.ml.ROW_SAMPLE, labels)
svm.save("model.xml")



######################################################################
# Visualización de entrenamiento
######################################################################

width = 512
height = 512
image = np.zeros((height, width, 3), dtype=np.uint8)

#Regiones de decisión
green = (0,255,0)
blue = (255,0,0)

for i in range(image.shape[0]):
    for j in range(image.shape[1]):
        sampleMat = np.matrix([[j,i]], dtype=np.float32)
        response = svm.predict(sampleMat)[1]
        if response == 1:
            image[i,j] = green
        elif response==-1:
            image[i,j]=blue


#Puntos de entrenamiento
thickness = -1

i=0
for P in trainingData:
    if labels[i] == 1:
        cv.circle(image, (P[0,0], P[0,1]), 5, (255, 255, 255), thickness)
    else:
        cv.circle(image, (P[0,0], P[0,1]), 5, (0, 0, 0), thickness)
    i+=1

#Vectores soporte
thickness = 2
if svm.getKernelType() == cv.ml.SVM_LINEAR:
    sv = svm.getUncompressedSupportVectors()
else:
    sv = svm.getSupportVectors()

print('\nVectores Soporte\n',sv)

for i in range(sv.shape[0]):
    cv.circle(image, (sv[i,0], sv[i,1]), 6, (0, 0, 255), thickness)



cv.imwrite('Resultado.png', image) 

elapsed_time = time.time() - start_time
print("Tiempo consumido: ",elapsed_time)

cv.imshow('SVM Simple Example', image)
cv.waitKey()
cv.destroyAllWindows()
