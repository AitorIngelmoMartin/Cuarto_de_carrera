clc;clear;close all;
load('ficheros_clutter.mat')
% % Nos interesa conocer el clutter para eliminarlo o como poco reducirlo.

% 
% coef_correlacion=[8, 9, 99, 9999];
% for valor=1:4
%  nombre_matriz=['clutter_CNR30dB_0' , num2str(coef_correlacion(valor)), '_0']
%  figure()
%  representa=['imagesc(20*log10(abs(', nombre_matriz, ')))'];
%  eval(representa);
%  titulo=['CNR=30dB, \rho_c=0.', num2str(coef_correlacion(valor))]
%  title(titulo);
% end
% figure(); imagesc(20*log10(abs(clutter_CNR30dB_099_015)));
% title(titulo);

% %% Segunda parte

% for valor=1:4
%   nombre_matriz=['clutter_CNR30dB_0' , num2str(coef_correlacion(valor)), '_0']
%  eval(['matriz_aux=' nombre_matriz, ';']);
% 
%  for columna=1:600
%      correlacion_columnas(:,columna)=xcorr(matriz_aux(:,columna),'unbiased');
%  end
% 
%  correlacion_estimada=mean(correlacion_columnas.');
%  correlacion_estimada_desplazada=circshift(correlacion_estimada,[0 -599]);
%  figure(); stem(-599:599, real(correlacion_estimada))
%  figure(); stem(abs(correlacion_estimada))
%  titulo=['Real(FAC), CNR=30dB, \rho_c=0.'...
%      num2str(coef_correlacion(valor))];
%  title(titulo)
% figure(); plot((0:1198)/1099,real(fft(correlacion_estimada_desplazada)));
%  titulo=['DEP, CNR=30dB, \rho_c=0.' ...
%  num2str(coef_correlacion(valor))]; title(titulo)
% end 
% 
% nombre_matriz = 'clutter_CNR30dB_099_015';
%  eval(['matriz_aux=' nombre_matriz, ';']);
% 
%  for columna=1:600
%      correlacion_columnas(:,columna)=xcorr(matriz_aux(:,columna),'unbiased');
%  end
% 
% correlacion_estimada=mean(correlacion_columnas.');
%  correlacion_estimada_desplazada=circshift(correlacion_estimada,[0 -599]);
%  figure(); stem(-599:599, real(correlacion_estimada))
%  figure(); stem(abs(correlacion_estimada))
%  titulo=['Real(FAC), CNR=30dB, \rho_c=0.'...
%        num2str(coef_correlacion)];
%        title(titulo)
% figure(); plot((0:1198)/1099,real(fft(correlacion_estimada_desplazada)));
% titulo=['DEP, CNR=30dB, \rho_c=0.' ...
% num2str(coef_correlacion)]; title(titulo)

%% Filtros canceladores


%% 3. Sume ruido Gaussiano complejo de varianza 2N0=2 a las matrices de clutter. Determine los umbrales de detección a aplicar para PFA=10-2 y 10-4   

PRF=1950; %Hz de la Práctica 1
coef_correlacion=[8, 9, 99, 9999];
No=1;

% La CNR(relación clutter a ruido) se define como:

% CNR=10*log10(Pclutter/(2*No))

CNR=30; %dB

Pclutter=2*No*10^(CNR/10)

% Potencia de las muestras complejas del ruido es 2*No

% Potencia de las muestras complejas del clutter es Pclutter

%coef_correlacion=[8, 9, 99, 9999];

for valor=[1,3]

    nombre_matriz=['clutter_CNR30dB_0' , num2str(coef_correlacion(valor)), '_0']

    ruido=randn(600,600)+1i*randn(600,600);

    eval([nombre_matriz '_ruido=' nombre_matriz '+ ruido;' ])    

    figure()

    representa=['imagesc(20*log10(abs(', nombre_matriz, '_ruido)))'];

    eval(representa);

    %axis([300,360,140,300]);

    titulo=['CNR=30dB, \rho_c=0.', num2str(coef_correlacion(valor))]

    title(titulo);

end

%% Filtros canceladores

clutter_ruido_08=clutter_CNR30dB_08_0_ruido;

clutter_ruido_099=clutter_CNR30dB_099_0_ruido;

% 3 pulsos

num_pulsos=3;

Coeficientes_Cancelador=factorial(num_pulsos-1)*(-1).^(0:(num_pulsos- ... 
1))./(factorial(0:(num_pulsos-1)).*factorial(num_pulsos-1-(0:(num_pulsos- ...
1))));

Coeficientes_Cancelador_norm= ...
Coeficientes_Cancelador/sqrt(sum(abs(Coeficientes_Cancelador).^2));

% Canceladores
salida_cancelador_3pulsos_08 = filter(Coeficientes_Cancelador_norm,1,clutter_ruido_08);
salida_cancelador_3pulsos_099 = filter(Coeficientes_Cancelador_norm,1,clutter_ruido_099);

figure(); imagesc(20*log10(abs(salida_cancelador_3pulsos_08)))
titulo=['Clutter filtrado, 3 pulsos, \rho=0.8']; title(titulo)

figure(); imagesc(20*log10(abs(salida_cancelador_3pulsos_099)))
titulo=['Clutter filtrado, 3 pulsos, \rho=0.99']; title(titulo)



%9 pulsos

num_pulsos=9;
Coeficientes_Cancelador=factorial(num_pulsos-1)*(-1).^(0:(num_pulsos- ... 
1))./(factorial(0:(num_pulsos-1)).*factorial(num_pulsos-1-(0:(num_pulsos- ...
1))));

Coeficientes_Cancelador_norm= ...
Coeficientes_Cancelador/sqrt(sum(abs(Coeficientes_Cancelador).^2));

salida_cancelador_9pulsos_08 = filter(Coeficientes_Cancelador_norm,1,clutter_ruido_08);
salida_cancelador_9pulsos_099 = filter(Coeficientes_Cancelador_norm,1,clutter_ruido_099);

figure(); imagesc(20*log10(abs(salida_cancelador_9pulsos_08)))
titulo=['Clutter filtrado, 9 pulsos, \rho=0.8']; title(titulo)

figure(); imagesc(20*log10(abs(salida_cancelador_9pulsos_099)))
titulo=['Clutter filtrado, 9 pulsos, \rho=0.99']; title(titulo)

salida_cancelador_9pulsos_08(1:8, :)=[];
salida_cancelador_9pulsos_099(1:8, :)=[];

[pdf_est, ejex] = pdf_estimada(real(salida_cancelador_9pulsos_08(:)), 50);

figure()
plot(ejex,pdf_est);

hold on;
[pdf_est, ejex] = pdf_estimada(real(salida_cancelador_9pulsos_099(:)), 50);
plot(ejex,pdf_est);
legend('\rho_c=0.8','\rho_c=0.99' )



salida_cancelador=salida_cancelador_9pulsos_08;

for columna=1:600

        correlacion_salida_cancelador(:,columna)= ...
        xcorr(salida_cancelador(:,columna), 'unbiased');

end

       correlacion_salida_cancelador_suavizada= ...
        mean(correlacion_salida_cancelador.');

%         figure(); 
%         stem(-(599-8):(599-8),real(correlacion_salida_cancelador_suavizada));
% 
%         titulo=['FAC, clutter filtrado caso ' num2str(coef_correlacion(valor))];
%         title(titulo)

        correlacion_estimada_desplazada=  ...
        circshift(correlacion_salida_cancelador_suavizada,[0 -(599-8)]);

        figure(); plot((0:length(correlacion_estimada_desplazada)-1)/length(correlacion_estimada_desplazada),real(fft(real(correlacion_estimada_desplazada))))

        titulo=['Espectro, clutter filtrado caso ' num2str(coef_correlacion(valor))];

        title(titulo)