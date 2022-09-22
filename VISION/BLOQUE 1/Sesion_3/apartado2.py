import cv2

cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)

copias_rgb = []
def extraccion_canales(imagen):
    blue = imagen.copy()
    # Extraigo el canal azúl
    blue[:, :, 1] = 0
    blue[:, :, 2] = 0

    green = imagen.copy()
    # Extraigo el canal verde
    green[:, :, 0] = 0
    green[:, :, 2] = 0

    red = imagen.copy()
    # Extraigo el canal rojo
    red[:, :, 0] = 0
    red[:, :, 1] = 0
    return blue, green, red

while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()
    # Our operations on the frame come here
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    # Display the resulting frame
    cv2.imshow('frame',gray)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        copia_frame = frame.copy()
        copias_rgb = extraccion_canales(copia_frame)
        
        concatenacion_horizontal_1 = cv2.hconcat([frame,copias_rgb[0]])
        concatenacion_horizontal_2 = cv2.hconcat([copias_rgb[1],copias_rgb[2]])
        concatenacion_final        = cv2.vconcat([concatenacion_horizontal_1,concatenacion_horizontal_2])
        
        cv2.imwrite("Aitor.png",concatenacion_final)
        break
# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()