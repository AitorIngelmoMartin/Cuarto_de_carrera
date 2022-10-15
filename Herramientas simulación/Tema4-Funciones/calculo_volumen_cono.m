function [volumen_cono] = calculo_volumen_cono(r,h)

    try
        if  isnumeric(r) ~  0 
            
        end
    catch
       display("El valor ""r"" NO es escalar ");    
    end
        volumen_cono = (1/3)*pi*r*r*h;
end

