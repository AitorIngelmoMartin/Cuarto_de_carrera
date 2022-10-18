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

R_resolucion  = c/(2*BW_senal);
Az_Resolucion = ancho_haz;

% Tamaño matriz
separacion_columnas = R_resolucion;
num_columnas        = ceil(Rango_max_matriz/separacion_columnas)-1;
separacion_filas    = giro_antena*360/PRF/60;
num_filas           = ceil(Cobertura_acimut/separacion_filas);

%Número de pulsos recibidos por blanco en cada exploración
Tiempo_iluminacion = ancho_haz*60/(giro_antena*360);

n_pulsos = Tiempo_iluminacion*PRF;

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

ruido = sqrt(No)*randn(num_filas,num_columnas) + 1i*sqrt(No)*randn(num_filas,num_columnas);

fun = @ (x) (sum(x));
ruido_integrado=nlfilter(ruido,[n_pulsos 1],fun);

figure(); imagesc(eje_x,eje_y,10*log10(abs(ruido)).^2);
title("Intensidad del ruido")


figure(); imagesc(eje_x,eje_y,10*log10(abs(ruido_integrado)).^2);
title("Intensidad del ruido integrado")
% Los valores próximos se parecen mucho. Esto es porque aparece una

% correlacionn a lo largo de las columnas.
% 
% ruido_integrado_maspulsos =nfilter(ruido,[5*n_pulsos 1],fun);
% 
% 
% figure(); imagesc(eje_x,eje_y,10*log10(abs(ruido_integrado_maspulsos)).^2);
% titile("Intensidad del ruido integrado 5*n pulsos")

% muchas mas cosas .Por eso aqui vemos mejor la estructura vertical.
% Esto se conoce como correlación a lo largo de cada columna, ya que cad
% acolumna es filtrada de forma independiente


varianza_real_integrado = var(real(ruido_integrado(:)))
% Ahora N(0,15*No)+jN(0,15*No) ?¿?¿?¿


% SNR15Pulsos = 10log10(15*15*Er/15/No)
% Vamos a comprobar que tenemos la Ganancia de integracion.

% % % % % %  ESTIMACION DE LA PROB DETECCION(Pd) PARA EL DETECTOR
% COHERENTE/// INTEGRADOR COHERENTE SEGUIDO DEL DETECTOR DE ENVOLVENTE DE
% LEY CUADRÁTICA

SNR = -30:0.5:30; %dB
Er  = 10.^(SNR/10);

%Paso la SNR en dB a unidades naturales teniendo en cuenta que
% N0=1.

Pfas     = [1e-2, 1e-4];
% Umbrales = gaminv(1-Pfas,1,2*No);
Umbrales_integrador = gaminv(1-Pfas,1,2*No*n_pulsos);
%Estimador de la probabilidad para el detector coherente
%IQ(real-imaginaria/modulo-fase) seguiodo del detector envolvente de ley
%cuadrático

Pd_estimada_integrador = zeros(length(Er),length(Pfas));

for valor_Pfa=1: length(Pfas)
    
     for valor_SNR=1:length(SNR)
         
         ruido_Pd = randn(n_pulsos,10000)+1i*randn(n_pulsos,10000);
         blanco   = sqrt(2*Er(valor_SNR))*exp(1i*pi/5); %Es un blanco estacionario
         
         ruido_blanco_Pd   = ruido_Pd+blanco; %Sumo al ruido base el blanco

         %aplicamos el filtro integrador
         ruido_blanco_integrado = sum(ruido_blanco_Pd); %Matriz fila de la suma de las columnas.

         salida_comparador = (abs(ruido_blanco_integrado).^2)>Umbrales_integrador(valor_Pfa);
%                      fila correspondiente SNR, fila correspondiente PFa:
%                      Sumo todos los elementops de la salida del
%                      comparador, divido por el numero de elementos.
%                      Necesito una Pd por cada SNR
         Pd_estimada_integrador(valor_SNR,valor_Pfa) = sum(salida_comparador,'all')/numel(salida_comparador);

     end %del for de SNR
end      %del for de Pfas

