clear;clc;close all;
%% PARAMETROS DEL RADAR
k=1.38054e-23;% (J/K)
T0=290; % K
c=3e8; %m/s velocidad de la luz
BW_senal=1e6; 
ancho_haz=1.2; %grados
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

% Generación de la matriz radar en presencia de ruido (térmico de la cadena
% receptora)

% Matriz de ruido base
ruido=sqrt(No)*randn(num_filas,num_columnas)+1i*sqrt(No)*randn(num_filas,num_columnas);

eje_x=(1:num_columnas)*R_resolucion/1000; %Eje de distancias en km

eje_y=(1:num_filas)*separacion_filas; %Eje de acimut en grados

%% Blanco no fluctuante y radar coherente
ruido_blancos=ruido;
Er=zeros(1,3);
theta_R=zeros(1,3);
vr=zeros(1,3);
fila=zeros(1,3);
columna=zeros(1,3);

% Blanco estacionario
SNR_estacionario=15; %dB
Er(1)=No*10^(SNR_estacionario/10);
theta_R(1)=pi/5;
vr(1)=0;
R_blanco_estacionario=5e3; %m
Acimut_blanco_estacionario=10; %grados

columna(1)=ceil(R_blanco_estacionario/R_resolucion)
fila(1)=ceil(Acimut_blanco_estacionario/separacion_filas)

% El blanco está ahora a 8km, con acimut inicial de 10º y girando a 1º/s

constante=Er(1)*R_blanco_estacionario^4;
Er(2)=constante/(8000^4);
theta_R(2)=pi/5;
vr(2)=0;
fila(2)=fila(1);
% La fila es la misma
columna(2)=ceil(8000/R_resolucion)

SNR_blanco_8km=10*log10(Er(2)/No)

% Blanco con movimiento radial

R_blanco_radial=7e3; %m
Acimut_blanco_radial=Acimut_blanco_estacionario; %grados
theta_R(3)=pi/5;
vr(3)=150; %km/h
Er(3)=constante/(R_blanco_radial)^4;

mov_radial_blanco=vr(3)*1000/3600*Tiempo_iluminacion
columna(3)=ceil(R_blanco_radial/R_resolucion)
fila(3)=fila(1);

SNR_blanco_radial=10*log10(Er(3)/No)

[ruido_blancos]=blancos_matriz(Er,theta_R,vr,fila,columna,n_pulsos, ruido_blancos, f_portadora, PRF);

figure(); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos))); title('Blanco estacionario+giro+radial 2')

%M(1)=getframe;

%% Segunda vuelta
vr(3)=900; %Km/h
%% Blanco no fluctuante y radar coherente
ruido2 = sqrt(No)*randn(num_filas,num_columnas)+1i*sqrt(No)*randn(num_filas,num_columnas);

ruido_blancos_vuelta2= ruido2;

% BLANCO 1: ESTACIONARIO, MANTIENE SUS VALORES Er(1), theta_R(1), vr(1),
% fila(1) y columna(1)

% BLANCO 2 MANTIENE SUS VALORES Er(2), theta_R(2), vr(2)y columna(2)

% ¿Está en la misma fila?
velocidad_giro=1; %º/s
Tiempo_vuelta_antena=60/giro_antena;
Desplazamiento_acimut=Tiempo_vuelta_antena*velocidad_giro;
ceil(Desplazamiento_acimut/separacion_filas)

fila(2)=ceil((Acimut_blanco_estacionario+Desplazamiento_acimut)/separacion_filas)

SNR_blanco_8km=10*log10(Er(2)/No)
%% Tercera vuelta
vr(3)=1200; %Km/h
%% Blanco no fluctuante y radar coherente
ruido3 = sqrt(No)*randn(num_filas,num_columnas)+1i*sqrt(No)*randn(num_filas,num_columnas);

ruido_blancos_vuelta3= ruido3;

% BLANCO 1: ESTACIONARIO, MANTIENE SUS VALORES Er(1), theta_R(1), vr(1),
% fila(1) y columna(1)

% BLANCO 2 MANTIENE SUS VALORES Er(2), theta_R(2), vr(2)y columna(2)

% ¿Está en la misma fila?
velocidad_giro=1; %º/s
Tiempo_vuelta_antena=60/giro_antena;
Desplazamiento_acimut=Tiempo_vuelta_antena*velocidad_giro;
ceil(Desplazamiento_acimut/separacion_filas)

fila(2)=ceil((Acimut_blanco_estacionario+Desplazamiento_acimut)/separacion_filas)

SNR_blanco_8km=10*log10(Er(2)/No)

% BLANCO 3 MANTIENE SUS VALORES theta_R(2), vr(3) y fila(3)
% Blanco con movimiento radial

R_blanco_radial=7e3; %m
mov_radial_blanco=vr(3)*1000/3600*Tiempo_vuelta_antena;

columna(3)=ceil((R_blanco_radial+mov_radial_blanco)/R_resolucion)

Er(3)=constante/(R_blanco_radial+mov_radial_blanco)^4;

SNR_blanco_radial_vuelta2=10*log10(Er(3)/No)

[ruido_blancos_vuelta3]=blancos_matriz(Er,theta_R,vr,fila,columna,n_pulsos, ruido_blancos_vuelta3, f_portadora, PRF);

figure(); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos_vuelta3))); title('Blanco estacionario+giro+radial 3')

% save matrices_vueltas.mat ruido_blancos ruido_blancos_vuelta2


%% UMBRALES DE DETECCIÓN

% 1. Aplicamos detector de envolvente de ley cuadrática

salida_detector=abs(ruido).^2;

Pfa=1e-4;

umbral_menos4=gaminv(1-Pfa,1,2*No);
Pfa = 1e-3;
umbral_menos3=gaminv(1-Pfa,1,2*No);
detector_umbral_menos3=salida_detector>umbral_menos3;
detector_umbral_menos4=salida_detector>umbral_menos4;

figure(); imagesc(eje_x,eje_y,detector_umbral_menos3); colormap('gray'); title('Salida del comparador 3 P_{FA}=10^{-3}')

figure(); imagesc(eje_x,eje_y,detector_umbral_menos4); colormap('gray'); title('Salida del comparador 4 P_{FA}=10^{-4}')

salida_detector_blancos =abs(ruido_blancos).^2;

detector_umbral_menos3=salida_detector_blancos>umbral_menos3;
detector_umbral_menos4=salida_detector_blancos>umbral_menos4;

figure(); imagesc(eje_x,eje_y,detector_umbral_menos3); colormap('gray'); title('Salida del comparador 3 P_{FA}=10^{-3}')

figure(); imagesc(eje_x,eje_y,detector_umbral_menos4); colormap('gray'); title('Salida del comparador 4 P_{FA}=10^{-4}')



% % % % % % 

salida_detector_blancos =abs(ruido_blancos_vuelta2).^2;

detector_umbral_menos3=salida_detector_blancos>umbral_menos3;
detector_umbral_menos4=salida_detector_blancos>umbral_menos4;

figure(); imagesc(eje_x,eje_y,detector_umbral_menos3); colormap('gray'); title('Salida del comparador 3 P_{FA}=10^{-3}')

figure(); imagesc(eje_x,eje_y,detector_umbral_menos4); colormap('gray'); title('Salida del comparador 4 P_{FA}=10^{-4}')

