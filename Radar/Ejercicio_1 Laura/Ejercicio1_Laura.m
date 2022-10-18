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
Ganancia_TX=30; %dB

%% Dimensiones de la matriz radar
% Resoluciones (Ejercicio 1)

R_resolucion=c/(2*BW_senal);
Az_Resolucion=ancho_haz;

% Tamaño matriz (Ejercicio 2)
separacion_columnas=R_resolucion;
num_columnas=ceil(Rango_max_matriz/separacion_columnas)-1;
separacion_filas=giro_antena*360/PRF/60;
num_filas=ceil(Cobertura_acimut/separacion_filas);

% Tamaño de la celda de resolucion del sistema en m2 a una distancia de 5km y 15km (Ejercicio 3)
Area_celda_5km = 5000* ancho_haz*pi/180*R_resolucion;
Area_celda_15km = 15000* ancho_haz*pi/180*R_resolucion;

% Zona iluminada por el radar correspondiente a la muestra de la matriz situada en ... (Ejercicio 4)
distancia_150=150*R_resolucion;
acimut_300=300*separacion_filas;
Area_celda_300_150=distancia_150*ancho_haz*pi/180*R_resolucion;

% Número de pulsos recibidos por blanco en cada exploración (Ejercicio 5)
Tiempo_iluminacion=ancho_haz*60/(giro_antena*360);

n_pulsos=Tiempo_iluminacion*PRF;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARTE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ESTUDIO DEL RUIDO DE LA CADENA RECEPTORA

%Varianza de las componentes en fase y cuadratura del ruido
fs=10^(Fs/10); %factor de ruido expresado en unidades naturales.
No=k*T0*fs;

%Generación de la matriz radar en presencia de ruido (térmico de la cadena
%receptora)

ruido=sqrt(No)*randn(num_filas, num_columnas)+1i*sqrt(No)*randn(num_filas, num_columnas);
eje_x=(1:num_columnas)*R_resolucion/1000;%Eje de distancias en km
eje_y=(1:num_filas)*separacion_filas; %Eje de acimut en grados

figure(1)
imagesc(eje_x,eje_y,20*log10(abs(ruido))); title('Ruido')
xlabel('Distancia (km)')
ylabel('Acimut (\phi)')

[X,Y]=meshgrid(1:50,1:50);
figure(2); mesh(X,Y, transpose(20*log10(abs(ruido(1:50,1:50)))));
figure(3); mesh(X,Y, transpose((abs(ruido(1:50,1:50)))));

ruido2=randn(num_filas, num_columnas)+1i*randn(num_filas, num_columnas);

%Caractización estadística del ruido
%Estudio de la componente en fase (parte real) de las muestras
figure(4); hist(real(ruido(:)),50); title('Ruido')


[pdf_est, ejex] = pdf_estimada(real(ruido(:)), 50);
figure(5); plot(ejex,pdf_est);title('fdp de la componente en fase')

media_parte_real=mean(real(ruido(:)));
varianza_parte_real=var(real(ruido(:)));

%Estudio de la componente en cuadratura (parte imaginaria) de las muestras

[pdf_est, ejex] = pdf_estimada(real(ruido(:)), 50);
figure(6); plot(ejex,pdf_est);title('fdp de la componente en cuadratura')

media_parte_imaginaria=mean(imag(ruido(:)));
varianza_parte_imaginaria=var(imag(ruido(:)));

% Estudio de la intensidad (módulo al cuadrado) de las muestras.
[pdf_est, ejex] = pdf_estimada((abs(ruido(:))).^2, 50);
figure(7); plot(ejex,pdf_est);title('fdp de la intensidad')

media_intensidad=mean(abs(ruido(:)).^2);
varianza_intensidad=var(abs(ruido(:)).^2);

%Estudio de la amplitud (modulo) de las muestras.
[pdf_est, ejex] = pdf_estimada(abs(ruido(:)), 50);
figure(8); plot(ejex, pdf_est); title('fdp de la amplitud');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parte 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Blanco no fluctuante y radar coherente

% Blanco estacionario
SNR_estacionario=15; %dB
Er_estacionario=No*10^(SNR_estacionario/10);
vector_blanco_estacionario=sqrt(2*Er_estacionario)*exp(1i*pi/5)*ones(n_pulsos,1);
R_blanco_estacionario=5e3; %m
Acimut_blanco_estacionario=10; %grados

