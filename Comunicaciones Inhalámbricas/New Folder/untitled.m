clc;clear;

Retardos =[0, 0.6, 1, 1.25, 1.8 ]; %us
prx_dB   =[0,-3, -5, -8, -12];
prx = 10.^(prx_dB/10);

Thau_max = sqrt( (sum( Retardos.^2.*prx )/sum(prx)) - ((sum( (Retardos.*prx) )/sum(prx )).^2) )