clc;clear;close all;

% Radar de onda contínua y frecuencia modulada CWFM

f0 = 28.5e9; %Hz
c  = 3e8; %m/s
w  = 10; % Velocidad de giro de la antena en rpm
lambda = c/f0; %longitud de onda (m)


cobacimut = 20; %Cobertura en acimut de 20º

% Anchos de haz
haz_acimut    = 1; % grados
haz_elevacion = 3; %grados

%Parámetros de la señal transmitida
deltaf = 1e6; %Excursión de frecuencia [Hz]
fm     = 1e3; %Frecuencia de modulación [Hz]
eta1   = 0.9;
eta2   = eta1;

Tm = 1/fm;

Trampa = eta1*Tm;
Tutil  = eta1*eta2*Tm;



k = pi*deltaf*fm;
%% 1) Resoluciones en distancia y acimut

Resolucion_distancia = ((c*Trampa)/(2*deltaf))*(1/Tutil);

% Depende del az de la antena
Resolucion_acimut    = haz_acimut;
 %% 2) Alcance maixmo y frecuencia maxima del sistema
%  (Lo saco a partir del dibujo del guion)

T_maximo       = Trampa-Tutil;
Alcance_maximo = (c*T_maximo)/2;

    % Frecuencia de batido maxima
fb_maxima =  2*Alcance_maximo*deltaf/(c*Trampa);
%% 3) Frecuencia minima de muestreo.
% Gracias a nquist sacamos fs_min
fs_min = 2*fb_maxima;
% Factor de sobremuestreo. Para verle bien usamos un factor de "5"
oversamplig =5; %Solo vale para ver mejor las señales una vez dibujadas.

fs = oversamplig*fs_min;


N_muestras = floor(Tutil*fs);
%% 4) Distancia y velocidad radial maxima no ambigua

R_mna = c*Trampa*fs/(2*deltaf) %Tomamos como referencia una rampa incorrecta. Midiendo diferencias de frecuencias
%           Tm*Eta1=Trampa
%     velocidad radias?¿

%% 5) Numero de celdas de distancia y acimut
% Son 812 columnas. Depende del tiempo util y de la frecuencia de muestreo.
% Si aumentamos el tiempo util amentamos las muestras.

% Las celdas aximut se calculan exactamente igual que en el caso
% del radar pulsado, solo que ahora es entre rampa y rampa en lugar de pulso y pulso.

n_celdas_distancia = floor(Tutil*fs); % columnas

velocidad_giro_grados_segundo = w/60*360; %grados/s
Grados_fila=velocidad_giro_grados_segundo * Trampa;

% Angulo que gira la antena durante la transmision de la ramopa.

% Cobertura de 20º
n_celdas_acimut = floor(cobacimut/Grados_fila); %filas
%filas de nuestra matriz.

%% 6)
nrampas=floor(haz_acimut/Grados_fila);

%% 7) Frecuencias de batido correspondientes a tres blancos

distancia_blanco1 = 7e3; % distancia en m
distancia_blanco2 = 10e3; % distancia en m.
distancia_blanco3= distancia_blanco2-Resolucion_distancia;

fb1 = 2*distancia_blanco1*deltaf/(c*Trampa);
fb2 = 2*distancia_blanco2*deltaf/(c*Trampa);
fb3 = 2*distancia_blanco3*deltaf/(c*Trampa);

%% 8) Genere la matriz correspondiente a un scan con el blanco 1 situado en un acimut de 4º y
% los blancos 2 y 3 en un acimut de 9º.

% Pese a que el blanco esta a  4º, ahi ponemos el centro, y la mitad de
% pulsos arriba y abajo. Debemos calcular cuantos pulsos son estos.

%Necesito el numero de rampas con cada exploracion,es decir, numero de
%pulsos que recibo de cada blanco en cada exploración.

% BLANCO 1
Acimut_blanco1=4; % grados
Posicion_acimut_blanco1=floor(Acimut_blanco1/Grados_fila);

Matriz = zeros(n_celdas_acimut, n_celdas_distancia);

for indice1=(Posicion_acimut_blanco1-floor(nrampas/2)) : (Posicion_acimut_blanco1 ...
+ floor(nrampas/2))
    Matriz(indice1,:)= Matriz(indice1,:)+exp(1i*2*pi*fb1/fs*(0:(n_celdas_distancia)-1));