columna_blanco_estacionario=ceil(R_blanco_estacionario/R_resolucion);
fila_blanco_estacionario=ceil(Acimut_blanco_estacionario/separacion_filas);

ruido_blancos=ruido;

if rem(n_pulsos,2)==0
    ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_estacionario)=ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_estacionario)+vector_blanco_estacionario;
else
    ruido_blancos((fila_blanco_estacionario-fix(n_pulsos/2)):(fila_blanco_estacionario+fix(n_pulsos/2)),columna_blanco_estacionario)=ruido_blancos((fila_blanco_estacionario-fix(n_pulsos/2)):(fila_blanco_estacionario+fix(n_pulsos/2)),columna_blanco_estacionario)+vector_blanco_estacionario;
end

figure(9); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos)));title('Blanco estacionario')

%El blanco está ahora a 8km manteniendo el acimut de 10º
constante=Er_estacionario*R_blanco_estacionario^4;
Er_blanco_8km=constante/(8000^4);

vector_blanco_8km=sqrt(2*Er_blanco_8km)*exp(1i*pi/5)*ones(n_pulsos,1);

% La fila es la misma
columna_blanco_8km=ceil(8000/R_resolucion);

if rem(n_pulsos,2)==0

    ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_8km)=ruido_blancos((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_8km)+vector_blanco_8km;

else

    ruido_blancos((fila_blanco_estacionario-fix(n_pulsos/2)):(fila_blanco_estacionario+fix(n_pulsos/2)),columna_blanco_8km)=ruido_blancos((fila_blanco_estacionario-fix(n_pulsos/2)):(fila_blanco_estacionario+fix(n_pulsos/2)),columna_blanco_8km)+vector_blanco_8km;

end

figure(10); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos)));title('Blanco estacionario 8km')

SNR_blanco_8km=10*log10(Er_blanco_8km/No);


% Blanco con movimiento radial

R_blanco_radial=7e3; %m
Acimut_blanco_radial=Acimut_blanco_estacionario; %grados
v_radial=150; %km/h
Er_blanco_radial=constante/(R_blanco_radial)^4;

mov_radial_blanco=v_radial*1000/3600*Tiempo_iluminacion;
columna_blanco_radial=ceil(R_blanco_radial/R_resolucion);
fila_blanco_radial=fila_blanco_estacionario;

omega_Doppler=4*v_radial*1000/3600*pi/lambda;

vector_blanco_radial=sqrt(2*Er_blanco_radial)*exp(1i*pi/5)*exp(-1i*omega_Doppler/PRF*(0:(n_pulsos-1))).';
SNR_blanco_radial=10*log10(Er_blanco_radial/No);

if rem(n_pulsos,2)==0
    ruido_blancos((fila_blanco_radial-(n_pulsos/2)):(fila_blanco_radial+(n_pulsos/2)-1),columna_blanco_radial)=ruido_blancos((fila_blanco_radial-(n_pulsos/2)):(fila_blanco_radial+(n_pulsos/2)-1),columna_blanco_radial)+vector_blanco_radial;
else
    ruido_blancos((fila_blanco_radial-fix(n_pulsos/2)):(fila_blanco_radial+fix(n_pulsos/2)),columna_blanco_radial)=ruido_blancos((fila_blanco_radial-fix(n_pulsos/2)):(fila_blanco_radial+fix(n_pulsos/2)),columna_blanco_radial)+vector_blanco_radial;
end

figure(11); imagesc((1:num_columnas)*R_resolucion/1000,(1:num_filas)*separacion_filas,20*log10(abs(ruido_blancos))); title('Blanco estacionario+giro+radial')

% M(1)=getframe;

%% Segunda vuelta
% Blanco no fluctuante y radar coherente Segunda vuelta

ruido_blancos_vuelta2=sqrt(No)*randn(num_filas, num_columnas)+1i*sqrt(No)*randn(num_filas, num_columnas);

% Blanco estacionario
% vector_blanco_estacionario ya existe

