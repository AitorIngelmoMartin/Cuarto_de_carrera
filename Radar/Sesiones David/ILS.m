clc;clear;close all;

% Trabajamos a menos de 6Ghz para evitar los efectos pernicioses de la
% niebla o la lluvia. Ya que este servicio debe ser muy robusto al ser de
% vital importancia para poder aterrizar el avión.

% Necesitamos tener información relativa al azimut, la elevación y la
% distancia del avión.

% Para la posición horizontal se usa de 108 a 110 Mhz. Lo que da 40
% canales de 50Khz. Usamos un array de 8 a 14 antenas omnidireccionales con
% polarización horizontal situado a 300 metros más haya de la pista.

% El localizador funciona de forma sencilla. Recibimos dos tonos de 150 y 90.
% Uno por la izquierda y otro por la derecha. 
% Si estamos mas a la izquierda, se desbalancea, y vemos más el
% tono de 150 que el de 90. Por lo que estoy más hacia la derecha o la
% izquierda.
% Por lo que a partir de estos dos tonos podemos corregir poco a poco la
% posición hasta que alineamos perfectamente el avión con la pista.

% La expresión usada está en la diapositivas 32. De forma que la ecuación
% toma un menos en I.

% Si asumimos que el frente de onda es plano, llegan ondas paralelas entre
% sí. Lo que implica que el camino es distinto para onda. Ese incremento,
% está relacionado con la hipotenusa formada por la separación entre
% antenas.

% Incremento_L = (Separacion/antena)*sin(angulo)

% Todas las demás no llegan al tiempo, sino al tiempo desplazado 
%     t-t0 = (t-incremento_L/l).
% Es decir, nos va a llegar señales antes o después en función de donde
% esté colocada la antena.


%% Representación de las antenas

frf = 1e3;
fs  = 4*frf;
t   = 0:1/fs:50;



I0 = 1;
K  = 1;
m  = 1;

senal_rx_ref = 2*I0*(1+m*sin(2*pi*150*t)+m*sin(2*pi*90*t)).*cos(2*pi*frf*t);

figure();
plot(-fs/2:fs/1024:(fs/2) - (fs/1024),fftshift(abs(fft(senal_rx_ref,1024)).^2),"r")


% Debemos agregar la señal que recibe el avión. Que es multiplciar por dos
% la que hemos hecho.

% ademas hay que agregar la negativa. Teniendo que entregar el
% incrementoL/L. Interesa sobretodo ver que llega retrasado respecto el
% otro tono.

% sI ES k POSITIVO ES t+incrementol/L.

Separacion_entre_antenas   = 20000;

Theta =  34*pi/180;

Incremento_L = (Separacion_entre_antenas)*sin(Theta);

c = 3e8;

t0 = Incremento_L/c;
I_menosK = -K*I0*(sin(2*pi*150*t) - sin(2*pi*90*t)).*sin(2*pi*frf*(t+t0));

I_masK = K*I0*(sin(2*pi*150*t) - sin(2*pi*90*t)).*sin(2*pi*frf*(t-t0));

senal_rx = I_menosK +  I_masK +senal_rx_ref;

figure();
plot(-fs/2:fs/1024:(fs/2) - (fs/1024),fftshift(abs(fft(senal_rx,1024)).^2),"r")

numero_antenas = 4;

% separaciones = 20000:20000:80000;
for i =1:numero_antenas
    
    separaciones = 20000*i;
    
    Incremento_L = (separaciones)*sin(Theta);
    t0 = Incremento_L/c;
    %   La derecha
    I_menosK = -K*I0*(sin(2*pi*150*t) - sin(2*pi*90*t)).*sin(2*pi*frf*(t+t0));

    %   La izquierda
    I_masK = K*I0*(sin(2*pi*150*t) - sin(2*pi*90*t)).*sin(2*pi*frf*(t-t0));
    
    senal_rx = senal_rx + I_menosK + I_masK;
end

figure();
plot(-fs/2:fs/1024:(fs/2) - (fs/1024),fftshift(abs(fft(senal_rx,1024)).^2),"r")


% La información está en los tonos de +-90 y +-150.La cosa está en hacer
% filtros selectivos en 150/90 y comparar valores. Si sale positivo estoy a
% la izquierda y ne negativo a la derecha.

%% filtros
comparador = [];

for Theta=-90:90
    
senal_rx_ref = 2*I0*(1+m*sin(2*pi*150*t)+m*sin(2*pi*90*t)).*cos(2*pi*frf*t);


Theta = Theta*pi/180;
Incremento_L = (Separacion_entre_antenas)*sin(Theta);

t0 = Incremento_L/c;
I_menosK = -K*I0*(sin(2*pi*150*t) - sin(2*pi*90*t)).*sin(2*pi*frf*(t+t0));

I_masK = K*I0*(sin(2*pi*150*t) - sin(2*pi*90*t)).*sin(2*pi*frf*(t-t0));

senal_rx = I_menosK +  I_masK +senal_rx_ref;     

[num150,den150] = butter(5,300*2/fs);
senal_bb=amdemod(senal_rx,frf,fs,0,0,num150,den150);

[num50,den50] = butter(5,50*2/fs);
senal_150=amdemod(senal_bb,150,fs,-pi/2,0,num50,den50);

[num50,den50] = butter(5,50*2/fs);
senal_90=amdemod(senal_bb,90,fs,-pi/2,0,num50,den50);

comparador=[comparador,mean(senal_150)-mean(senal_90)];

end
Theta_posible = -90:90;
figure()
polarplot(deg2rad(Theta_posible(comparador>=0)),abs(comparador(comparador>=0)))
hold on
polarplot(deg2rad(Theta_posible(comparador<0)),abs(comparador(comparador<0)))
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaLim = [-90 90];

% Si estamos por encima de la pendiente perfectas. Estamos cayendo en
% picado. Lo ideal es ir por debajo o ligeramente por encima. Muy elevado
% supone que tienes mucha pendiente y revotas al aterrizar.

%% MLS

% La idea es intentar mejorar el ILS. Como por ejemplo, el hecho de sólo
% poder hacer 40 maniobras simultaneas. MLS pasa a 200.

% Necesitamos antenas muy grandes porque la frecuencia es muy pequeña. Por
% lo que debemos subir en frecuencia y asñi tener más directividad. Debemos
% conocer con miuchas mas precisión donde me encuentro. De esta forma evito
% el denominado guiado en cruz. Que e sque solo podemos saber si estamos
% arriba,abajo derecha o izquierda. Ahora podemos hacer cualquier
% movimiento sin que sea rectilineo gracias a las antenas de barrido.

% Es decir, un radar. Haciendo un barrido en azimut y otro en elevación.
% Haciendo 5 barridos. Dos en azimut, dos en elevación y otro por si acaso.
% Pese a esto, seguimos estando al límite para que no nos afecte la lluvia.
% La forma de detectar donde nos encontramos, se hace hayando el tiempo que
% ha pasado entre barridos.


% Al final vamos a colocar varios instrumentos. La idea es además usar
% TDMA, es decir, cada vez radia un solo sensor. El orden lo marca el
% master commander de cada una de las pistas.
