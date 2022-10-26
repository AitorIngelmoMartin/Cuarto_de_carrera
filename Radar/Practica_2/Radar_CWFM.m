clc;clear;close all;

% Radar de onda contínua y frecuencia modulada CWFM

f0 = 28.5e9; %Hz
c  = 3e8; %m/s
lambda = c/f0; %longitud de onda (m)

w=10; % Velocidad de giro de la antena en rpm
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
%%Calculo de la frecuencia de muestreo

T_maximo = Trampa-Tutil;
R_max = c*T_maximo/2;
    % Frecuencia de batido maxima
fb_maxima =  2*R_max*deltaf/(c*Trampa);

% Gracias a nquist sacamos fs_min
fs_min = 2*fb_maxima;
% Factor de sobremuestreo. Para verle bien usamos un factor de "5"
oversamplig =5; %Solo vale para ver mejor las señales una vez dibujadas.

fs = oversamplig*fs_min;

N_muestras = floor(Tutil*fs);
%Número de muestras de cada exploracion por acimut.
velocidad_giro_grados_segundo = w/60*360; %grados/s
Grados_fila=velocidad_giro_grados_segundo * Trampa;

%% Primeros ejemplos de blancos. Simulamos la señal recibida de blancos a
% diferentes distancias.

% Blancos
distancia_blanco1=7e3; % distancia en m
distancia_blanco2=10e3; % distancia en m.
% distancia_blanco3= distancia_blanco2-delta_R;

% Frecuencia de batido asociada al blanco

fb_blanco1 = 2*distancia_blanco1*deltaf/(c*Trampa);
fb_blanco2 = 2*distancia_blanco2*deltaf/(c*Trampa);

% Señal recibida del blanco

n_muestra = 0:(N_muestras-1);

senal_blanco1 = exp(1i*2*pi*fb_blanco1*n_muestra/fs);
senal_blanco2 = exp(1i*2*pi*fb_blanco2*n_muestra/fs);

figure();plot(n_muestra,real(senal_blanco1));title("Parte real del eco generado por ""blanco 1"" a 7Km");

senal_suma = senal_blanco1+senal_blanco2;

figure();plot(n_muestra,real(senal_suma));title("Parte real de los ecos generados por ""Blanco 1 y Blanco 2"" a7 y 10Km");

figure();plot(n_muestra,real(abs(senal_suma)));title("Amplitud de la suma de los ecos generados por ""Blanco 1 y Blanco 2"" a7 y 10Km");

%% Estimación de la distancia a la que están los blancos

% Vamos a hacer la FFT.
salida_fft=fft(senal_suma); %En realidad tenemos muestras de la transformada de fourier. n muestras.

eje_fb = n_muestra*fs/N_muestras;

eje_Rb = c*Trampa/(2*deltaf) * eje_fb %Hacemos el escalado de frecuencia a distancias [*]

acimut    = 0:Grados_fila:20-Grados_fila;
figure(); 
plot(eje_Rb,abs(salida_fft)) %Nos da una sinc, no una delta. La X = K-1
% Esto nos va a sacar el eje X en frecuencias "n_muestra*fs/N_muestras"
% Ahora la y es la frecuencia fk(foto movil 1).
% [*]


