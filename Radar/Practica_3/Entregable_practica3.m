clc;clear;close all;

load('ficheros_clutter.mat')
coef_correlacion=[8, 9, 99, 9999];

for valor=1:4
    
  nombre_matriz=['clutter_CNR30dB_0' , num2str(coef_correlacion(valor)), '_0']
  ruido = randn(600,600)+1i*randn(600,600);
  eval(['matriz_aux=' nombre_matriz, ';']);

 for columna=1:600
     matriz_total(:,columna)=matriz_aux(:,columna) + ruido(:,columna) ;
 end
   [pdf_est, ejex] = pdf_estimada(abs(matriz_total(:).^2), 300);   
   figure();
   plot(ejex,pdf_est);title('Valor absoluto cuadrado')   
end 
 
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