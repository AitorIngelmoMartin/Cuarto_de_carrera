clc;clear;
t = 0:0.1:10;
a = 4 + 5*i;
f1 = 25;f2 = 51;
b = 14;

if (isscalar(f1) && isscalar(f2) && isscalar(a) && isscalar(b))
    if f1>0 && f2>0
    y = sin(2*pi*f1*t +a) + cos(2*pi*f2*t+b);
    figure()
    plot(t,y)
    title("EJERCICIO 3");xlabel("Tiempo");ylabel("Amplitud");
    else
        warning("El valor de las frecuencias debe ser escalar positivo");
    end
else
    warning("Las frecuencias y desfases deben ser escalares");
end


 