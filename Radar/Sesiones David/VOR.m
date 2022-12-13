clc;clear;close all;

a = 1;
b = 1;

beta = 16;
frf  = 3e3;
fs   = 3* frf; 
fid  = 300; %morse 300Hz equivale a 1020 Hz
fref = 1000;

Delta = 0; % lo que nos desviamos respecto al norte
theta = 75;

c = 3e8;

t  = 0:1/fs:5/30;
id = ones(1, length(t));

%% Transmision

somni1  = cos(2*pi*frf*t); %portadora continua
somni2  = b*cos(2*pi*fref*t + beta*cos(2*pi*30*t -deg2rad(Delta))).*cos(2*pi*frf*t); %portadora de referencia
somni3  = id.*cos(2*pi*fid*t).*cos(2*pi*frf*t); %portadora morse
sgiro   = a*cos(2*pi*frf*t); %antena de giro

stx = somni1 + somni2 + somni3 + sgiro;

figure()
plot((-fs/2:fs/1024:(fs/2)-(fs/1024)), fftshift(abs(fft(stx,1024)).^2));
title('Señal transmitida');

%% Recepción

srx1 = somni1 + somni2 + somni3;
srx2 = sgiro .*cos(2*pi*30*t-deg2rad(theta));
srx  = srx1 + srx2;

figure();
plot((-fs/2:fs/1024:(fs/2) - (fs/1024)), fftshift(abs(fft(srx,1024)).^2));
title("Señal recibida");

% Los picos que salen se deben al tener un theta de llegada. Ya que ahora
% recibimos con un ángulo, que implica recibir la señal con una determinada
% fase. Estos picos se deben a que la señal que recibimos de la  antena
% lleva el desfase propio del ángulo en que está nuestro avión.

% Una vez recibida la señal, debemos ver que hacer con ella.

%% Estimación del rumbo

% Demodulador
[num1500,den1500] = cheby2(5,30,1.5*fref*2/fs);
senal_am=amdemod(srx,frf,fs,0,0,num1500,den1500);

figure(); %Es la salida del detector. Nos llega lo TX
plot(-fs/2:fs/1024:(fs/2)-(fs/1024),fftshift(abs(fft(senal_am,1024)).^2));
title("Detector AM")


[z,p,k] = cheby2(5,30,[900*2/fs 1100*2/fs],'bandpass');
sos = zp2sos(z,p,k);
senal_ref_demod = filtfilt(sos,1,senal_am); %Demodulamos
senal_fm_demod= pmdemod(senal_ref_demod,fref,fs,1);

figure();
plot(t,senal_fm_demod,"r")
hold on
plot(t,cos(2*pi*30*t-deg2rad(Delta)),"b")

fase = pmdemod(senal_fm_demod,30,fs,1);

[z2,p2,k2] = cheby2(5,30,100*2/fs);
sos2 = zp2sos(z2,p2,k2);
senal_giro_demod = filtfilt(sos2,1,senal_am);
senal_giro_demod_sincc = senal_giro_demod - mean(senal_giro_demod);

figure();
plot(t,senal_giro_demod_sincc,"r");
hold on;
plot(t,cos(2*pi*30*t- deg2rad(theta)),"b");

fase2 = pmdemod(senal_giro_demod_sincc,30,fs,1);

fase_estimada = rad2deg(fase-fase2);
figure();
plot(t,fase_estimada);

fase_fin = mean(fase_estimada);

% Tras recibir la señal, y teniendo en cuenta que las antenas del avion
% estan en la cola, que es la zona que marca el rumbo, el piloto lo que
% tiene son 2 marcadores.
% Con el primero sintoniza la frecuencia con el VOR con quien quiere
% hablar, y luego tiene una roseta.
% De norte direccion este, tenemos:
% Norte, 
% el rumbo que llevas,
% triangulo blanco (si vamos o me voy del radiofaro) Si esta hacia abajo es
% que me voy

% El desvío del rumbo. Si el palo no esta alienado en medio no estoy yendo
% recto.

% sur
% La bandera roja seactiva si el VOR tiene algun problema o condiciones
% climatológicas adversas.

% 

%%
%%

%                                   D-VOR



% Filtro f=30Hz
% [z2,p2,k2] = cheby2(5,30,100*2/fs);
% sos2 = zp2sos(z2,p2,k2);
% senal_giro_demod = filtfilt(sos2,1,senal_am)-1;
% senal_giro_demod_sincc=senal_giro_demod-mean(senal_giro_demod);
