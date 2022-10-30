function [funcion] = representacion_funcion(a,f1,f2,b)

    t = 0:0.1:10;

    if (isscalar(f1) && isscalar(f2) && isscalar(a) && isscalar(b))
        if f1>0 && f2>0
            funcion = sin(2*pi*f1*t +a) + cos(2*pi*f2*t+b);
            figure();
            plot(t,funcion);
            title("EJERCICIO 3");xlabel("Tiempo");ylabel("Amplitud");
        else
            warning("El valor de las frecuencias debe ser escalar positivo");
        end
    else
        warning("Las frecuencias y desfases deben ser escalares");
    end
end

