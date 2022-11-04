function [vector_ordenado] = myorder(vector,tipo)
    if size(vector,1)==1
        warning("El vector introducido solo tiene un valor");
        vector_ordenado = vector;
    else
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
end