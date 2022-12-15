name = "tiny-yolov4-coco";
vehicleDetector =  yolov4ObjectDetector(name);
save('tinyyolov4coco.mat','vehicleDetector');
net = vehicleDetector.Network;
disp(vehicleDetector)

videoFile = 'src/coches.mp4';
yolov4Obj = coder.loadDeepLearningNetwork('tinyyolov4coco.mat');
videoFreader = vision.VideoFileReader(videoFile, 'VideoOutputDataType', 'uint8');
depVideoPlayer = vision.DeployableVideoPlayer();

cont = ~isDone(videoFreader);
while cont
    I = step(videoFreader);
    in = imresize(I, [416,416]);
    % Call to detect method
    [bboxes, ~, labels] = detect(yolov4Obj, in, Threshold = 0.3);
    
    % Convert categorical labels to cell array of charactor vectors
    labels = cellstr(labels);
    
    % Annotate detections in the image.
    outImg = insertObjectAnnotation(in, 'rectangle', bboxes, labels);

    step(depVideoPlayer, outImg); % display video
    cont = ~isDone(videoFreader); 
    % pause(0.05); % adjust frame rate
end
