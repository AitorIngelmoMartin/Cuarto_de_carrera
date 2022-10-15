clear;clc;close all;
%% PARAMETROS DEL RADAR
k=1.38054e-23;% (J/K)
T0=290; % K
c=3e8; %m/s velocidad de la luz
BW_senal  = 1e6; 
ancho_haz = 1.2; %grados
giro_antena=26; %rpm
PRF=1950;%Hz
Rango_max_matriz=30*1000; %m;       60*1000/1.85200; %m
Cobertura_acimut= 120; %grados
f_portadora=2.5e9; %Hz
Fs=2.35; %dB Factor de ruido de la cadena receptora
lambda=c/f_portadora;

p_pico=1e3; %W
Ganancia_TX=30; %dB

%% Dimensiones de la matriz radar
% Resoluciones

R_resolucion  = c/(2*BW_senal)
Az_Resolucion = ancho_haz

% Tamaño matriz
separacion_columnas= R_resolucion
num_columnas= ceil(Rango_max_matriz/separacion_columnas)-1
separacion_filas= giro_antena*360/PRF/60
num_filas= ceil(Cobertura_acimut/separacion_filas)

%Número de pulsos recibidos por blanco en cada exploración
Tiempo_iluminacion=ancho_haz*60/(giro_antena*360)

n_pulsos= Tiempo_iluminacion*PRF


% Varianza de las componentes en fase y  cuadratura del ruido
No=1; 

% Generación de tres matrizes radar correspondientes a 3 vueltas de antena
% consecutivas bajo H0. 
% Es decir, la hipotesis nula es cierta = solo hay muestras de ruido

% Matriz de ruido base ||| el ",3" es para tenerlo en 3D
ruido=sqrt(No)*randn(num_filas,num_columnas,3)+1i*sqrt(No)*randn(num_filas,num_columnas,3);

eje_x=(1:num_columnas)*R_resolucion/1000; %Eje de distancias en km

eje_y=(1:num_filas)*separacion_filas;     %Eje de acimut en grados

                                                %(:,:,1) es todas las columnas y filas, de la loncha 1
figure(); imagesc(eje_x,eje_y, 20*log10(abs(ruido(:,:,1))))


%                   APARTADO 3: CALCULO DE PROBABILIDAD

Pfa = [1e-3,1e-4];

umbrales = gaminv(1-Pfa,1,2*No);

ruido_detectado_menos3 = (abs(ruido).^2)>umbrales(1);

ruido_detectado_menos4 = (abs(ruido).^2)>umbrales(2);

figure(); imagesc(eje_x,eje_y,ruido_detectado_menos3(:,:,2));colormap("gray");
figure(); imagesc(eje_x,eje_y,ruido_detectado_menos4(:,:,2));colormap("gray");
% ¿Como sabemos si en estas imagenes tengo las probabilidades introducidas?
% Una solucion sencilla es la repeticion de montecarlo. Que es repetir
% varias veces el experimento.

% Estimo la prob como: Nºcasosfavorables/nºcasosposibles

% Vamos a estimarla, por ejemplo, usando solo la 3era matriz7

Pfa_menos3_estimada = sum(ruido_detectado_menos3(:,:,3),"all")/numel(ruido_detectado_menos3(:,:,3)); %Devuelve un vector columna, que es la suma de todas las filas. Si pongo "all" solo saca un numerito
Pfa_menos4_estimada = sum(ruido_detectado_menos4(:,:,3),"all")/numel(ruido_detectado_menos4(:,:,3));


% Estimacion Pfa utilizando matriz 3D capa 1

Pfa_menos3_estimada = sum(ruido_detectado_menos3(:,:,1),"all")/numel(ruido_detectado_menos3(:,:,1)); %Devuelve un vector columna, que es la suma de todas las filas. Si pongo "all" solo saca un numerito
Pfa_menos4_estimada = sum(ruido_detectado_menos4(:,:,1),"all")/numel(ruido_detectado_menos4(:,:,1));

% Estimacion Pfa utilizando matriz 3D capa 2
Pfa_menos3_estimada = sum(ruido_detectado_menos3(:,:,2),"all")/numel(ruido_detectado_menos3(:,:,2)); %Devuelve un vector columna, que es la suma de todas las filas. Si pongo "all" solo saca un numerito
Pfa_menos4_estimada = sum(ruido_detectado_menos4(:,:,2),"all")/numel(ruido_detectado_menos4(:,:,2));

% APARTADO 4: CALCULAR ERROR DE ESTIMACION

% Error de estimacion
error_est = sqrt((1-Pfa)./(num_columnas*num_filas*3*Pfa))*100;
% Si solo uso una capa
error_est_una_capa = sqrt((1-Pfa)./(num_columnas*num_filas*Pfa))*100;