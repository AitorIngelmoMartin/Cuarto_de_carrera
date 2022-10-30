clc;clear;close all;
mu_x = 0;
mu_y = 0;
desviacion_X = 1;
desviacion_Y = 1;
n_muestras     = 1e6;
canal_Rayleigh = normrnd(mu_x,sqrt(desviacion_X),1,n_muestras)+...
    1i*normrnd(mu_y,sqrt(desviacion_Y),1,n_muestras);  

Parte_real_Rayleigh = real(canal_Rayleigh);
Parte_imag_Rayleigh = imag(canal_Rayleigh);
Valor_absoluto_Rayleigh = abs(canal_Rayleigh);
Valor_absoluto_Rayleigh_cuadrada = abs(canal_Rayleigh).^2;
figure();
hist(Parte_real_Rayleigh,n_muestras);title("Parte real del canal Rayleigh");
figure()
hist(Parte_imag_Rayleigh,n_muestras);title("Parte imaginaria del canal Rayleigh");
figure()
hist(Valor_absoluto_Rayleigh,n_muestras);title("Valor absoluto del canal Rayleigh");
figure()
hist(Valor_absoluto_Rayleigh_cuadrada,n_muestras);title("Valor absoluto al cuadrado del canal Rayleigh");

