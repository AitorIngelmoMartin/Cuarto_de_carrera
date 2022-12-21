clc;clear;close all;

%%Descargar toolbox
axesm('globe','Grid','on')
load coastlines
plotm(coastlat,coastlon,'b','LineWidth',2);
rloxo=track1('rh',40,-3,53);
plotm(rloxo(:,1),rloxo(:,2),'r','LineWidth',3);
rorto=track1('gc',40,-3,53);
plotm(rorto(:,1),rorto(:,2),'g','LineWidth',3);


%%RUMBO

figure()
axesm ('mercator', 'Frame', 'on', 'Grid', 'on');
patchm (coastlat,coastlon,'y')
rfaro=[40,-3];
medidas=[53,600];
plotm(rfaro(1),rfaro(2),'bo')

[LOPrumbo_lat,LOPrumbo_long]=track1('gc',rfaro(1),rfaro(2),medidas(1));
plotm(LOPrumbo_lat,LOPrumbo_long,'g','LineWidth',2)

[LOPdist_lat,LOPdist_long]=scircle1('gc',rfaro(1),rfaro(2),medidas(2),[],earthRadius('km'));
plotm(LOPdist_lat,LOPdist_long,'r','LineWidth',2)


% solo usamos vor/dme

% NO DEBEMOS BUSCAR UN ÚNICO PUNTO DE CRUCE. Ya que las medidas NO cruzan
% de forma exacta en un punto.

rfaros = [27.933317, -15.387963;
          33.371269, -7.586178;
          32.697568, -16.776301];
    
Medidas_Rumbo     = [48 0 119];
Medidas_distancia = [424 537 0];

posicion_faro_3 = rfaros(3,:);

medidas_3 = [Medidas_Rumbo(3) Medidas_distancia(3)]

figure()
axesm ('mercator', 'Frame', 'on', 'Grid', 'on');
patchm (coastlat,coastlon,'y')

plotm(posicion_faro_3(1),posicion_faro_3(2),'bo')

[LOPrumbo_lat,LOPrumbo_long]=track1('gc',posicion_faro_3(1),posicion_faro_3(2),medidas_3(1));
plotm(LOPrumbo_lat,LOPrumbo_long,'g','LineWidth',2)

% [LOPdist_lat,LOPdist_long]=scircle1('gc',posicion_faro_3(1),posicion_faro_3(2),medidas_3(2),[],earthRadius('km'));
% plotm(LOPdist_lat,LOPdist_long,'r','LineWidth',2)

%Coordenadas 2

posicion_faro_3 = rfaros(2,:);

medidas_3 = [Medidas_Rumbo(2) Medidas_distancia(2)]

plotm(posicion_faro_3(1),posicion_faro_3(2),'bo')

% [LOPrumbo_lat,LOPrumbo_long]=track1('gc',posicion_faro_3(1),posicion_faro_3(2),medidas_3(1));
% plotm(LOPrumbo_lat,LOPrumbo_long,'g','LineWidth',2)

[LOPdist_lat,LOPdist_long]=scircle1('gc',posicion_faro_3(1),posicion_faro_3(2),medidas_3(2),[],earthRadius('km'));
plotm(LOPdist_lat,LOPdist_long,'r','LineWidth',2)


%coordenadas 1

posicion_faro_3 = rfaros(1,:);

medidas_3 = [Medidas_Rumbo(1) Medidas_distancia(1)]

plotm(posicion_faro_3(1),posicion_faro_3(2),'bo')

[LOPrumbo_lat,LOPrumbo_long]=track1('gc',posicion_faro_3(1),posicion_faro_3(2),medidas_3(1));
plotm(LOPrumbo_lat,LOPrumbo_long,'g','LineWidth',2)
% el vor da rumbo. EL DME distancia
[LOPdist_lat,LOPdist_long]=scircle1('gc',posicion_faro_3(1),posicion_faro_3(2),medidas_3(2),[],earthRadius('km'));
plotm(LOPdist_lat,LOPdist_long,'r','LineWidth',2)
