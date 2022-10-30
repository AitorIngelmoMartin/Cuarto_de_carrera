function [volumen_cono] = calculo_volumen_cono(r,h)

    if (isscalar(r) && isscalar(h)) && (r>0 && h>0)
        try
           %Como hacer para que sean positivos 
           volumen_cono = (1/3)*pi*r*r*h;
        catch 
           warning("El valor ""r"" o ""h"" NO es escalar ");
           volumen_cono = "No es posible calcularlo";
        end
    else
        warning("El valor del radio y la altura deben ser escalares positivo");
    end
end