if rem(n_pulsos,2)==0
    ruido_blancos_vuelta2((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_estacionario)=ruido_blancos_vuelta2((fila_blanco_estacionario-(n_pulsos/2)):(fila_blanco_estacionario+(n_pulsos/2)-1),columna_blanco_estacionario)+vector_blanco_estacionario;
else
    ruido_blancos_vuelta2((fila_blanco_estacionario-fix(n_pulsos/2)):(fila_blanco_estacionario+fix(n_pulsos/2)),columna_blanco_estacionario)=ruido_blancos_vuelta2((fila_blanco_estacionario-fix(n_pulsos/2)):(fila_blanco_estacionario+fix(n_pulsos/2)),columna_blanco_estacionario)+vector_blanco_estacionario;
end

%El blanco está ahora a 8km con acimut inicial 10º, girnado a 1º/s

%Er_blanco_8km ya está calculado

%vector_blanco_8km esta variable ya existe

% ¿Está en la misma fila? Se está moviendo, por lo que no está en la misma fila
velocidad_giro=1; %º/s
Tiempo_vuelta_antena=60/giro_antena;
Desplazamiento_acimut=Tiempo_vuelta_antena*velocidad_giro;

fila_blanco_giro=ceil((Acimut_blanco_estacionario+Desplazamiento_acimut)/separacion_filas);

columna_blanco_8km=ceil(8000/R_resolucion);

if rem(n_pulsos,2)==0
    ruido_blancos_vuelta2((fila_blanco_giro-(n_pulsos/2)):(fila_blanco_giro+(n_pulsos/2)-1),columna_blanco_8km)=ruido_blancos_vuelta2((fila_blanco_giro-(n_pulsos/2)):(fila_blanco_giro+(n_pulsos/2)-1),columna_blanco_8km)+vector_blanco_8km;
else
    ruido_blancos_vuelta2((fila_blanco_giro-fix(n_pulsos/2)):(fila_blanco_giro+fix(n_pulsos/2)),columna_blanco_8km)=ruido_blancos_vuelta2((fila_blanco_giro-fix(n_pulsos/2)):(fila_blanco_giro+fix(n_pulsos/2)),columna_blanco_8km)+vector_blanco_8km;
end

SNR_blanco_8km=10*log10(Er_blanco_8km/No);

% Blanco con movimiento radial

R_blanco_radial=7e3; %
mov_radial_blanco=v_radial*1000/3600*Tiempo_vuelta_antena;

columna_blanco_radial=ceil((R_blanco_radial+mov_radial_blanco)/R_resolucion);
fila_blanco_radial=fila_blanco_estacionario;
Acimut_blanco_radial=Acimut_blanco_estacionario; %grados

Er_blanco_radial_vuelta2=constante/(R_blanco_radial+mov_radial_blanco)^4;

vector_blanco_radial_vuelta2=sqrt(2*Er_blanco_radial_vuelta2)*exp(1i*pi/5)*exp(-1i*omega_Doppler/PRF*(0:(n_pulsos-1))).';
SNR_blanco_radial_vuelta2=10*log10(Er_blanco_radial_vuelta2/No);

if rem(n_pulsos,2)==0
    ruido_blancos_vuelta2((fila_blanco_radial-(n_pulsos/2)):(fila_blanco_radial+(n_pulsos/2)-1),columna_blanco_radial)=ruido_blancos_vuelta2((fila_blanco_radial-(n_pulsos/2)):(fila_blanco_radial+(n_pulsos/2)-1),columna_blanco_radial)+vector_blanco_radial_vuelta2;
else
    ruido_blancos_vuelta2((fila_blanco_radial-fix(n_pulsos/2)):(fila_blanco_radial+fix(n_pulsos/2)),columna_blanco_radial)=ruido_blancos_vuelta2((fila_blanco_radial-fix(n_pulsos/2)):(fila_blanco_radial+fix(n_pulsos/2)),columna_blanco_radial)+vector_blanco_radial_vuelta2;
end

figure(12); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos_vuelta2)));title('Blanco estacionario+giro+radial, vuelta 2')

M(2)=getframe;

%% Blanco no fluctuante y radar coherente (blancos_matriz)
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

columna(1)=ceil(R_blanco_estacionario/R_resolucion);
fila(1)=ceil(Acimut_blanco_estacionario/separacion_filas);

% El blanco está ahora a 8km, con acimut inicial de 10º y girando a 1º/s

constante=Er(1)*R_blanco_estacionario^4;
Er(2)=constante/(8000^4);
theta_R(2)=pi/5;
vr(2)=0;
fila(2)=fila(1);
% La fila es la misma
columna(2)=ceil(8000/R_resolucion);

SNR_blanco_8km=10*log10(Er(2)/No);

% Blanco con movimiento radial

