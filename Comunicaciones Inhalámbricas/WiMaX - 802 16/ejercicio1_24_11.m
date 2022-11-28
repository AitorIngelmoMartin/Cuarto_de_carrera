clc;clear;

NFFT = 256;

Nused  = 200;
Npilot = 8;

BW_sistema = 7;


Tiempos  = [2.5, 4];
n = 8/7;

Fs = BW_sistema*n

variacion_f = Fs/NFFT

Tofdm            = 1/variacion_f %En micros.
Prefijo_ciclico  = [1/4 1/8 1/16 1/32];
Thau_max         = Tofdm/4

Tsofdm = Tofdm + 1./Prefijo_ciclico

for i =1:2
    Tramas(i,:) = (Tiempos(i) *1e-3)./(Tsofdm*1e-6)
end

