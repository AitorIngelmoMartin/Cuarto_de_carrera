basenet = resnet50;
analyzeNetwork(basenet)
basenet.Layers(1)

imageSize = basenet.Layers(1).InputSize;
layerName = basenet.Layers(1).Name;
newinputLayer = imageInputLayer(imageSize,'Normalization','none','Name',layerName);
lgraph = layerGraph(basenet);
lgraph = removeLayers(lgraph,'ClassificationLayer_fc1000');
lgraph = replaceLayer(lgraph,layerName,newinputLayer);
dlnet = dlnetwork(lgraph);
featureExtractionLayers = ["activation_22_relu","activation_40_relu"];
classes = {'car','person'};
detector = yolov4ObjectDetector(dlnet,classes,anchorBoxes,DetectionNetworkSource=featureExtractionLayers);
disp(detector) 
analyzeNetwork(detector.Network)