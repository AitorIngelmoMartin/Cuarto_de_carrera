clc;clear;

%% PARAMETROS DEL RADAR
k=1.38054e-23;% (J/K)
T0=290; % K
c=3e8; %m/s velocidad de la luz
BW_senal=1e6;
ancho_haz=1.2; %grados
giro_antena=26; %rpm
PRF=1950;%Hz
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
    n_celdas_acimut = ((1/PRF)*giro_antena*360)/60
%     n_celdas_acimut = 0.08;
    
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
    Area_arco_columna  =  Distancia_a_columna *(ancho_haz*pi/180) *Resolucion_en_distancia
% APARTADO 5: Calcule el número de pulsos que se reciben de un blanco en 
% una exploración. Este parámetro se denominará P.

    Tiempo_iluminacion = ancho_haz*60/(giro_antena*360);
    Numero_pulsos = PRF * Tiempo_iluminacion
    
    
%                                         parte reral        
%     sqrt(No)*rand(nceldas_acimut, nceldas_rango) +i*sqrt(No)*rand( , )

