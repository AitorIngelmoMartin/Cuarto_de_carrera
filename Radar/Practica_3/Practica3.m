clc;clear;close all;
load('ficheros_clutter.mat')
% % Nos interesa conocer el clutter para eliminarlo o como poco reducirlo.
% 
% % Cada 
 coef_correlacion=[8, 9, 99, 9999];
% % for valor=1:4
% %  nombre_matriz=['clutter_CNR30dB_0' , num2str(coef_correlacion(valor)), '_0']
% %  figure()
% %  representa=['imagesc(20*log10(abs(', nombre_matriz, ')))'];
% %  eval(representa);
% %  titulo=['CNR=30dB, \rho_c=0.', num2str(coef_correlacion(valor))]
% %  title(titulo);
% % end
% % figure(); imagesc(20*log10(abs(clutter_CNR30dB_099_015)));
% % title(titulo);
% 
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

% nombre_matriz = 'clutter_CNR30dB_099_015';
%  eval(['matriz_aux=' nombre_matriz, ';']);
% 
%  for columna=1:600
%      correlacion_columnas(:,columna)=xcorr(matriz_aux(:,columna),'unbiased');
%  end
%  for columna=1:600
%      correlacion_columnas(:,columna)=xcorr(clutter_CNR30dB_099_015(:,columna),'unbiased');
%  end
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
% 
% 
% nombre_matriz = 'clutter_CNR30dB_099_025';
%  eval(['matriz_aux=' nombre_matriz, ';']);
% 
%  for columna=1:600
%      correlacion_columnas(:,columna)=xcorr(matriz_aux(:,columna),'unbiased');
%  end
%  for columna=1:600
%      correlacion_columnas(:,columna)=xcorr(clutter_CNR30dB_099_015(:,columna),'unbiased');
%  end
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
% 
% %  for columna=1:600
% %     correlacion_columnas(:,columna)= ...
% %     xcorr(clutter_CNR30dB_099_015 (:,columna),'unbiased');
% %  end
% % 
% %  correlacion_estimada=mean(correlacion_columnas.');
% %  correlacion_estimada_desplazada=circshift(correlacion_estimada,[0 -599]);
% %  figure(); stem(-599:599, real(correlacion_estimada))
% %  titulo=['Real(FAC), CNR=30dB, \rho_c=0.99_015'];
% %  title(titulo)
% %  figure(); plot((0:1198)/1199,real(fft(correlacion_estimada_desplazada)));
% %  titulo=['DEP, CNR=30dB, \rho_c=0.99 ¿? '];
% %  title(titulo)


CNR_dB = 30;
No = 1;
Pclutter = 2*No*10^(CNR_dB/10)

Pfa = [1e-2, 1e-4];

% for valor=1:2
%    nombre_matriz=['clutter_CNR30dB_0' , num2str(coef_correlacion(valor)), '_0']
%    ruido = randn(600,600)+1i*randn(600,600);
%    eval([ nombre_matriz '_ruido=' nombre_matriz '+ ruido;'])
%    
%    [pdf_est, ejex] = pdf_estimada(abs(matriz_aux(:).^2), 300);   
%    
%    figure()
%    plot(ejex,pdf_est);title('Valor absoluto cuadrado')
% end

   ruido = randn(600,600)+1i*randn(600,600);
   

          figure();
          hold on  
for valor=1:4
    
  nombre_matriz=['clutter_CNR30dB_0' , num2str(coef_correlacion(valor)), '_0']
  ruido = randn(600,600)+1i*randn(600,600);
  eval(['matriz_aux=' nombre_matriz, ';']);

 for columna=1:600
     matriz_total(:,columna)=matriz_aux(:,columna) + ruido(:,columna) ;
 end
   [pdf_est, ejex] = pdf_estimada(abs(matriz_total(:).^2), 300);   
   

   plot(ejex,pdf_est);title('Valor absoluto cuadrado')   
 end 
    
%%% Ejercicio 3
CNR_dB = 30;
No     = 1;
Potencia_clutter = 2*No*10^(CNR_dB/10);
Pfa = [1e-2,1e-4] ;

Umbrales       = gaminv(1-Pfa,1,Potencia_clutter)
Umbrales_ruido = gaminv(1-Pfa,1,2*No)

Umbrales_totales = gaminv(1-Pfa,1,2*No+Potencia_clutter)
