function [pdf_est, ejex] = pdf_estimada(datos, muestras)
long = length(datos);
[h, ejex] = hist(datos, muestras);
ancho_barra = ejex(2)-ejex(1);
area = ancho_barra*sum(h); % area=long*ancho_barra;
pdf_est = h./area;