figure(); plot(SNR,Pd_estimada_integrador(:,1),'o'); xlabel('SNR(dB)'); % Pillo la columna 1 porque es la primera Pf
ylabel('P_D');
hold on;
plot(SNR,Pd_estimada_integrador(:,2));
legend("Pf_{Fa}=10^{-2}","Pf_{Fa}=10^{-4}","Pf_{Fa}=10^{-2} integrador", "Pf_{Fa}=10^{-4} integrador");
grid;

%Estimo la probabilidad de falsa alarma Pfa

Pfa_estimada_integrador_menos2 = sum(abs((ruido_integrado).^2) > Umbrales_integrador(1),'all')/numel(ruido_integrado)
Pfa_estimada_integrador_menos4 = sum(abs((ruido_integrado).^2) > Umbrales_integrador(2),'all')/numel(ruido_integrado)

figure(), imagesc(eje_x,eje_y,abs((ruido_integrado).^2) > Umbrales_integrador(1));colormap('gray')
figure(), imagesc(eje_x,eje_y,abs((ruido_integrado).^2) > Umbrales_integrador(2));colormap('gray')

load("matrices_vueltas.mat")


ruido_blancos_integrado         = nlfilter(ruido_blancos,[n_pulsos 1],fun);
figure(), imagesc(eje_x,eje_y,abs((ruido_blancos_integrado).^2) > Umbrales_integrador(1));colormap('gray')


ruido_blancos_vuelta2_integrado = nlfilter(ruido_blancos_vuelta2,[n_pulsos 1],fun);
figure(), imagesc(eje_x,eje_y,abs((ruido_blancos_vuelta2_integrado).^2) > Umbrales_integrador(1));colormap('gray')

% % % APARTADO GRANDE 6

P  = n_pulsos;

Vr=150; %Velocidad del blanco expresada en km/h
omega_doppler=2*2*pi*f_portadora*1e9* Vr *1000/(3600*3e8)
f_doppler=omega_doppler/(2*pi);
senal=exp(1i*(omega_doppler/PRF)*(0:200)); % generamos 201 muestras porque P son
% muy pocas
senal_norm=senal/(sum(abs(senal).^2));
Espectro_senal=(fft(senal_norm));
plot((0:200)*PRF/201,abs(Espectro_senal))
xlabel('f (Hz)');
grid
[H,W] = freqz(ones(1,P)/sqrt(P),1,200, 'whole', PRF); % Función de Transferencia del
% integrador
hold on;
plot(W,abs(H),'r')

% El filtro integrador elimina el blanco de 7. Por eso los integradores
% coherentes tienen limitaciones.
% El riesgo esta en los blancos con componente radial de velocidad.
% Quiza podemos hacerlo con menos pulsos, la banda de paso es más ancho,
% por lo que aunque tengo menos ganancia, no elimino esto. Es una cuestion
% de diseño.

% Una solucion para poder estudiar blancos en movimiento, aplicamos un
% integrador DETRAS del detector de envolvente.

%     Aplicamos el ABscuadrado primero para tener una matriz de valores
%     reales. Luego aplicamos el integrador incoherente. Es incoherente al
%     ya que solo actua sobre informacion de amplitud.
% Ahora, si tengo blancos con bajo dopler, aunque tenemos menos ganancia de
% integracion que en el coherente, si ahora tenemos una SNR de un pulso, al
% integrar,tenemos una SNR Num_pulsos menor a SNR_1Pulso
% Esto es cierto cuando se tienen blancos de dopler nulo, O con una Fdopler
% menor que la frecuencia de corte del filtro integrado. Si no se cumplen
% las dos o una de las dos, el blanco con doppler entra en la banda
% atenuada del filtro y es eliminado en el coherente, pero el incoherente
% le deja vivir.

%% Prueba del integrador incoherente

Umbrales_integrador_incoherente = gaminv(1-Pfas, n_pulsos,2*No);

ruido_blancos_integrado_incoh = nlfilter(abs(ruido_blancos).^2, [n_pulsos 1],fun);

figure(); imagesc(eje_x,eje_y,ruido_blancos_integrado_incoh>Umbrales_integrador_incoherente(1))