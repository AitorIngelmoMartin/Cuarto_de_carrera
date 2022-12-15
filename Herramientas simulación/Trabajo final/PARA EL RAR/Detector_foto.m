clc;clear;

detector = yolov4ObjectDetector("csp-darknet53-coco");

disp(detector)
%analyzeNetwork(detector.Network)

img = imread("src/autopista.jpg");
[bboxes,scores,labels] = detect(detector,img);

%Display the detection results.
detectedImg = insertObjectAnnotation(img,"Rectangle",bboxes,labels);
figure
imshow(detectedImg)
