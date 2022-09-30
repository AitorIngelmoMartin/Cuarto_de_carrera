clear;clc;


% Calculo del retardo RMS

Thau       = [0, 0.4, 0.9];
Power_dB   = [0, -15, -20];
media_Thau = sum((Thau.*(10.^(Power_dB/10)))/sum(10.^(Power_dB/10)) );

Numerador   = sum( (Thau - media_Thau).^2 .* (10.^(Power_dB/10)));
Denominador = sum( 10.^(Power_dB/10) );

RMS = sqrt(Numerador/Denominador)

% Si las potencias de los retardos es alta, altera más el sistema. Por lo
% que dos canales con los mísmos retardos pueden NO ser iguales, ya que
% depende de las potencias de los multitrayectos.



%                             EJERCICIO_2

roll_off = 0.4;
Ts       = [10,1];
B_senal  = (1+roll_off)./Ts;

B_canal = [(1/(5*RMS)), (1/(50*RMS))];

% El criterio es que el Ts sea mayor a mi retardo máximo.

% PARAMETROS CLAVE: Multitrayecto, Thau_max o RMS, Tsimbolo, BWcanal y BWseñal.


%                          EJERCICIO 3


fs            = [900e6, 1.8e9, 2.5e9];
Velocidad_Kmh = [2.4, 50, 120, 200];
Velocidad_mps = Velocidad_Kmh*1000/3600;

fm = zeros(3,4) % {Fm es la variación de f=incremento_fmax}
for i = (1:size(fs,2))
   fm(i,:) =  Velocidad_mps*fs(i)/(3e8);
end
Tc = 1000*1./(fm);




