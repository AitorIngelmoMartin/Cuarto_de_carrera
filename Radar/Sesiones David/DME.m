clc;clear;close all;


% Teoria DME

% Para poder conocer la posición de un avión. Empleamos 2 etapas. Una de
% pregunta y una de respuesta.

% Pregunta es de señal_tx a DME

% Respuesta es de DME a señal rx.

            % El avión pregunta, el transpondedor responde al avión y a todos los que
            % estén en su área.

% Avion pregunta, llega a transponderdor. Responde y llega a todos los que
% preguntan y están en cobertura. El problema está en cómo se que es mi
% señal.

% Para cada frecuencia del transpondedor hay una frecuencia para hacer
% frecuencias. por lo que la frecuencia SOLO SIRVE para identificar a que
% DME estás preguntando.

% Empleamos polarización vertical por como vamos a colocar la antena en el
% avión. Además, nos vamos a asegurar de que no se ...

% Se coloca en una aleta de tiburon por debajo y atrás del avión. Mides la
% distancia mas corta. La hipotenusa.

frf = 1000;
fs  = 32e6;
% t = -5:((10^6)/fs):5; %siempre trabajamos en micro
t = (-5):((10^6)/fs):(5+12);

t0 =0; %Es donde lo centramos
sigma      = 3.5/(2*sqrt(2*log(2)));
envolvente = exp(-(t-t0).^2/(2*sigma^2));

pulso1 = envolvente.*cos(2*pi*frf*t);

% Generación segundo pulso
t0 = 12; %Es donde lo centramos
envolvente = exp(-(t-t0).^2/(2*sigma^2));

pulso2 = envolvente.*cos(2*pi*frf*t);



figure()
plot(t,(pulso1+pulso2))

% la separación nos indica qué tipo de pregunta uso. Ya que existen
% militares y civiles, por lo que la separación entte pulsos marca si es
% militar o no. En este caso es militar, es X.

% Si la separació es 36 es civil.

% La idea de mandar un par de pulsos nos sirve para identificar la pregunta
% que estoy haciendo.
% 
% La cosa es que no vamos a mandar 1 pregunta, sino un tren de ellas. La
% idea es que la separación entre preguntas sea aleatoria. Esta secuencia
% aleatoria SOLO LA CONOCE el avión. De hecho esta es la forma que tiene el
% avión para saber que es para él.
% 
% Estos espacios entre pulsos X1-X2 tienen un margen. Si es de 120-150 es
% modo búsqueda. Ya que nos interesa saber donde está. No es un valor fijo,
% alterna entre este valor.
% 
% El siguiente paso es seguimiento, hacemos [24-30] preguntas por segundo.


%% TREN DE PREGUNTAS

t = -5:((10^6)/fs):4120;