R_blanco_radial=7e3; %m
Acimut_blanco_radial=Acimut_blanco_estacionario; %grados
theta_R(3)=pi/5;
vr(3)=150; %km/h
Er(3)=constante/(R_blanco_radial)^4;

mov_radial_blanco=vr(3)*1000/3600*Tiempo_iluminacion;
columna(3)=ceil(R_blanco_radial/R_resolucion);
fila(3)=fila(1);

SNR_blanco_radial=10*log10(Er(3)/No);

[ruido_blancos]=blancos_matriz(Er,theta_R,vr,fila,columna,n_pulsos, ruido_blancos, f_portadora, PRF);

figure(13); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos))); title('Blancos iniciales')

%M(1)=getframe;

%% Segunda vuelta
%Blanco no fluctuante y radar coherente (blancos_matriz)

ruido_blancos_vuelta2=sqrt(No)*randn(num_filas, num_columnas)+1i*sqrt(No)*randn(num_filas, num_columnas);

%BLANCO 1: ESTACIONARIO, MANTIENE SUS VALORES Er(1), theta_R(1), vr(1),
%fila(1) y columna(1)

%BLANCO 2 MANTIENE SUS VALORES Er(2), theta_R(2), vr(2) y columna(2)

%vector_blanco_8km esta variable ya existe

% ¿Está en la misma fila? Se está moviendo, por lo que no está en la misma fila
velocidad_giro=1; %º/s
Tiempo_vuelta_antena=60/giro_antena;
Desplazamiento_acimut=Tiempo_vuelta_antena*velocidad_giro;

fila(2)=ceil((Acimut_blanco_estacionario+Desplazamiento_acimut)/separacion_filas);

SNR_blanco_8km=10*log10(Er(2)/No);

%BLANCO 3 MANTIENE SUS VALORES theta_R(2), vr(3) y fila(3)
%Blanco con movimiento radial

R_blanco_radial=7e3; %m
mov_radial_blanco=vr(3)*1000/3600*Tiempo_vuelta_antena;

columna(3)=ceil((R_blanco_radial+mov_radial_blanco)/R_resolucion);

Er(3)=constante/(R_blanco_radial+mov_radial_blanco)^4;

SNR_blanco_radial_vuelta2=10*log10(Er(3)/No);

[ruido_blancos_vuelta2]=blancos_matriz(Er,theta_R,vr,fila,columna,n_pulsos, ruido_blancos_vuelta2, f_portadora, PRF);

figure(14); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos_vuelta2))); title('Blancos, vuelta 2')


%% Tercera vuelta
%Blanco no fluctuante y radar coherente (blancos_matriz)

ruido_blancos_vuelta3=sqrt(No)*randn(num_filas, num_columnas)+1i*sqrt(No)*randn(num_filas, num_columnas);

%BLANCO 1: ESTACIONARIO, MANTIENE SUS VALORES Er(1), theta_R(1), vr(1),
%fila(1) y columna(1)

%BLANCO 2 MANTIENE SUS VALORES Er(2), theta_R(2), vr(2) y columna(2)

%vector_blanco_8km esta variable ya existe

% ¿Está en la misma fila? Se está moviendo, por lo que no está en la misma fila
velocidad_giro=1; %º/s
Tiempo_vuelta_antena=60/giro_antena;
Desplazamiento_acimut=Tiempo_vuelta_antena*velocidad_giro;

fila(3)=ceil((Acimut_blanco_estacionario+2*Desplazamiento_acimut)/separacion_filas);

SNR_blanco_8km=10*log10(Er(2)/No);

%BLANCO 3 MANTIENE SUS VALORES theta_R(2), vr(3) y fila(3)
%Blanco con movimiento radial

R_blanco_radial=7e3; %m
mov_radial_blanco=vr(3)*1000/3600*Tiempo_vuelta_antena;

columna(3)=ceil((R_blanco_radial+2*mov_radial_blanco)/R_resolucion);

Er(3)=constante/(R_blanco_radial+2*mov_radial_blanco)^4;

SNR_blanco_radial_vuelta3=10*log10(Er(3)/No);

[ruido_blancos_vuelta3]=blancos_matriz(Er,theta_R,vr,fila,columna,n_pulsos, ruido_blancos_vuelta3, f_portadora, PRF);

figure(15); imagesc(eje_x,eje_y,20*log10(abs(ruido_blancos_vuelta3))); title('Blancos, vuelta 3')
