clc;clear;close all;

% Antena de cuedro

adfantena = design(loopRectangular,355e3);
show(adfantena)
adfantena.Tilt = 90;
adfantena.TiltAxis = [0 0 1];

figure()

pattern(adfantena,335e3,"Type","power")

% Diagrama de dispersión ombinireccional SOLO en azimut. Lo demas tiene
% menos ganancia.


% Como asumo campo lejano, llegan rectas paralelas. Nuestro cuadro tiene un
% máximo en 0 y 180, por lo que la vamos a ir rotando para ver por donde
% llega la señal. 
% De forma que encontremos el máximo por el cual llega el radiofaro.

% Como tienes 2 mñaximos, usamos otra antena llamada "de sentido", que es
% exactamente igual que la del radio faro.


% Antena de direccion

senseantena = design(dipole, 355e3);
show(senseantena)
figure()
pattern(senseantena,355e3, "Type","power")

% Debemos hacer un corte en azimut.

Theta = -180:180
ad = cosd(Theta);
as = ones(1, length(Theta)); %Antena de direccion

combinacion_sentido = as-ad;

% Vamos a pintar la combinación de estos angulos en radianes y del radio

polarplot(deg2rad(Theta),abs(combinacion_sentido))


% hold on
% 
% polarplot(deg2rad(Theta),abs(ad))
% polarplot(deg2rad(Theta),abs(as))
% polarplot(deg2rad(Theta),abs(combinacion_sentido))
% 
% hold off

% Dibujo de vuelta

Tiempo = 0:1/5000:10/30;
Omega  = 30 %revoluciones por minuto
Angulo_radiofaro = 42;


for i =1:length(Tiempo)

    angulo(i) = Tiempo(i)*Omega*360;
    ad = cosd(Theta-angulo(i));
    as = ones(1, length(Theta-angulo(i))); %Antena de direccion

    combinacion_sentido = as-ad;
    
    polarplot(deg2rad(Theta),abs(combinacion_sentido))

    hold on

    ndb(i) = abs(combinacion_sentido(181+Angulo_radiofaro));
    
end
hold off

figure()
plot(angulo,ndb)

angulo = wrapTo360(deg2rad(angulo))

figure()
plot(angulo,ndb)

figure()
polarplot(angulo,ndb)

% Este coseno tiene información de llegada, ya que en función del angulo de
% llgada, el coseno empieza antes o despues. Es decir, la fase informa de
% por donde llega.
