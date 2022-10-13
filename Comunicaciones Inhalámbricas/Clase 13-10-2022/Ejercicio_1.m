clear;clc;

Fs = 64e6;

Ts = 1/Fs*1e9 %En ns
L  = 16;
variacion_de_f = Fs/L*1e-6; %En Mhz

% Las dos formas de sacar Tofdm
Tofdm = 1/variacion_de_f*100; %En ns
Tofdm = L*Ts;                 %En ns

%  1)En funcion del retardo maximo calculo el perido de simbolo ofdm
%  2)Este tofdm me define la variacion de f
%  3)¿A que velocidad quiero transmitir? - Esto lo define Fs, ya que es el
%    ancho de banda de la señal. A mayor BW mayor velodidad transmitida
%  4)L = Fs/variacion_f
%  5)Si quiero más velocidad, debo modificar el mapeador a uno más grande.
%    Es decir, aumentar V es aumentar M_mapeador

% EJERCICIO 2

% Apartado A: Tofdm y L
Fs = 10; %En Mhz
Tau_max = 2; %ns
Tofdm =4*Tau_max;

variacion_f = 1/Tofdm;

L = Fs/variacion_f;
%       o
L = Tofdm*Fs; % = Tofdm*(1/Ts)

% Apartado B: Hayar Rb en funcion de cada modulacion
    Rb_QAM   = Fs*log2(4);
    Rb_16QAM = Fs*log2(16); 
    Rb_64QAM = Fs*log2(64); 
% Apartado C: Que pasa si Tau_max disminuye a 1
% Tofdm es la mitad, variacion_f el doble, L la mitad 

% Apartado D: Tamaño de IFFT
% La IFFT debe hacerse en tamaños múltiplos de 2.
    
% EJERCICIO 3
Thau_max = 1; %En ns

% Apartado A: BW coherencia del canal y luego el BW señal de la
% subprotadora
Tofdm = 4*Thau_max; 

% BW_coherencia = 1/10*Thau_max; % No podemos seguir este criterio estricto ya que es mas pequeñ oque variacion_f
BW_coherencia = 1/Thau_max;

% Apartado B: Tofdm
variacion_f = 1/Tofdm; %Ancho de banda de la subportadora

% Apartado C : Si Rb = 5Mbps en QPSK

Rb_Mbps = 5;
M  = 4;
Fs = Rb_Mbps/log2(M);
L  = Fs/variacion_f;


% EJERCICIO 4
   