end
acimut = 0:Grados_fila:20-Grados_fila;
figure;
imagesc([],acimut,abs(Matriz));xlabel('Tiempo');
ylabel('Acimut');
title('raw data');

% BLANCO 2

Acimut_blanco2 = 9;
Acimut_blanco3 = 9;
Posicion_acimut_blanco2=floor(Acimut_blanco2/Grados_fila);
Posicion_acimut_blanco3=floor(Acimut_blanco3/Grados_fila);

for indice1=(Posicion_acimut_blanco2-floor(nrampas/2)) : (Posicion_acimut_blanco2 ...
+ floor(nrampas/2))
    Matriz(indice1,:)= Matriz(indice1,:)+exp(1i*2*pi*fb2/fs*(0:(n_celdas_distancia)-1)) + exp(1i*2*pi*fb3/fs*(0:(n_celdas_distancia)-1));
end

acimut = 0:Grados_fila:20-Grados_fila;
figure;
imagesc([],acimut,abs(Matriz));xlabel('Tiempo');
ylabel('Acimut');
title('raw data');

%% 10) Sitúe en la matriz un cuarto blanco a 12º de acimut y a una distancia de 12km que se
% acerca al radar a una velocidad radial de 4m/s.

% Blancos móviles
t=0:1/fs:((nrampas+2) *Tm);

distancia_blanco4_inicial = 12e3;
Acimut_blanco4            = 12;

Posicion_acimut_blanco4=floor(Acimut_blanco4/Grados_fila);
vr_blanco4=4; %m/s
retardo_blanco4=2*(distancia_blanco4_inicial+vr_blanco4*t)./c;

T        = mod(t,Tm);
[P,pos]  = findpeaks(T);
pos      = [1, pos];
posicion = 1;

for indice1=(Posicion_acimut_blanco4- floor(nrampas/2)):(Posicion_acimut_blanco4+floor(nrampas/2))
 % Estamos generando (rampas+1) para tener un
 % número impar de rampas (muestras en acimut por blanco).
    ajuste_indice = pos(posicion+1)-pos(posicion)-size(Matriz,2)+1;
    
    phase1 = 1i*2*pi*f0*retardo_blanco4(pos(posicion):pos...
        (posicion+1)-ajuste_indice);
    
    phase2 = -1i*k*(retardo_blanco4(pos(posicion):pos(posicion+1)- ajuste_indice).^2);
    
    phase3 = 1i*2*k*T(pos(posicion):pos(posicion+1)-ajuste_indice).*...
        retardo_blanco4(pos(posicion):pos(posicion+1)-ajuste_indice);
    
    Matriz(indice1,:) = Matriz(indice1,:)+exp(phase1+phase2+phase3);
    posicion          = posicion+1;
end
figure;
imagesc([],acimut,abs(Matriz));
xlabel('Tiempo');ylabel('Acimut'); title('raw data');

%% 9) Calcule la FFT de cada fila de la matriz generada. Represente el módulo de la FFT en
% 3D y de la FFT de la fila central de cada blanco en 2D.

for i=1:n_celdas_acimut
salida_fft(i,:)=fft(Matriz(i,1:n_celdas_distancia),...
n_celdas_distancia);
end
acimut    = 0:Grados_fila:20-Grados_fila;
distancia = (0:n_celdas_distancia-1)./(n_celdas_distancia/fs)*(c*Trampa/(2*deltaf))/1000;
figure(); imagesc(distancia,acimut,abs(salida_fft))

for fila=1:n_celdas_acimut
 salida_fft(fila,:)=fft(Matriz(fila,1:n_celdas_distancia),n_celdas_distancia);
end

figure(); imagesc(distancia,acimut,abs(salida_fft))

for columna=1:n_celdas_distancia
 fft_col(:,columna)=fft(salida_fft(:,columna),n_celdas_acimut);
end

fdoppler=(0:n_celdas_acimut-1)./(n_celdas_acimut*Tm);

figure(); imagesc(distancia,fdoppler,abs(fft_col));

fdoppler_blanco = 2*vr_blanco4/lambda

