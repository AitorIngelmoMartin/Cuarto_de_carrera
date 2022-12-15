clc;clear;close all;

% Obtenemos la base de datos y entrenamos a la red.
name = "tiny-yolov4-coco";
Detector =  yolov4ObjectDetector(name);
save('tinyyolov4coco.mat','Detector');
net = Detector.Network;
disp(Detector)

% Cargamos el modelo
yolov4Obj = coder.loadDeepLearningNetwork('tinyyolov4coco.mat');

% Seleccionamos la ruta al vídeo/imagen sobre el que queremos trabajar.
videoFile = 'src/pedastrian.mp4';

% Construimos una "clase" que nos permita visualizar el vídeo frame a
% frame.
videoFreader = vision.VideoFileReader(videoFile, 'VideoOutputDataType', 'uint8');
depVideoPlayer = vision.DeployableVideoPlayer();

% Generamos una variable llamada "cont", la cual se establece a 1 si hay
% otro frame que leer.
cont = ~isDone(videoFreader);

while cont
    I = step(videoFreader);
    in = imresize(I, [416,416]);
    % Llamada al detector de Yolo
    [bboxes, ~, labels] = detect(yolov4Obj, in, Threshold = 0.3);
    sz = size(bboxes);
    tam = sz(1);

    % Convert categorical labels to cell array of charactor vectors
    labels = cellstr(labels);
    
    % Si se detectan dos o más personas
    if tam >= 2
        
        position = [25 370];          
        [distancingViolations,rgb] = getViolations(bboxes,tam);
        title = "Social distancing violations: " + distancingViolations;
        % Añado los recuadros con texto a la imagen
        outImg = insertObjectAnnotation(in, 'rectangle', bboxes, labels,Color=rgb);
        % Mostrar en pantalla el número de personas que están cerca
        outImg = insertText(outImg,position,title,FontSize=18,...
        BoxColor='black',BoxOpacity=0.4,TextColor="white");
          
    else
        % Colores de los recuadros de las personas
        rgb = repmat('green',tam,1);
        % Añado los recuadros con texto a la imagen
        outImg = insertObjectAnnotation(in, 'rectangle', bboxes, labels,Color=rgb);
    end    
   
    % Muestro el vídeo
    step(depVideoPlayer, outImg); 
    cont = ~isDone(videoFreader); 
    pause(0.05);     
end
close all;


% Función para calcular, las personas que estan demasiado cerca
% Devuelve el número de personas que están cerca, y 
% el color de los recuadros 
function [number,rgb] = getViolations(bboxes,tam)

index = [];
% Bucle para detectar que personas estan cerca 
for i = 1:tam
    for z = 1:tam
        if z~=i
            %compare 
            xi = bboxes(i,1);
            yi = bboxes(i,2);
            xz = bboxes(z,1);
            yz = bboxes(z,2);
            % Ecuación distancia
            ec = (xi-xz)+(yi-yz);
            distance = sqrt(abs(ec));
            if distance < 5
                % Si esta cerca,y no esta registrado, se guarda en el array
                if ismember(i,index)==0
                    index = [index, i];

                end
                if ismember(z,index)==0
                    index = [index, z];
                end
            end

        end
    end
end

number=length(index);
% Color de los recuadros (verde,por defecto/rojo,si hay algo cerca)
rgb = string(repmat('green',tam,1));
for x = 1:length(index)
    w = index(x);
    rgb(w) = 'red';
end

end