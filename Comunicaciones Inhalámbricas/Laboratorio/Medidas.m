clc;clear;

alfa  = [1.46, 2.46];
beta  = [34.62, 29.53];
gamma = [2.03, 2.38];
Sigma = [3.76, 5.04];

f = 2.4;

d1 = [6.7, 13.4, 18];% NLOS
d4 = 26;% Pierdo señal
d5 = 29;% Distacia entre routers 

Prx_dB = [-57, -58, -79];

Ptx_dBm = 16;
Gtx_dB  = 3.5;
Grx_dB  = 0.6323;

for i = (1:size(d1,2))
   Lb_dB(i,:) = 10*alfa.*log10(d1(i))+beta+ 10*gamma*log10(f);
   Prx_dBm = Ptx_dBm + Gtx_dB  - Lb_dB + Grx_dB;
   Porcentaje_Ptx(i,:) = erfc(((Prx_dB(i)-Prx_dBm(i)))./(sqrt(2).*Sigma))./2;
end


