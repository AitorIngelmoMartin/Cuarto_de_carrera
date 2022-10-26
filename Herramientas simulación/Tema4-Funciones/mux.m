% clc;clear;
% 
% % Escriba una función que tenga como entrada dos valores y devuelva 
% % una matriz cuadrada. El primer argumento de entrada indicará el tamaño 
% % de la matriz. El segundo argumento x, servirá para calcular los elementos
% % de la matriz tal que: 
% 
% orden = 5;
x = 9
% matriz = zeros(orden);
% 
% i=1:size(matriz,1);
% vector(i) = x.^(i-1);
% for i=1:size(matriz,1)
%     matriz(i,:)=vector
% end
% matriz_prueba = [1,2,3;2,3,0;3,0,0]
% 
% 
% diag([1,0,0;1,0,0;1,0,0])
% 


clc;clear;
valor  = 6;
matriz = zeros(valor);

i=1:size(matriz,1);
vector = valor.^(i-1);


for i=1:(2*size(matriz,1)-1)
    if i <=valor
       vector(i) = valor^(i-1)
    else
       vector(i) = vector(i-1)/valor
    end
end

for i=1:size(matriz,1)
    matriz(i,:)=vector(i:(i+(valor-1)))
end