t0         = [0, 1500, 2900, 4100]
t0_segundo = t0 +12;
senal =0;
figure()
hold on
for i=1:size(t0,2)    
    envolvente = exp(-(t-t0(i)).^2/(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-t0_segundo(i)).^2/(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    senal  = senal+ pulso1 + pulso2;
end
plot(t,senal)

%% RETARDO TOTAL CAMINO IDA

% DME = 95MS + 5MB = 95*30+5*150-3600 -->0.277ms


Retardo_total = (2*110000*1E6/3E8)+50;

% Por cada prgunta espero 50us sin hacer nada. Ya que no podemos esperar
% una respuesta antes al retrasar el DME 50us.
% Esto se llama espacio vacío.

% --50us--|--4x20us--|
% Debo ir moviendo esta ventana para ir viendo las respuestas. Pero el
% ridmo de la ventana es 18Km/seg.

% Da tiempo a  ver el mísmo huevo diversas veces. Esto se hace para poder
% encontrar mi patrón. Es decir, deben haber unos en cada ventanaa. Sino no
% se adapta a mi anchura.

% Distancia = (retardo*C)/2; El 2 es porque es ida y vuelta.
Distancia = (20e-6*3e8)/2

distancia_que_ver = [Distancia, 2*Distancia, 3*Distancia, 4*Distancia]
% Esta 1/6;

% preguntas recibidas en caso maximo 3600.*[500e-6, 100e-6]
% Recibimos menos de todas, porque de forma aleatoria sólo 1.8/0.36 son
% mías. Ya que contesta al tren de preguntas, formada por 4.

% Solo habrá casi tantas respuestas como preguntas cuando la posición sea a
% la que está el radiofaro. La ventana la mueve donde esperas que esté el
% radiofaro.

% En caso modo búsqueda, como mucho vas a recibir 2 respuestas. La cosa es
% buscar una posición de la ventana en la cual tengamos muchas respuestas.


% 18km/s *tiempo_parada = Distancia


% Para poder detectar con precisión en DME, genero un pulso con una
% pendiente muy grande a la subida y muy relajada a la bajada. De forma que
% compensamos el ancho de banda. Nos interesa la zona de pendiente lineal.

%%

% Preguntas hechas
% 
% recibidas transpondedor
% 50u6
% generadas por él
% 
% recibidas por avión.


% Al tren de preguntas hay que añadir el viaje de ida, el retardo
% transpondedor, y el viaje vuelta.

% DME a 110 Km

%% TREN DE PREGUNTAS

frf = 1000;
fs  = 32e6;
sigma      = 3.5/(2*sqrt(2*log(2)));


% Añado el tiempo total que necesito para considerar los retardos
Distancia_avion_transpondedor = 110; % Km
Retardo_avion_transpondedor   = (Distancia_avion_transpondedor*1E9/3E8);

tiempo_silencio  = 50;
Tiempo_adicional = 2*Retardo_avion_transpondedor + tiempo_silencio;


t = -5:((10^6)/fs):(4120+Tiempo_adicional);

t0         = [0, 1500, 2900, 4100]
t0_segundo = t0 +12;
tren_preguntas =0;

figure()
hold on

for i=1:size(t0,2)    
    envolvente = exp(-(t-t0(i)).^2/(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-t0_segundo(i)).^2/(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas  = tren_preguntas+ pulso1 + pulso2;
end

plot(t,tren_preguntas)

%% TREN DE PREGUNTAS EN TRANSPONDEDOR

tren_preguntas_retardoTx1 = 0;
for i=1:size(t0,2)    
    envolvente = exp(-(t-(t0(i)+Retardo_avion_transpondedor)).^2/(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-(t0_segundo(i)+Retardo_avion_transpondedor)).^2/(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas_retardoTx1  = tren_preguntas_retardoTx1+ pulso1 + pulso2;
end



plot(t,tren_preguntas_retardoTx1)

%% TREN DE PREGUNTAS TRAS LOS 50US DE SILENCIO

tren_preguntas_tras_silencio = 0;
for i=1:size(t0,2)    
    envolvente = exp(-(t-(t0(i)+Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-(t0_segundo(i)+Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas_tras_silencio  = tren_preguntas_tras_silencio+ pulso1 + pulso2;
end


plot(t,tren_preguntas_tras_silencio)

%% TREN DE PREGUNTAS TRAS TX2

tren_preguntas_retardoTx2 = 0;
for i=1:size(t0,2)    
    envolvente = exp(-(t-(t0(i)+2*Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));
    
    pulso1     = envolvente.*cos(2*pi*frf*t);      
    
    envolvente = exp(-(t-(t0_segundo(i)+2*Retardo_avion_transpondedor + tiempo_silencio)).^2 ...
        /(2*sigma^2));

    pulso2 = envolvente.*cos(2*pi*frf*t);
    tren_preguntas_retardoTx2  = tren_preguntas_retardoTx2+ pulso1 + pulso2;
end


plot(t,tren_preguntas_retardoTx2)
legend("Tren preguntas original","Tras retardo de Tx1","Tras tiempo de silencio","Tras retardo de Tx2");
title("Tren de preguntas en un caso real");