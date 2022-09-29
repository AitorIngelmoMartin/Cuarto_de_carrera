clc;clear;

% Escenario de oficinas
Plantas_maximas = 2;
Separacion_maxima = 10; % En metros
f = 2400; %En Mhz


% Tabulado 2.4Ghz en oficinas
N_2con4Ghz = 30;
% tabulado 2.4Ghz oficinas
Lf_24Ghz_dB = 14;

Ltotal_2con4Ghz_dB = 20*log10(f) + N_2con4Ghz*log10(Separacion_maxima) + Lf_24Ghz_dB - 28

f = 5000;
% Tabulado 2.4Ghz en oficinas
N_5Ghz = 31;

Lf_5Ghz_dB = 28;

Ltotal_5Ghz_dB = 20*log10(f) + N_5Ghz*log10(Separacion_maxima)  + Lf_5Ghz_dB - 28



%                       MODELO 1225

f = 2.4e9;
lambda = 3e8/f;
Lbf_dB = 20*log10((4*pi*Separacion_maxima)/lambda);

% 2.4 da 140.8 y a 5 da 147


 