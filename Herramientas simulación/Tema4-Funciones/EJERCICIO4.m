clc;clear;

% Escriba una función myorder que ordene un vector de escalares. 
% Esta función tendrá como mínimo un parámetro  de entrada que será el vector. 
% 
% Si se llama a la función con un único parámetro de entrada la función recorrerá
% el vector y ordenará sus elementos de mayor a menor. Si se llama a la función con 
% dos parámetros de entrada el segundo argumento aceptará una cadena de caracteres 
% cuyo valor puede ser 'ascendente' o 'descendente',
% y en función de este valor ordenará el vector de menor a mayor o de mayor a menor, 
% respectivamente. En ambos casos la función debe devolver un vector ordenado. 
% 
% Use la función sort dentro de su función.

tipo = "ascendente";
vector = [-9,57,50-7,0,6,14,3];

salida = myorder(vector)

salida =  myorder(vector,tipo)

tipo = "descendente";
salida =  myorder(vector,tipo)
function [vector_ordenado] = myorder(vector,tipo)

    if  nargin == 2
        if tipo == "ascendente"
              vector_ordenado = sort(vector);
        
        elseif tipo == "descendente"
               vector_ordenado = fliplr(sort(vector));   
        end        
    else
            vector_ordenado = sort(vector);  
    end
  
end