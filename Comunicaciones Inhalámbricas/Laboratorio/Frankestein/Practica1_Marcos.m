clear, clc
%%%%Parte 1 (Oficinas)%%%%%%%
%Datos comunes
U=-90; %dBm
Grx=2.14; %dB
Ptx=17; %dBm
Gtx=5; %dB
d=500; %m
f=2.4; %GHz
Rb=6e6; %bps

alfa=[1.46, 2.46];
beta=[34.62, 29.53];
gamma=[2.03, 2.38];
sigma=[3.76, 5.04];

%% Problema 1
Lb=10*alfa*log10(d)+beta+ 10*gamma*log10(f);
Prx=Ptx+Gtx-Lb+Grx; %dBm


%% Problema 2

x0=(erfcinv(2*0.9)*sqrt(2)*sigma)+Prx;

%% Problema 3

Porcentaje1=erfc((-85-Prx(1))/(sqrt(2)*sigma(1)))/2;
Porcentaje2=erfc((-85-Prx(2))/(sqrt(2)*sigma(2)))/2;

%% Problema 4
Lb1=Ptx+Gtx+Grx-U;
d1=10^((Lb1-beta(1)-10*gamma(1)*log10(f))/(10*alfa(1)));
d2=10^((Lb1-beta(2)-10*gamma(2)*log10(f))/(10*alfa(2)));
%% Problema 5
x=U-erfcinv(2*0.9)*sqrt(2)*sigma;
Lb2=Ptx+Gtx+Grx-x;
d3=10^((Lb2(1)-beta(1)-10*gamma(1)*log10(f))/(10*alfa(1))); %LOS
d4=10^((Lb2(2)-beta(2)-10*gamma(2)*log10(f))/(10*alfa(2))); %NLOS
%% Problema 6
Pttx=x-Gtx-Grx+Lb1;


%% Parte 2 (Apartado b) %%
%Datos comunes
d_uah=26; %distancia4 en m
d_uah5=29/2; %distancia5 en m
Gtx_uah=3.5; %dB
Grx_uah=0.6323; %dB
Ptx_uah=16; %dB
Sens=-91; %dBm
Med4=-79; %dBm

%% Preguntas 1 y 2

Lb_uah=10*alfa(1)*log10(d_uah)+beta(1)+ 10*gamma(1)*log10(f);
Prx_uah=Ptx_uah+Gtx_uah-Lb_uah+Grx_uah;

Porcentaje_uah1=erfc((Sens-Prx_uah(1))/(sqrt(2)*sigma(1)))/2*100; %Porcentaje de puntos empleando la sensibilidad
Porcentaje_uah2=erfc((Med4-Prx_uah(1))/(sqrt(2)*sigma(1)))/2*100; %Porcentaje de puntos empleando la medida 4 

%% Pregunta 3

x_uah=Med4-erfcinv(2*0.95)*sqrt(2)*sigma(1);
Lb2_uah=Ptx_uah+Gtx_uah+Grx_uah-x_uah;
Radio_uah=10^((Lb2_uah(1)-beta(1)-10*gamma(1)*log10(f))/(10*alfa(1))); % Radio cobertura al 95%

%% Pregunta 4

Lb_uah5=10*alfa(1)*log10(d_uah5)+beta(1)+ 10*gamma(1)*log10(f);
Prx_uah5=Ptx_uah+Gtx_uah-Lb_uah5+Grx_uah;
Porcentaje_uah5=erfc((Sens-Prx_uah5(1))/(sqrt(2)*sigma(1)))/2*100; %Porcentaje de puntos distancia 5



