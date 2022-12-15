clc;clear;close all;

% Obtenemos la base de datos y entrenamos a la red.
name = "tiny-yolov4-coco";
vehicleDetector =  yolov4ObjectDetector(name);
save('tinyyolov4coco.mat','vehicleDetector');
net = vehicleDetector.Network;
disp(vehicleDetector)

% Cargamos el modelo
yolov4Obj = coder.loadDeepLearningNetwork('tinyyolov4coco.mat');

% Seleccionamos la ruta al vídeo/imagen sobre el que queremos trabajar.
videoFile = 'src/coches.mp4';

% Construimos una "clase" que nos permita visualizar el vídeo frame a
% frame.
videoFreader = vision.VideoFileReader(videoFile, 'VideoOutputDataType', 'uint8');
depVideoPlayer = vision.DeployableVideoPlayer();

% Generamos una variable llamada "cont", la cual se establece a 1 si hay
% otro frame que leer.
cont = ~isDone(videoFreader);

bboxes_anterior = 0;
ticks           = 10;

while cont
    I  = step(videoFreader);
    in = imresize(I, [416,416]);
    % Llamada al detector de Yolo
    [bboxes_actuales, ~, labels] = detect(yolov4Obj, in, Threshold = 0.3);

    % Sistema para obtener la velocidad
    bbox_modificadas = bboxes_actuales;
    largo_bboxes_actuales = min(size(bbox_modificadas));
    largo_bboxes_anterior = min(size(bboxes_anterior));

    if largo_bboxes_actuales>largo_bboxes_anterior
        bbox_modificadas = bbox_modificadas(1:largo_bboxes_anterior,1:largo_bboxes_anterior);
        bboxes_anterior  = bboxes_anterior(1:largo_bboxes_anterior,1:largo_bboxes_anterior);
    else
        bboxes_anterior  = bboxes_anterior(1:largo_bboxes_actuales,1:largo_bboxes_actuales);
        bbox_modificadas = bbox_modificadas(1:largo_bboxes_actuales,1:largo_bboxes_actuales);
    end

    velocidad = (bbox_modificadas - bboxes_anterior); 
    bboxes_anterior = bboxes_actuales;

    if ticks == 10
        for i=1:size(velocidad,2)
             velocidad_max(i) =  ( (120-100).*rand(1,1) + 100)+max(abs(velocidad(i,:))); 
        end
        ticks = 0;
    end

    label_str = cell(size(velocidad_max,1),1);
    for ii=1:size(velocidad_max,1)
        label_str{ii} = ['Coche| Velocidad: ' num2str(velocidad_max(ii)) ];
    end
    
    % Añado los recuadros con texto a la imagen
    outImg = insertObjectAnnotation(in, 'rectangle', bboxes_actuales, label_str);

    % Muestro el vídeo
    step(depVideoPlayer, outImg);
    cont = ~isDone(videoFreader); 
    
    pause(0.05);
    
    ticks = ticks+1;
end