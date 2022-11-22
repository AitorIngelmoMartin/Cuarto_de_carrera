function [pdf_est, ejex] = pdf_estimada(datos, muestras)
long = length(datos);
[h, ejex] = hist(datos, muestras);
ancho_barra = ejex(2)-ejex(1); %ancho de la barra como la diferencia entre dos  valores CONSECUTIVOS del ejeX
area = ancho_barra*sum(h); % area=long*ancho_barra; Calculamos el área
pdf_est = h./area;