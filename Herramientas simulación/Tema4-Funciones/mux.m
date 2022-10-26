clc;clear;

% Escriba una función que tenga como entrada dos valores y devuelva 
% una matriz cuadrada. El primer argumento de entrada indicará el tamaño 
% de la matriz. El segundo argumento x, servirá para calcular los elementos
% de la matriz tal que: 

orden = 5;
x = 9
matriz = zeros(orden);

i=1:size(matriz,1);
vector(i) = x.^(i-1);
for i=1:size(matriz,1)
    matriz(i,:)=vector
end


