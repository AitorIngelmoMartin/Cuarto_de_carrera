clc;clear;

Rb = 250000; %Kbps
Numero_simbolos = 4;
% Secuencia pseudoaleatoria de 32 bits para saber simbolos de 4 bits
Lchip=32;
% Apartado A: Calcular el período de chip de la señal en función del perido
% de bit.

% 4*T_bit = Lchip*Tchip
% Tchip=4*T_bit/Lchip

% Apartado B: Calcular el BW si...
alfa = 0.25;
Rs = Rb*8;
Bw_filtro = (1+alfa)*(Rs/log2(Numero_simbolos))*(1/0.87)*1.4;

% Apartado C: Calcular la banda de zigbee si Fc = 2405+5*(K-11) donde el
% valor de k es 11<=K<=26
F_inicial = 2405;
F_final   = 2480;

B_entre_portadoras = 5; %Mhz

