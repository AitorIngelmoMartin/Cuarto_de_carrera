clc;clear;close all

Retardos = [0, 0.6, 1, 1.25, 1.8 ]; %us
prx_dB   = [0,-3, -5, -8, -12];
prx = 10.^(prx_dB/10);
%% La dispersión del retardo del canal es la siguiente:
Thau_rms = sqrt( (sum( Retardos.^2.*prx )/sum(prx)) - ...
               ( (sum( (Retardos.*prx) )/sum(prx )).^2) )
           %Medido en micro segundos.
           

%% Definir un nuevo modelo de canal con una dispersión del retardo 0.1us mayor 
% modificando sólo los parámetros de potencia.

Thau_deseado = Thau_rms + 0.1;
prx_dB   = [0,-3, -5, -8, -12];

for i = 2:15
    prx_dB_bucle = prx_dB./i;
    prx_bucle          = 10.^(prx_dB_bucle/10);
    Thau_rms_nuevo(i,:)= sqrt( (sum( Retardos.^2.*prx_bucle )/sum(prx_bucle)) - ...
                              ( (sum( (Retardos.*prx_bucle) )/sum(prx_bucle )).^2) )

end

