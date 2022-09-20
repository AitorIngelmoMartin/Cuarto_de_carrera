import cv2

cap = cv2.VideoCapture('drop.mp4')
ret, frame = cap.read()

while(cap.isOpened() and ret):
    
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    cv2.imshow('frame',gray)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    ret, frame = cap.read()

cap.release()
cv2.destroyAllWindows()
