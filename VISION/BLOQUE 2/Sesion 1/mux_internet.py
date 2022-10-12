import cv2
import numpy as np

# Load some pre-trained data on face frontal from opencv (haar cascade algorithm)
trained_face_data = cv2.CascadeClassifier('haarcascades\haarcascade_frontalface_default.xml')

#Creamos el objeto capturador de video
cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)

while(True):
    ret, img = cap.read()
    # Must convert to greyscale
    grayscaled_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Detect Faces
    face_coordinates = trained_face_data.detectMultiScale(grayscaled_img)

    img_crop = colores = []

    # Draw rectangles around the faces
    for (x, y, w, h) in face_coordinates:
        color = tuple(np.random.choice(range(256), size=3))
        colores.append(color)
 
        cv2.rectangle(img, (x, y), (x + w, y + h), (int(color[0]),int(color[1]),int(color[2])), 2)
        img_crop.append(img[y:y + h, x:x + w])
    if cv2.waitKey(1) & 0xFF == ord('q'):
        #cv2.imwrite("Captura_detectada.png",img_out)
        break