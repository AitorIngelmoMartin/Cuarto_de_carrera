clear;clc;

outputFolder = pwd;
dataURL = ('https://ssd.mathworks.com/supportfiles/radar/data/MSTAR_ClutterDataset.tar.gz');
helperDownloadMSTARClutterData(outputFolder,dataURL);

function helperDownloadMSTARClutterData(outputFolder,DataURL)
% Download the data set from the given URL to the output folder.

    radarDataTarFile = fullfile(outputFolder,'MSTAR_ClutterDataset.tar.gz');
    
    if ~exist(radarDataTarFile,'file')
        
        disp('Downloading MSTAR Clutter data (1.6 GB)...');
        websave(radarDataTarFile,DataURL);
        untar(radarDataTarFile,outputFolder);
    end
end