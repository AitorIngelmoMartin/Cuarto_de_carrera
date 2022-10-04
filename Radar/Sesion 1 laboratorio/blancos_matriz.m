function[matriz_con_blancos]=blancos_matriz(Er,theta_R,vr,fila,columna,n_pulsos, matriz_inicial, frecuencia, PRF)

lambda=3e8/frecuencia;

for target=1:length(Er)

    matriz_con_blancos=matriz_inicial;

    if vr(target)==0
        vector_blanco=sqrt(2*Er)*exp(1i*theta_R)*ones(n_pulsos,1);
    else
        omega_Doppler=4*vr(target)*1000/3600*pi/lambda;
        vector_blanco=sqrt(2*Er(target))*exp(1i*pi/5)*exp(-1i*omega_Doppler/PRF*(0:(n_pulsos-1))).';
    end

    if rem(n_pulsos,2)==0
        matriz_con_blancos((fila(target)-(n_pulsos/2)):(fila(target)+(n_pulsos/2)-1),columna(target))= matriz_con_blancos((fila(target)-(n_pulsos/2)):(fila(target)+(n_pulsos/2)-1),columna(target))+vector_blanco;
    else
        matriz_con_blancos((fila(target)-fix(n_pulsos/2)):(fila(target)+fix(n_pulsos/2)),columna(target))=matriz_con_blancos((fila(target)-fix(n_pulsos/2)):(fila(target)+fix(n_pulsos/2)),columna(target))+vector_blanco;
    end
end

end

