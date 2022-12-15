% Descargar imagenes
url = 'http://download.tensorflow.org/example_images/flower_photos.tgz';
downloadFolder = tempdir;
filename = fullfile(downloadFolder,'flower_dataset.tgz');

dataFolder = fullfile(downloadFolder,'flower_photos');
if ~exist(dataFolder,'dir')
    fprintf("Descargando imagenes... ")
    websave(filename,url);
    untar(filename,downloadFolder)
    fprintf("Completado.\n")
end

imds = imageDatastore(dataFolder, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

% Crear la base de datos
imageFilename = [];
vehicle = [];
fprintf("Creando base de datos... ")
for i = 1:length(imds.Files)
    
    dir = string(imds.Files(i));
    img = imread(dir);
    [rows, columns, numberOfColorChannels] = size(img);   
    base = 0.5;
    position = {[base, base, columns, rows]};
    imageFilename = [imageFilename;dir];
    vehicle = [vehicle;position];  
end
fprintf("Completado.\n")

% Guardar la base de datos en un archivo mat
TrainingData = table(imageFilename,vehicle);
save TrainingData.mat TrainingData;
