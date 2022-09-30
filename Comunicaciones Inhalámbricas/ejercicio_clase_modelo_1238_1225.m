clc;clear;

% Escenario de oficinas con 2 plantas

Separacion_Rx_Tx = 10; % En metros
f = [2400,5000];       %En Mhz

% 2.4 GHZ:
    % Tabulado 2.4Ghz en oficinas
    N_2con4Ghz = 30;
    % tabulado 2.4Ghz oficinas
    Lf_24Ghz_dB = 14;

    Ltotal_2con4Ghz_m1238_dB = 20*log10(f(1)) + N_2con4Ghz*log10(Separacion_Rx_Tx) + Lf_24Ghz_dB - 28

% 5 GHZ:
    % Tabulado 2.4Ghz en oficinas
    N_5Ghz     = 31;
    Lf_5Ghz_dB = 28;

    Ltotal_5Ghz_m1238_dB = 20*log10(f(2)) + N_5Ghz*log10(Separacion_Rx_Tx)  + Lf_5Ghz_dB - 28

%                            MODELO 1225

f      = [2.4,5]*1e9;
lambda = 3e8./f;

Lc=37;%db perdidas cte
Separacion_Rx_Tx = 10;%separacion entre tx y rx

Lbf_dB=20*log10((4*pi*Separacion_Rx_Tx)./lambda);%pérdidas en el espacio libre

Lw1 = 3.4;
Lw2 = 6.9;
kw1 = 1;
kw2 = 1;
Lf  = 18.3;
b   = 0.46;
n   = 2;

L_dB_M1225 = Lbf_dB + Lc + kw1*Lw1 + kw2*Lw2 + n^((n+2)/(n+1)-b)*Lf




 