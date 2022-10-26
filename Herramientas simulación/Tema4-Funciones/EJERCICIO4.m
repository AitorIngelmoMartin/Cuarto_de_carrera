clc;clear;

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