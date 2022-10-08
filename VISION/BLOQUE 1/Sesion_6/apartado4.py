# import the necessary packages
from imutils import contours
from skimage import measure
import numpy as np
import imutils
import cv2

# Load the image,
try:
    image=cv2.imread("imagenes\lights.png", cv2.IMREAD_UNCHANGED)
except:
    print("ERROR al abrir la imagen\n")

# Convert the image to grayscale, blur it and threshold
gray    = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(gray, (11, 11), 0)
thresh  = cv2.threshold(blurred, 200, 255, cv2.THRESH_BINARY)[1]


# perform a series of erosions and dilations to remove
# any small blobs of noise from the thresholded image
thresh = cv2.erode(thresh, None, iterations=2)
thresh = cv2.dilate(thresh, None, iterations=8)

#Connected component analysis
labels = measure.label(thresh, background=0)
mask   = np.zeros(thresh.shape, dtype="uint8")

# loop over the unique components
for label in np.unique(labels):
	# if this is the background label, ignore it
     if label == 0:
	      continue
     
	 # otherwise, construct the label mask and count the
	 # number of pixels 
     labelMask = np.zeros(thresh.shape, dtype="uint8")
     labelMask[labels == label] = 255
     numPixels = cv2.countNonZero(labelMask)
     # if the number of pixels in the component is sufficiently
	 # large, then add it to our mask of "large blobs"
     print('label:%d, numPixels:%d\n'%(label,numPixels))
     ##########################################################################
     #TODO: Introduzca el valor umbral del tamaño en píxels del objeto
     #########################################################################
     if numPixels >0:
         mask = cv2.add(mask, labelMask)
     

cv2.imshow("Mask", mask)

# find the contours in the mask, then sort them from left to
# right
cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL,	cv2.CHAIN_APPROX_SIMPLE)
cnts = imutils.grab_contours(cnts)
cnts = contours.sort_contours(cnts, method="left-to-right")[0]

# Draw results 
# loop over the contours
for (i, c) in enumerate(cnts):
	# draw the bright spot on the image
	(x, y, w, h)       = cv2.boundingRect(c)
	((cX, cY), radius) = cv2.minEnclosingCircle(c)

	cv2.circle(image, (int(cX), int(cY)), int(radius), (0, 0, 255), 3)
	cv2.putText(image, "#{}".format(i + 1), (x, y - 15),cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255),1)

# show the output image
cv2.imshow("Image", image)
cv2.waitKey(0)
cv2.destroyAllWindows()
