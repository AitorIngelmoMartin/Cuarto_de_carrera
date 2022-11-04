function [matriz_cuadrada_resultante] = matriz_cuadrada(tamano,argumento_x)
    try

        if tamano<0
            tamano=tamano*-1;
            warning("El tamaño es negativo, se ha pasdo a positivo");
        end
        matriz = zeros(tamano);
        vector = zeros(1,argumento_x);
        for i=1:(2*size(matriz,1)-1)
            if i <=tamano
                vector(i) = argumento_x^(i-1);
            else
                vector(i) = vector(i-1)/argumento_x;
            end
        end

        for i=1:size(matriz,1)
            matriz(i,:)=vector(i:(i+(tamano-1)));
        end
        matriz_cuadrada_resultante = matriz;
    catch
        warning("El tamaño de la función y el argumento deben ser escalares positivos");
        matriz_cuadrada_resultante = "No es posible calcularlo";
    end
end

