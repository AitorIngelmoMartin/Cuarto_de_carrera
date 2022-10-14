%% SEMANA 1
% DATOS PUNTO DE ACCESO
Ptx_dBm = 17;
Gtx_dB = 5;
% DATOS ESTACIÓN MÓVIL
U_dBm = -90;%dbm
Grx_dBm = 2.14;%las ganancias son db

Rb = 6*10^6;%bps
f = 2.4;
d=500;

%PASILLO DATOS
% Apartado a)

alpha = [1.63, 2.77];
betha = [28.12, 29.27];
gamma = [2.25, 2.48];
sigma = [4.07, 7.63];

Lb = 10*alpha*log10(d) + betha + 10*gamma*log10(f);
Prx = Ptx_dBm + Gtx_dB - Lb + Grx_dBm;

% Apartado b)
Xo =  (erfcinv(2*0.9)*sqrt(2)*sigma)+Prx

% Apartado c)
Porcentaje1 = erfc((-85-Prx(1))/(sqrt(2)*sigma(1)))/2
Porcentaje2 = erfc((-85-Prx(2))/(sqrt(2)*sigma(2)))/2

% Apartado d) calculamos el radio (formula de a) y en vez de Prx pongo el umbral) al 50%

Lb_nueva = Ptx_dBm + Gtx_dB + Grx_dBm - U_dBm;

d_cobertura50 = 10.^((Lb_nueva - betha - 10*gamma*log10(f))./(10*alpha))

%Apartado e) calculamos radio al 90%

Xo2 = U_dBm -  (erfcinv(2*0.9)*sqrt(2)*sigma);

Lb_90 = Ptx_dBm + Gtx_dB + Grx_dBm - Xo2;

d_cobertura90 = 10.^((Lb_90 - betha - 10*gamma*log10(f))./(10*alpha))


%Apartado f) Ptx para d_cobertura50 al 90%

Prx = Ptx_dBm + Gtx_dB - Lb + Grx_dBm;

Ptx_necesaria = Prx + Lb - Grx_dBm

