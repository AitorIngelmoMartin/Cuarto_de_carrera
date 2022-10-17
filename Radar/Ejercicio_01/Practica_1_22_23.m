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
separacion_columnas = R_resolucion
num_columnas        = ceil(Rango_max_matriz/separacion_columnas)-1
separacion_filas    = giro_antena*360/PRF/60
num_filas           = ceil(Cobertura_acimut/separacion_filas)

%Número de pulsos recibidos por blanco en cada exploración
Tiempo_iluminacion = ancho_haz*60/(giro_antena*360)

n_pulsos = Tiempo_iluminacion*PRF

% Varianza de las componentes en fase y  cuadratura del ruido
No=1; 

% Generación de tres matrizes radar correspondientes a 3 vueltas de antena
% consecutivas bajo H0. 
% Es decir, la hipotesis nula es cierta = solo hay
% muestras de ruido

% Matriz de ruido base ||| el ",3" es para tenerlo en 3D
ruido = sqrt(No)*randn(num_filas,num_columnas,3)+1i*sqrt(No)*randn(num_filas,num_columnas,3);

eje_x = (1:num_columnas)*R_resolucion/1000; %Eje de distancias en km

eje_y = (1:num_filas)*separacion_filas; %Eje de acimut en grados
                                                %(:,:,1) es todas las columnas y filas, de la loncha 1
figure(); imagesc(eje_x,eje_y, 20*log10(abs(ruido(:,:,1))))

%                   APARTADO 3: CALCULO DE PROBABILIDAD

Pfa = [1e-3,1e-4];

umbrales =gaminv(1-Pfa,1,2*No);

ruido_detectado_menos3 = (abs(ruido).^2)>umbrales(1);

ruido_detectado_menos4 = (abs(ruido).^2)>umbrales(2);

figure(); imagesc(eje_x,eje_y,ruido_detectado_menos3(:,:,2));colormap("gray");
title("Matriz de detecciones bajo H_0, con P_{Fa} = 10^{-3}")

figure(); imagesc(eje_x,eje_y,ruido_detectado_menos4(:,:,2));colormap("gray");
title("Matriz de detecciones bajo H_0, con P_{Fa} = 10^{-4}")

% Como sabemos is en estas imagenes tengo las probabilidades introducidas?
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
error_est_matriz3D = sqrt((1-Pfa)./(num_columnas*num_filas*3*Pfa))*100;

% Si solo uso una capa
error_est_una_capa = sqrt((1-Pfa)./(num_columnas*num_filas*Pfa))*100;
error_est = sqrt((1-Pfa)./(num_columnas*num_filas*Pfa))*100;

% % % % ESTUDIO DEL VECTOR DE OBSERVACIÓN  BAJO  H1.xº
load("matrices_vueltas.mat"); %Carga ruido_blancos y ruido_blancosVuelta2


ruido_blancos_vuelta2_detectado_menos3 = (abs(ruido_blancos_vuelta2).^2)>umbrales(1);
ruido_blancos_vuelta2_detectado_menos4 = (abs(ruido_blancos_vuelta2).^2)>umbrales(2);


figure(); imagesc(eje_x,eje_y,ruido_blancos_vuelta2_detectado_menos3);colormap("gray");
title("Matriz de detecciones con blancos, con P_{Fa} = 10^{-3}")

figure(); imagesc(eje_x,eje_y,ruido_blancos_vuelta2_detectado_menos4);colormap("gray");
title("Matriz de detecciones con blancos, con P_{Fa} = 10^{-4}")

% Para estimar Pd tengo que asegurar que H1 es cierta (hay blanco).
%     Nº de unos detectados asociados a blancos / Nº de unos posibles
%     asociados a los blancos

%       15 + 10 + 4 / (15*3)

%% 

% % % % % % COPIO COSAS DE LA PAGINA 5 DE LA PRACTICA 1

SNR = 0:0.5:30; %dB
Er  = 10.^(SNR/10);

%Paso la SNR en dB a unidades naturales teniendo en cuenta que
% N0=1.

Pfas     = [1e-2, 1e-4];
Umbrales = gaminv(1-Pfas,1,2*No);

%Vector de umbrales para cada una de las Pfas que he definido

Pd_estimada = zeros(length(Er),length(Pfas));

for valor_Pfa=1: length(Pfas)
    
     for valor_SNR=1:length(SNR)
         
         ruido_Pd = randn(9,10000)+1i*randn(9,10000);
         blanco   = sqrt(2*Er(valor_SNR))*exp(1i*pi/5); %Es un blanco estacionario
         
         ruido_blanco_Pd   = ruido_Pd+blanco; %Sumo al ruido base el blanco
         salida_comparador = (abs(ruido_blanco_Pd).^2)>Umbrales(valor_Pfa);
%                      fila correspondiente SNR, fila correspondiente PFa:
%                      Sumo todos los elementops de la salida del
%                      comparador, divido por el numero de elementos.
%                      Necesito una Pd por cada SNR
         Pd_estimada(valor_SNR,valor_Pfa) = sum(salida_comparador,'all')/numel(salida_comparador);

     end %del for de SNR
end      %del for de Pfas

figure(); plot(SNR,Pd_estimada(:,1)); xlabel('SNR(dB)'); % Pillo la columna 1 porque es la primera Pf
ylabel('P_D');
hold on;
plot(SNR,Pd_estimada(:,2));
% legend("Pf_{Fa}=10^{-2}","Pf_{Fa}=10^{-4}");
grid;
% Representamos de 0 a 30 dB de SNR. Tenemos 2 curvas, correspondientes a
% cada una de las Pf.
% A menor probabilidad de error, la curva empieza conu un "offset". De
% hecho, esto se mantiene en toda la curva hasta que llega un punto en que
% satura y las dos curvas convergen en una asíntota.

%  Si bajamos la probabilidad de falsa alarma, cumplimos mejor, pero
%  empeora la capazidad de discriminación.


% Apartado 5 Represente las curvas de detección estimadas en la cuestión 4 y compárelas con las
% teóricas obtenidas en la cuestión 1.


% CALCULO CURVAS DETECCION TEÓRICAS

Pd_teorica_menos2 = 1-ncx2cdf(Umbrales(1),2,2*Er);
Pd_teorica_menos4 = 1-ncx2cdf(Umbrales(2),2,2*Er);

plot(SNR,Pd_teorica_menos2,"o"); 
plot(SNR,Pd_teorica_menos4,"s");

legend("Pf_{Fa}=10^{-2} estimación","Pf_{Fa}=10^{-4} estimación","Pf_{Fa}=10^{-2} teorica","Pf_{Fa}=10^{-4} teorica");


%% Aplicamos un filtro integrador a la matriz de ruido

ruido = sqrt(N0)*randn(num_filas,num_columnas) + 1i*sqrt(N0)*randn(num_filas,num_columnas);

fun = @ (x) (sum(x));
ruido_integrado=nlfilter(ruido,[n_pulsos 1],fun);

figure(); imagesc(eje_x,eje_y,10*log10(abs(ruido)).^2);
titile("Intensidad del ruido")


figure(); imagesc(eje_x,eje_y,10*log10(abs(ruido_integrado)).^2);
titile("Intensidad del ruido integrado")