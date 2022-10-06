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


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% CASO 1 Y 2
Numero_simbolos = [2, 4];

Rb       = [1, 2];
roll_off = 0.2;
FEC      = 0.6;
Bits_por_chip=11;
Rchip = Bits_por_chip*Rb;

BW    = (1+roll_off)*(Rchip./log2(Numero_simbolos))*(1/FEC)
Tchip = (1./Rchip) 

% CASO 3
Numero_simbolos = 2;
Rb = 11;
Rchip = Rb;
BW    = (1+roll_off)*(Rchip./log2(Numero_simbolos))*(1/FEC)
Tchip = (1./Rchip) 
% CASO 4
Numero_simbolos = 2;
Rb = 5.5;
Rchip = 2*Rb;
BW    = (1+roll_off)*(Rchip./log2(Numero_simbolos))*(1/FEC)
Tchip = (1./Rchip) 
% Conclusion, estos cambios no me cambian BW

% % % % % % % % % % % % % % % % % % % % % % % % Ejercicio 3

% 40 canales 2 Mhz,
% Calcular periodo de simbolo en LE clase 1 y 2
Rb = [1, 2];%Mbps
Rs = Rb;
Numero_simbolo = 2;

Ts = 1./Rs %En micro segundos

f_salto = 1600;% Saltos por segundo||Comparado con Rb es lento



