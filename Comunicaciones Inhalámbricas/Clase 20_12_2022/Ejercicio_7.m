clc;clear;

% Datos obtenidos del ejercicio 6
variacion_f       = 312.5*1e3; %En Khz
Prefijos_ciclicos = [0.4, 0.8];
Tofdm             = 1/variacion_f*1e6;
Tau_max_ns        = Tofdm/4 * 1e9;
% Cuantos mas usuarios el trouput baja y hay peor calidad.

% El numero de protadoras datos*2^M es el numero de bits por simbolo

Numero_portadora_datos = [48, 52, 108];
Mapeadores = [2 4 16 64];
Mapeador = max(Mapeadores);
Bits_por_portadora     = 6;
Numero_bits_simbolo = Numero_portadora_datos*Bits_por_portadora;
Tsofdm = Tofdm + Prefijos_ciclicos
R = 1./Tsofdm *1e3; % En simbolos/segundo

Rb_mbps = R.*[Numero_bits_simbolo(1), Numero_bits_simbolo(2)].*1e-3
Rb_mbps_64QAM = 3/4*7;
% SEGUNDA MITAD

% % % Da 250*280 = 72 y 277 * 288 = 80
