clc;clear;close all;

%% PARAMETROS DEL RADAR
k=1.38054e-23;% (J/K)
T0=290; % K
c=3e8; %m/s velocidad de la luz
BW_senal=1e6;
ancho_haz=1.2; %grados
giro_antena=26; %rpm "vueltas por minuto"
PRF=1950;%Hz (es la frecuencia de muestreo )
Rango_max_matriz=30*1000; %m;
Cobertura_acimut= 120; %grados
f_portadora=2.5e9; %Hz
Fs=2.35; %dB Factor de ruido de la cadena receptora
lambda=c/f_portadora;
p_pico=1e3; %W
Ganancia_TX=30;         %dB

% APARTADO 1: RESOLUCION R

Resolucion_en_distancia = c/(2*BW_senal);

% BW_senal = 1/TAU

Resolucion_angular = ancho_haz;

% APARTADO 2: calcule el número de celdas de distancia, n_celdas_rango, 
% y acimut, n_celdas_acimut, para la cobertura angular especificada y una 
% distancia máxima de 30km, asumiendo que la frecuencia
% de muestreo es la mínima necesaria.

%     Los saltos entre celdas son de Resolucion_en_distancia[metros]
%     Por lo que usando la funcion ceil() podemos obtener el número entero
    n_celdas_rango  = ceil(Rango_max_matriz/Resolucion_en_distancia -1);
%   Separacion_azimut
    Separacion_filas = ((1/PRF)*giro_antena*360)/60;
    n_celdas_acimut = ceil(Cobertura_acimut/Resolucion_angular);
% APARTADO 3: Determine el tamaño de la celda de resolución del 
% sistema en m 2 a 5 y 15 km
%           Arco = Radio* ancho_haz*pi/180 * Resolucion_en_distancia [en radianes]
    
Area_arco_5_km  =  5000 *(ancho_haz*pi/180) *Resolucion_en_distancia;
Area_arco_15_km = 15000 *(ancho_haz*pi/180) *Resolucion_en_distancia;
%     Si tenemos cluter, la solucón NO es radiar con más potencia. Ya que
%     esta solucion es tipica si y solo si las perdidas provienene de la
%     cadena únicamente.
%     La solución suele ser trabajar en un mejor detector, para bajar el
%     clutter.

% APARTADO 4: Calcule la zona iluminada por el radar correspondiente a la muestra de la matriz situada en la
% columna 150 y en la fila 200.
    columna = 150;
    Distancia_a_columna = Resolucion_en_distancia * columna;
    Area_arco_columna  =  Distancia_a_columna *(ancho_haz*pi/180) *Resolucion_en_distancia;
% APARTADO 5: Calcule el número de pulsos que se reciben de un blanco en 
% una exploración. Este parámetro se denominará P.

    Tiempo_iluminacion = ancho_haz*60/(giro_antena*360);
    Numero_pulsos = PRF * Tiempo_iluminacion;
    

%                               SEGUNDA PARTE 

fs = 10^(Fs/10);
N0    = k*T0*fs;
ruido = sqrt(N0)*randn(n_celdas_rango,n_celdas_acimut) + 1i*sqrt(N0)*randn(n_celdas_rango,n_celdas_acimut);

eje_x = (1:n_celdas_rango)*Separacion_filas/1000;%eje distancias en km
eje_y = (1:n_celdas_acimut)*Resolucion_en_distancia;%eje acimut en grados
figure();
imagesc(eje_x,eje_y,20*log10(abs(ruido))); title('Ruido');
xlabel('Distancia (km)');
ylabel('Acimut (\phi)');

[X,Y]=meshgrid(1:50,1:50);
figure(); 
mesh(X,Y, transpose(20*log10(abs(ruido(1:50,1:50)))));
figure(); 
mesh(X,Y, transpose((abs(ruido(1:50,1:50)))));
ruido2 = randn(n_celdas_rango,n_celdas_acimut) *1i.*rand(n_celdas_rango,n_celdas_acimut)

% Caractirazión estadistica del ruido
% figure();hist(ruido2(:),200);title("Ruido2")


datos = real(ruido(:));
figure(), histogram(datos,50);
[h,ejex]= hist(datos,50); %divide por 20 los intervalos.
ancho_barra = ejex(2)-ejex(1);
area = ancho_barra*sum(h);
pdf_est = h./area; %diferencia de fase
% histogram(ejex,pdf_est);

media_parte_real = mean(real(ruido(:)));
varianza_parte_real = var(real(ruido(:)));
[pdf_est, ejex] = pdf_estimada((abs(ruido(:))).^2, 50);
figure();plot(ejex,pdf_est);title('fdp de la intensidad')
media_total=mean(abs(ruido(:)).^2);
varianza_total=var(abs(ruido(:)).^2)

[pdf_est, ejex] = pdf_estimada(abs(ruido(:)), 50);
figure();plot(ejex,pdf_est);title('fdp de la amplitud')

%                               TERCERA PARTE 
%                              (ruido blanco)

% Blanco estacionario
SNR_estacionario=15; %dB
Er_estacionario=N0*10^(SNR_estacionario/10);
vector_blanco_estacionario=sqrt(2*Er_estacionario)*...
exp(1i*pi/5)*ones(Numero_pulsos,1);
R_blanco_estacionario=5e3; %m
Acimut_blanco_estacionario=10; %grados
columna_blanco_estacionario=ceil(R_blanco_estacionario/...
Resolucion_en_distancia)
fila_blanco_estacionario=ceil(Acimut_blanco_estacionario/...
Separacion_filas)
ruido_blancos=ruido;

