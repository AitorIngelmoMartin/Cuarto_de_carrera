clc;clear;close all;

% Vamos a usar líneas ioxodrómicas y ortodrómica para saber donde estamos

axesm('globe','Grid','on')
load coastlines
plotm(coastlat,coastlon,'b','LineWidth',2);
rloxo=track1('rh',40,-3,53);
plotm(rloxo(:,1),rloxo(:,2),'r','LineWidth',3);
rorto=track1('gc',40,-3,53);
plotm(rorto(:,1),rorto(:,2),'g','LineWidth',3);

%%Distancias

Punto_partida = [-3.170275 127.941476];
Punto_final   = [14.910616 -23.505249];

lat1 = Punto_partida(1);
lat2 = Punto_final(1);

long1 = Punto_partida(2);
long2 = Punto_final(2);

figure()
axesm ('mercator', 'Frame', 'on', 'Grid', 'on');
patchm (coastlat,coastlon,'y' )
plotm([lat1 lat2],[long1 long2],'ko')
[rutalox_lat,rutalox_long] = track('rh',[lat1 long1;lat2 long2]);
plotm(rutalox_lat,rutalox_long,'g')
[rutaorto_lat,rutaorto_long] = track('gc',[lat1 long1;lat2 long2]);
plotm(rutaorto_lat,rutaorto_long,'r')
drutalox  = distance('rh',lat1,long1,lat2,long2,earthRadius('km'));
drutaorto = distance('gc',lat1,long1,lat2,long2,earthRadius('km'));

% La verde es la mas corta, mirando la distancia. Es importante tener en
% cuenta que las rectas no son sinonimos de distancas pequeñas. Ya que el
% mapa es una proyección, y por tanto mantenemos la linea recta.

% Cualquier distancia medida de un radiofaro, es ortodrómica. Si medimos un
% rumbo, estamos a lo largo de una recta.


%%RUMBO

figure()
axesm ('mercator', 'Frame', 'on', 'Grid', 'on');
patchm (coastlat,coastlon,'y' )
rfaro=[40,-3];
medidas=[53,600];
plotm(rfaro(1),rfaro(2),'bo')

[LOPrumbo_lat,LOPrumbo_long]=track1('gc',rfaro(1),rfaro(2),medidas(1));
plotm(LOPrumbo_lat,LOPrumbo_long,'g','LineWidth',2)

[LOPdist_lat,LOPdist_long]=scircle1('gc',rfaro(1),rfaro(2),medidas(2),[],earthRadius('km'));
plotm(LOPdist_lat,LOPdist_long,'r','LineWidth',2)


% solo usamos vor/dme

rfaros=[27.933317, -15.387963;
33.371269, -7.586178;
32.697568, -16.776301];
Medidas_Rumbo = [48 - 119];
Medidas_distancia = [424 537 -];