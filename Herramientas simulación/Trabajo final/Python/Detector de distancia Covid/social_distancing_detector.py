# -*- coding: utf-8 -*-
# USAGE
# python social_distance_detector.py --image imagen1.jpg
# python social_distance_detector.py --video pedestrians.mp4

# import the necessary packages
from pyimagesearch import social_distancing_config as config
from pyimagesearch.detection import detect_object
from scipy.spatial import distance as dist
import numpy as np
import cv2
import os
import argparse

parser = argparse.ArgumentParser(description='Social distancing detector')
parser.add_argument('--image', help='Path to image file.')
parser.add_argument('--video', help='Path to video file.')
args = parser.parse_args()
     



# load the COCO class labels our YOLO model was trained on
labelsPath = os.path.sep.join([config.MODEL_PATH, "coco.names"])
LABELS = open(labelsPath).read().strip().split("\n")
#print(LABELS)

# derive the paths to the YOLO weights and model configuration
weightsPath = os.path.sep.join([config.MODEL_PATH, "yolov3.weights"])
configPath = os.path.sep.join([config.MODEL_PATH, "yolov3.cfg"])

# load our YOLO object detector trained on COCO dataset (80 classes)
print("[INFO] loading YOLO from disk...")
net = cv2.dnn.readNetFromDarknet(configPath, weightsPath)

# check if we are going to use GPU
if config.USE_GPU:
    # set CUDA as the preferable backend and target
    print("[INFO] setting preferable backend and target to CUDA...")
    net.setPreferableBackend(cv2.dnn.DNN_BACKEND_CUDA)
    net.setPreferableTarget(cv2.dnn.DNN_TARGET_CUDA)

# determine only the *output* layer names that we need from YOLO
ln = net.getLayerNames()
ln = [ln[i - 1] for i in net.getUnconnectedOutLayers()]

if (args.image):
    # Open the image file
    if not os.path.isfile(args.image):
        print("Input image file ", args.image, " doesn't exist")
    cap = cv2.VideoCapture(args.image)
    outputFile = args.image[:-4]+'_Result'+args.image[-4:]   
    
elif (args.video):
    # Open the video file
    if not os.path.isfile(args.video):
        print("Input video file ", args.video, " doesn't exist")
    cap = cv2.VideoCapture(args.video)
    outputFile = args.video[:-4]+'_out.avi'
else:
    print("You must indicate image/video")
    
width=int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height=int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
#fps=int(cap.get(cv2.CAP_PROP_FPS))
#Obtenemos el tiempo entre muestras
#time=int(1000/fps)
aspect_ratio=float(width)/float(height)
width_n=700
height_n=int(700/aspect_ratio)

# Get the video writer initialized to save the output video
if (not args.image):
    vid_writer = cv2.VideoWriter(outputFile, cv2.VideoWriter_fourcc('M','J','P','G'), 5, (width_n,height_n),True)
while cv2.waitKey(1) < 0:
    
    # get frame from the video
    ret, frame = cap.read()
    
    
    # Stop the program if reached end of video
    if not ret:
        print("Done processing !!!")
        print("Output file is stored as ", outputFile)    
        cv2.waitKey(3000)
        break
    frame = cv2.resize(frame, (width_n,height_n))
    '''
    width=int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height=int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    #fps=int(cap.get(cv2.CAP_PROP_FPS))
    #Obtenemos el tiempo entre muestras
    #time=int(1000/fps)
    aspect_ratio=float(width)/float(height)
    width_n=700
    height_n=int(700/aspect_ratio)
    frame = cv2.resize(frame, (width_n,height_n))
    '''
    font = cv2.FONT_HERSHEY_SIMPLEX

    results = detect_object(frame, net, ln, Idx=LABELS.index("person"))
    # initialize the set of indexes that violate the minimum social
    # distance
    violate = set()
        
    # ensure there are *at least* two people detections (required in
     # order to compute our pairwise distance maps)
    if len(results) >= 2:
     # extract all centroids from the results and compute the
        # Euclidean distances between all pairs of the centroids
        centroids = np.array([r[2] for r in results])
        D = dist.cdist(centroids, centroids, metric="euclidean")
        
        # loop over the upper triangular of the distance matrix
        for i in range(0, D.shape[0]):
            for j in range(i + 1, D.shape[1]):
            # check to see if the distance between any two
            # centroid pairs is less than the configured number
            # of pixels
                if D[i, j] < config.MIN_DISTANCE:
                # update our violation set with the indexes of
                # the centroid pairs
                    violate.add(i)
                    violate.add(j)
                    
    
    
    ###########################################################################
    #Draw Results
    ###########################################################################
     
    # loop over the results
    for (i, (prob, bbox, centroid)) in enumerate(results):
         pass
         #######################################################################
         #extract the bounding box, then
         #initialize the color of the annotation
         #######################################################################
         (startX, startY, endX, endY) =bbox
         color = (0,255,0)
         #######################################################################
         # if the index pair exists within the violation set, then
         # change the color
         #######################################################################
         if i in(violate):
            color = (0,0,255)
         #######################################################################
         #draw a bounding box around the person 
         #######################################################################
         cv2.rectangle(frame,(startX, startY),(endX, endY),color)
         

    # draw the total number of social distancing violations on the
	# output frame
    text = "Social Distancing Violations: {}".format(len(violate))
    
    cv2.putText(frame, text, (10, frame.shape[0] - 25),
		cv2.FONT_HERSHEY_SIMPLEX, 0.85, (0, 0, 255), 3)
    
    
    # Write the frame with the detection boxes
    if (args.image):
        cv2.imwrite(outputFile, frame.astype(np.uint8));
    else:
        vid_writer.write(frame.astype(np.uint8))

    
    
    cv2.imshow("Social distance detector",frame)
        
    
     #Capture the following frame    
    ret, frame = cap.read()
    
cap.release()
cv2.destroyAllWindows()
if (not args.image):
    vid_writer.release()

   
    
    
    

    
    
    
    
    