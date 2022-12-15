% Entrenar red para nuevos objetos 
detector = yolov4ObjectDetector("tiny-yolov4-coco");
detector.Network;

% Cargar los datos para entrenar la red
data = load("TrainingData.mat");
trainingData = data.TrainingData;
trainingData.imageFilename = fullfile(trainingData.imageFilename);
imds = imageDatastore(trainingData.imageFilename);
blds = boxLabelDatastore(trainingData(:,2:end));
ds = combine(imds,blds);
inputSize = [224 224 3];

trainingDataForEstimation = transform(ds,@(data)preprocessData(data,inputSize));
numAnchors = 6;
[anchors, meanIoU] = estimateAnchorBoxes(trainingDataForEstimation,numAnchors);
area = anchors(:,1).*anchors(:,2);
[~,idx] = sort(area,"descend");
anchors = anchors(idx,:);
anchorBoxes = {anchors(1:3,:);anchors(4:6,:)};

classes = {'vehicle'};
detector = yolov4ObjectDetector("tiny-yolov4-coco",classes,anchorBoxes,InputSize=inputSize);
options = trainingOptions("sgdm", ...
    InitialLearnRate=0.001, ...
    MiniBatchSize=16,...
    MaxEpochs=40, ...
    BatchNormalizationStatistics="moving",...
    ResetInputNormalization=false,...
    VerboseFrequency=30);

% Ejecutar entrenamiento
trainedDetector = trainYOLOv4ObjectDetector(ds,detector,options);

% Probar la red entrenada con imagenes de prueba
photos = imageDatastore("test\");
for i = 1:length(photos.Files)
    I = imread(string(imds.Files(i)));
    [bboxes, scores, labels] = detect(trainedDetector,I,Threshold=0.05);
    detectedImg = insertObjectAnnotation(I,"Rectangle",bboxes,labels);
    figure
    imshow(detectedImg)
    pause(5)
end

% Guardar la nueva red neuronal entrenada
save trainedDetector

% Función auxiliar 
function data = preprocessData(data,targetSize)
for num = 1:size(data,1)
    I = data{num,1};
    imgSize = size(I);
    bboxes = data{num,2};
    I = im2single(imresize(I,targetSize(1:2)));
    scale = targetSize(1:2)./imgSize(1:2);
    bboxes = bboxresize(bboxes,scale);
    data(num,1:2) = {I,bboxes};
end
end