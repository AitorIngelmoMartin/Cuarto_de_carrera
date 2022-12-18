clc;clear;close all;


frf = 1000;
fs  = 32e6;
t   = (-5):((10^6)/fs):(5+12);

t0 =0;     %Es donde lo centramos
sigma      = 3.5/(2*sqrt(2*log(2)));
envolvente = exp(-(t-t0).^2/(2*sigma^2));

pulso1 = envolvente.*cos(2*pi*frf*t);

% Generación segundo pulso
t0 = 12;   %Es donde lo centramos
envolvente = exp(-(t-t0).^2/(2*sigma^2));

pulso2 = envolvente.*cos(2*pi*frf*t);

figure()
plot(t,(pulso1+pulso2))


%% TREN DE PREGUNTAS POR SI SOLO

t = -5:((10^6)/fs):4120;

t0         = [0, 1500, 2900, 4100]
t0_segundo = t0 +12;
senal =0;
figure()
hold on
for i=1:size(t0,2)    
    envolvente = exp(-(t-t0(i)).^2/(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-t0_segundo(i)).^2/(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    senal  = senal+ pulso1 + pulso2;
end
plot(t,senal)

%% TREN DE PREGUNTAS CON RETARDOS

% TREN DE PREGUNTAS ORIGINAL
frf = 1000;
fs  = 32e6;
sigma      = 3.5/(2*sqrt(2*log(2)));


% Añado el tiempo total que necesito para considerar los retardos
Distancia_avion_transpondedor = 110; % Km
Retardo_avion_transpondedor   = (Distancia_avion_transpondedor*1E9/3E8);

tiempo_silencio  = 50;
Tiempo_adicional = 2*Retardo_avion_transpondedor + tiempo_silencio;


t = -5:((10^6)/fs):(4120+Tiempo_adicional);

t0         = [0, 1500, 2900, 4100]
t0_segundo = t0 +12;
tren_preguntas =0;

figure()
hold on

for i=1:size(t0,2)    
    envolvente = exp(-(t-t0(i)).^2/(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-t0_segundo(i)).^2/(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas  = tren_preguntas+ pulso1 + pulso2;
end

plot(t,tren_preguntas)

%% TREN DE PREGUNTAS EN TRANSPONDEDOR

tren_preguntas_retardoTx1 = 0;
for i=1:size(t0,2)    
    envolvente = exp(-(t-(t0(i)+Retardo_avion_transpondedor)).^2/(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-(t0_segundo(i)+Retardo_avion_transpondedor)).^2/(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas_retardoTx1  = tren_preguntas_retardoTx1+ pulso1 + pulso2;
end



plot(t,tren_preguntas_retardoTx1)

%% TREN DE PREGUNTAS TRAS LOS 50US DE SILENCIO

tren_preguntas_tras_silencio = 0;
for i=1:size(t0,2)    
    envolvente = exp(-(t-(t0(i)+Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-(t0_segundo(i)+Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas_tras_silencio  = tren_preguntas_tras_silencio+ pulso1 + pulso2;
end


plot(t,tren_preguntas_tras_silencio)

%% TREN DE PREGUNTAS TRAS TX2

tren_preguntas_retardoTx2 = 0;
for i=1:size(t0,2)    
    envolvente = exp(-(t-(t0(i)+2*Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-(t0_segundo(i)+2*Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas_retardoTx2  = tren_preguntas_retardoTx2+ pulso1 + pulso2;
end


plot(t,tren_preguntas_retardoTx2)
legend("Tren preguntas original","Tras retardo de Tx1","Tras tiempo de silencio","Tras retardo de Tx2");