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
    n_celdas_acimut  = ceil(Cobertura_acimut/Resolucion_angular);
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
    columna = 300;
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
ruido2 = randn(n_celdas_rango,n_celdas_acimut) *1i.*rand(n_celdas_rango,n_celdas_acimut);

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

% ARREGLO VATIABLES
R_resolucion = Resolucion_en_distancia;
separacion_filas = Separacion_filas;
n_pulsos = Numero_pulsos;

%% Blanco no fluctuante y radar coherente
% A las 16:08 cambia para abajo
ruido_blancos=ruido;

Er=zeros(1,3);

theta_R=zeros(1,3);

vr=zeros(1,3);

fila=zeros(1,3);

columna=zeros(1,3);

% Blanco estacionario

SNR_estacionario=15; %dB

Er(1)=N0*10^(SNR_estacionario/10);

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

columna(2)=ceil(8000/R_resolucion);
SNR_blanco_8km=10*log10(Er(2)/N0);

% Blanco con movimiento radial

R_blanco_radial=7e3; %m

Acimut_blanco_radial=Acimut_blanco_estacionario; %grados

theta_R(3)=pi/5;

vr(3)=150; %km/h

Er(3)=constante/(R_blanco_radial)^4;

mov_radial_blanco=vr(3)*1000/3600*Tiempo_iluminacion;

columna(3)=ceil(R_blanco_radial/R_resolucion);

fila(3)=fila(1);

SNR_blanco_radial=10*log10(Er(3)/N0);

[ruido_blancos]=blancos_matriz(Er,theta_R,vr,fila,columna,n_pulsos, ruido_blancos, f_portadora, PRF);

figure(); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos))); title('Blanco estacionario+giro+radial')


%                          PARTE 4
%                  Detector de emvolvente
absoluto = abs(ruido_blancos).^2; %Es una vbl aleatoria exponencial. Es de tipo gamma, es decir, proviene de sumar N vbl aleatorias gausianas al cuadrado de media cero e igual varianza
% Los parametros de la gamma son
%     a = N/2
%     b = 2*sigma^2, en este caso es 2*NO^2


% Tras el detector de envolvente, viene el umbral.
%     Paso 1) Genero matriz con solo ruido, por lo que H0 es cierta, ya que
%     NO hay blanco.

%   Paso 2) aplico abs al cuadrado para poder aplicar gamma
%   Paso 3) Comparo con el umbral, si es mayor al umbral pongo 1 y si es
%   menor 0.

% Para saber este valor, debemos tener en cuanta que tras abs()2 tenemos
% una exponencial. Esto implica que si coloco un valor con el que comparo,
% podemos tener falsas alarmas. Cosa que se ve rápido ya que solo tenemos
% ruido, por lo que NO hay blancos.
% Este valor se obtiene mediante un corte en la función gamma
salida_detector = absoluto
Pfa = 1e-4;
umbral = gaminv(1-Pfa,1,2*N0)
detector_umbral = salida_detector>umbral;
figure();imagesc(eje_x,eje_y,detector_umbral);colormap("gray");title("Salida")