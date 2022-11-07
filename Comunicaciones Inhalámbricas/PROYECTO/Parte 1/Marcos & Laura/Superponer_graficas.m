clear;clc;close all;
retardo=[0 0.6 1 1.25 1.8];
Prx=[0 -3 -5 -8 -12]; %dB
prx= 10.^(Prx./10);
K=[4 0 0 0 0];
media_x=(prx.*K)./(K+1);
varr=prx./(K+1);
var_x=varr./2;
var_y=var_x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
media_y=0;
n_muestras=1e6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trayecto 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
canal_rician1=normrnd(media_x(1),sqrt(var_x(1)),1,n_muestras)+1i*normrnd(media_y,sqrt(var_y(1)),1,n_muestras);
    
media_rician_real=mean(real(canal_rician1(:)));
media_rician_imag=mean(imag(canal_rician1(:)));   
media_rician_mod2=mean(abs(canal_rician1(:)).^2);
media_rician_mod=mean(abs(canal_rician1(:)));
    
var_rician_real=var(real(canal_rician1(:)));
var_rician_imag=var(imag(canal_rician1(:)));
var_rician_mod2=var(abs(canal_rician1(:)).^2);
var_rician_mod=var(abs(canal_rician1(:)));



figure(1);
% % % % % % % % % % HE HECHO SOLO ESTO
hold on 
[values, edges] = histcounts(abs(canal_rician1(:).^2), 'Normalization', 'probability');
centers = (edges(1:end-1)+edges(2:end))/2;
plot(centers, values)
% % % % % % % % % % % % % % % % % % % 
% 
% title('Histograma módulo canal rician 1');
% 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trayecto 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
canal_rician2=normrnd(media_x(2),sqrt(var_x(2)),1,n_muestras)+1i*normrnd(media_y,sqrt(var_y(2)),1,n_muestras);
    
media_rician_real_2=mean(real(canal_rician2(:)));
media_rician_imag_2=mean(imag(canal_rician2(:)));   
media_rician_mod2_2=mean(abs(canal_rician2(:)).^2);
media_rician_mod_2=mean(abs(canal_rician2(:)));
    
var_rician_real2=var(real(canal_rician2(:)));
var_rician_imag2=var(imag(canal_rician2(:)));
var_rician_mod2_2=var(abs(canal_rician2(:)).^2);
var_rician_mod2=var(abs(canal_rician2(:)));
    

[values, edges] = histcounts(abs(canal_rician2(:).^2), 'Normalization', 'probability');
centers = (edges(1:end-1)+edges(2:end))/2;
plot(centers, values)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trayecto 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
canal_rician3=normrnd(media_x(3),sqrt(var_x(3)),1,n_muestras)+1i*normrnd(media_y,sqrt(var_y(3)),1,n_muestras);
   
media_rician_real_3=mean(real(canal_rician3(:)));
media_rician_imag_3=mean(imag(canal_rician3(:)));   
media_rician_mod2_3=mean(abs(canal_rician3(:)).^2);
media_rician_mod_3=mean(abs(canal_rician3(:)));
    
var_rician_real3=var(real(canal_rician3(:)));
var_rician_imag3=var(imag(canal_rician3(:)));
var_rician_mod2_3=var(abs(canal_rician3(:)).^2);
var_rician_mod_3=var(abs(canal_rician3(:)));
    
[values, edges] = histcounts(abs(canal_rician3(:).^2), 'Normalization', 'probability');
centers = (edges(1:end-1)+edges(2:end))/2;
plot(centers, values)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trayecto 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
canal_rician4=normrnd(media_x(4),sqrt(var_x(4)),1,n_muestras)+1i*normrnd(media_y,sqrt(var_y(4)),1,n_muestras);
    
media_rician_real_4=mean(real(canal_rician4(:)));
media_rician_imag_4=mean(imag(canal_rician4(:)));   
media_rician_mod2_4=mean(abs(canal_rician4(:)).^2);
media_rician_mod_4=mean(abs(canal_rician4(:)));
    
var_rician_real4=var(real(canal_rician4(:)));
var_rician_imag4=var(imag(canal_rician4(:)));
var_rician_mod2_4=var(abs(canal_rician4(:)).^2);
var_rician_mod4=var(abs(canal_rician4(:)));
    
[values, edges] = histcounts(abs(canal_rician4(:).^2), 'Normalization', 'probability');
centers = (edges(1:end-1)+edges(2:end))/2;
plot(centers, values)


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trayecto 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
canal_rician5=normrnd(media_x(5),sqrt(var_x(5)),1,n_muestras)+1i*normrnd(media_y,sqrt(var_y(5)),1,n_muestras);
    
media_rician_real_5=mean(real(canal_rician5(:)));
media_rician_imag_5=mean(imag(canal_rician5(:)));   
media_rician_mod2_5=mean(abs(canal_rician5(:)).^2);
media_rician_mod_5=mean(abs(canal_rician5(:)));
    
var_rician_real5=var(real(canal_rician5(:)));
var_rician_imag5=var(imag(canal_rician5(:)));
var_rician_mod2_5=var(abs(canal_rician5(:)).^2);
var_rician_mod5=var(abs(canal_rician5(:)));

[values, edges] = histcounts(abs(canal_rician5(:).^2), 'Normalization', 'probability');
centers = (edges(1:end-1)+edges(2:end))/2;
plot(centers, values)
legend("Canal 1","Canal 2","Canal 3","Canal 4","Canal 5");title("Represencacion de la intensidad de los canales ")
