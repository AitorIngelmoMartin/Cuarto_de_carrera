clc;clear;

BWs = [8 11.25 14 16.5 22];

% Multiplos = [1.75 1.5 1.25 2.75 2];
% Si da múltiplos en varios, nos cogemos el primero

BW = 8;

% Como es múltiplo de 2Mhz, tenemos un n=57/50

n  = 57/50
Fs = BW*n

% Separacion entre portadoras
NFFT = 256

variacion_f = Fs/NFFT
 Tofdm      = 1/variacion_f %En micros.
 
 Thau_max = Tofdm/4