if rem(Numero_pulsos,2)==0
 ruido_blancos((fila_blanco_estacionario-(Numero_pulsos/2)):...
(fila_blanco_estacionario+(Numero_pulsos/2)-1),...
columna_blanco_estacionario)=ruido_blancos((...
fila_blanco_estacionario-(Numero_pulsos/2)):...
(fila_blanco_estacionario+(Numero_pulsos/2)-1),...
columna_blanco_estacionario)+vector_blanco_estacionario;
else
 ruido_blancos((fila_blanco_estacionario-fix(Numero_pulsos/2))...
:(fila_blanco_estacionario+fix(Numero_pulsos/2)),...
columna_blanco_estacionario)=ruido_blancos((...
fila_blanco_estacionario-fix(Numero_pulsos/2)):...
(fila_blanco_estacionario+fix(Numero_pulsos/2)),...
columna_blanco_estacionario)+vector_blanco_estacionario;
end
figure(); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos)));
title('Blanco estacionario');


constante=Er_estacionario*R_blanco_estacionario^4;

Er_blanco_8km=constante/(8000^4);

vector_blanco_8km=sqrt(2*Er_blanco_8km)*exp(1i*pi/5)*ones(Numero_pulsos,1);

% La fila es la misma

columna_blanco_8km=ceil(8000/Resolucion_en_distancia)

if rem(Numero_pulsos,2)==0

    ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_8km)=ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_8km)+vector_blanco_8km;

else

    ruido_blancos((fila_blanco_estacionario-fix(Numero_pulsos/2)):(fila_blanco_estacionario+fix(Numero_pulsos/2)),columna_blanco_8km)=ruido_blancos((fila_blanco_estacionario-fix(Numero_pulsos/2)):(fila_blanco_estacionario+fix(Numero_pulsos/2)),columna_blanco_8km)+vector_blanco_8km;

end

figure(); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos)));title('Blanco estacionario 8Km')

close all;

% Blanco a 7 Km
constante=Er_estacionario*R_blanco_estacionario^4;

Er_blanco_7km=constante/(7000^4);

vector_blanco_7km=sqrt(2*Er_blanco_7km)*exp(1i*pi/5)*ones(Numero_pulsos,1);

% La fila es la misma

columna_blanco_7km=ceil(7000/Resolucion_en_distancia)

if rem(Numero_pulsos,2)==0

    ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_7km)=ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_7km)+vector_blanco_7km;

else

    ruido_blancos((fila_blanco_estacionario-fix(Numero_pulsos/2)):(fila_blanco_estacionario+fix(Numero_pulsos/2)),columna_blanco_7km)=ruido_blancos((fila_blanco_estacionario-fix(Numero_pulsos/2)):(fila_blanco_estacionario+fix(Numero_pulsos/2)),columna_blanco_7km)+vector_blanco_7km;

end

figure(); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos)));title('Blanco estacionario 7Km')

% Cuanto se desplaza en 2.3s?
Vrblanco_Kmh = 150;
Vrblanco_mps = Vrblanco_Kmh*1000/3600;

Duracion_una_vuelta = (60*360)/(giro_antena*360);
Distancia_recorrida_metros = Vrblanco_mps * Duracion_una_vuelta


% Blanco con movimiento radial

R_blanco_radial=7e3; %m

Acimut_blanco_radial=Acimut_blanco_estacionario; %grados

v_radial=150; %km/h

Er_blanco_radial=constante/(R_blanco_radial)^4;

mov_radial_blanco=v_radial*1000/3600*Tiempo_iluminacion

columna_blanco_radial=ceil(R_blanco_radial/Resolucion_en_distancia)

fila_blanco_radial=fila_blanco_estacionario

omega_Doppler=4*v_radial*1000/3600*pi/lambda

vector_blanco_radial=sqrt(2*Er_blanco_radial)*exp(1i*pi/5)*exp(-1i*omega_Doppler/PRF*(0:(Numero_pulsos-1))).';

SNR_blanco_radial=10*log10(Er_blanco_radial/N0)

if rem(Numero_pulsos,2)==0

    ruido_blancos((fila_blanco_radial-(Numero_pulsos/2)):(fila_blanco_radial+(Numero_pulsos/2)-1),columna_blanco_radial)=ruido_blancos((fila_blanco_radial-(Numero_pulsos/2)):(fila_blanco_radial+(Numero_pulsos/2)-1),columna_blanco_radial)+vector_blanco_radial;

else

    ruido_blancos((fila_blanco_radial-fix(Numero_pulsos/2)):(fila_blanco_radial+fix(Numero_pulsos/2)),columna_blanco_radial)=ruido_blancos((fila_blanco_radial-fix(Numero_pulsos/2)):(fila_blanco_radial+fix(Numero_pulsos/2)),columna_blanco_radial)+vector_blanco_radial;

end

figure(); imagesc((1:num_columnas)*R_resolucion/1000,(1:num_filas)*separacion_filas,20*log10(abs(ruido_blancos))); title('Blanco estacionario+giro+radial')