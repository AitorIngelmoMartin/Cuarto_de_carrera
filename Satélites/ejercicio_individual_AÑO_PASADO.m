%%Ejercicio individual satelites
%Aparatado 1
a1 = (roots([6.7*10^-4 -9.91 -42378]));
a2 = 1.34*a1;
r1 = (2*a1)/(((2.5*10^-4)*a1)+1);
Rt = 6378;
Rgeo=36000+Rt;
hap=r1-Rt;
%Apartado 2
vi=10000;
vf=(631.6*10^3)*sqrt(1/r1);
inclinacion=0.56;
i=inclinacion*25;
Av=sqrt((vi^2)+(vf^2)-(2*vi*vf*cosd(i)));
%Apartado 3
v_geo=(631.6*10^3)*sqrt(1/Rgeo);
vf2=(631.6*10^3)*sqrt((2/(Rgeo+1))+(1/(Rgeo+r1)));
Av2=vf2-v_geo;
%Apartado 4
%Caso orbita circular baja
Tob=(9.948*10^-3)*sqrt(r1^3);
%Caso orbita de transferencia 1
Tot1=(9.948*10^-3)*sqrt(a1^3);
%Caso orbita de transferencia 2
Tot2=(9.948*10^-3)*sqrt(a2^3);
%Caso orbita geoestacionaria
Tgeo=(9.948*10^-3)*sqrt(Rgeo^3);
%Apartado 5
%Velocidades lineales
vlob=(2*pi)/Tob;
vlot1=(2*pi)/Tot1;
vlot2=(2*pi)/Tot2;
vlgeo=(2*pi)/Tgeo;
%Velocidades angulares
G=6.67*10^-11;
M=5.98*10^24;
% vaob=(631.6*10^3)*sqrt((2/r1)-(1/a1));
% vaot1=(631.6*10^3)*sqrt(1/a1);
% vaot2=(631.6*10^3)*sqrt(1/a2);
% vageo=(631.6*10^3)*sqrt((2/Rgeo)-(1/a2));
vaob=vlob*(r1*10^3);
vaot1=vlot1*(a1*10^3);
vaot2=vlot2*(a2*10^3);
vageo=vlgeo*(Rgeo*10^3);
%Apartado 6
ra=r1;
rp=2*a1-ra;
rp2=2*a2-ra;
eob=0;
eogeo=0;
eot1=(rp-r1)/(rp+r1);
eot2=(rp2-ra)/(ra+rp2);
%Apartado 7
%orbita circular baja
dminob=hap;
dmaxob=hap;
%orbita de transferencia 1
dminot1=hap;
dmaxot1=a1*(1+eot1);
%orbita de transferencia 2
dtminot2=hap;
dmaxot2=a2*(1+eot2);
%orbita geo
dmingeo=Rgeo-Rt;
dmaxgeo=dmingeo;
%Apartado 8
%Instante de inyeccion orbita baja
%10 de julio a las 19:00
%Instante de inyeccion orbita transferencia 1
T1=Tob*2;
%10 de julio a las 21:56:16
%Instante de inyeccion orbita transferencia 2
T2=Tot1*2;
%11 de julio a las 11:34:10
%Instante de inyeccion orbita geo
T3=Tot2*2.5;
%12 de julio a las 13:50:07 
%Apartado 9
%Apartado 10
Laet=-45;%norte y sur latitud, este y oeste longitud
Las=0;
Loet=28;
Los=-31;
cosgamma=cosd(Laet)*cosd(Las)*cosd(Loet-Los)+sind(Laet)*sind(Las);
gamma=acosd(cosgamma);
rs=((Tgeo/(9.948*10^-3))^2)^(1/3);
d=rs*sqrt(1+(Rt/Rgeo)^2-(2*(Rt/Rgeo)*cosd(gamma)));
cosele=(rs*sind(gamma))/d;
El=acosd(cosele);
%Calculo acimut
C=abs(Los-Loet);
tanA=(cotd(C/2)*sind(0.5*(abs(Laet)-abs(Las))))/cosd(0.5*(abs(Laet)+abs(Las)));
tanB=(cotd(C/2)*cosd(0.5*(abs(Laet)-abs(Las))))/sind(0.5*(abs(Laet)+abs(Las)));
A=atand(tanA);
B=atand(tanB);
Y=A+B;
Acimut=180+Y;
%Apartado 11
%Ya esta calculada anteriormente
%Apartado 12
%Ya esta calculado anteriormente
%Apartado 13
El2=90;
F=cosd(90);
gammat=asind(F);
H=cosd(gammat);
Laet1=acosd(1);
Loet1=acosd(1)-31;
%Tiene un azimut de 360 º
%Apartado 14
El3=14;
cosgam2=max(roots([1 -0.2833 -0.037]));
gamma2=acosd(cosgam2);
cosLaet=cosgam2/0.5150;
Laetprima=acosd(cosLaet);
%Apartado 15
Laet2=-1;
Laet3=1;
Loet2=36;
Loet3=26;
%Calculo elevacion y azimut et2
cosgamma2=cosd(Laet2)*cosd(Las)*cosd(Loet2-Los)+sind(Laet2)*sind(Las);
gammaet2=acosd(cosgamma2);
rs=((Tgeo/(9.948*10^-3))^2)^(1/3);
d2=rs*sqrt(1+(Rt/Rgeo)^2-(2*(Rt/Rgeo)*cosd(gammaet2)));
cosele2=(rs*sind(gammaet2))/d2;
Elet2=acosd(cosele2);
C2=abs(Los-Loet2);
tanA2=(cotd(C2/2)*sind(0.5*(abs(Laet2)-abs(Las))))/cosd(0.5*(abs(Laet2)+abs(Las)));
tanB2=(cotd(C2/2)*cosd(0.5*(abs(Laet2)-abs(Las))))/sind(0.5*(abs(Laet2)+abs(Las)));
A2=atand(tanA2);
B2=atand(tanB2);
Y2=A2+B2;
Acimut2=180+Y;
%Calculo elevacion y azimut et3
cosgamma3=cosd(Laet3)*cosd(Las)*cosd(Loet3-Los)+sind(Laet3)*sind(Las);
gammaet3=acosd(cosgamma3);
rs=((Tgeo/(9.948*10^-3))^2)^(1/3);
d3=rs*sqrt(1+(Rt/Rgeo)^2-(2*(Rt/Rgeo)*cosd(gammaet3)));
cosele3=(rs*sind(gammaet3))/d2;
Elet3=acosd(cosele3);
C3=abs(Los-Loet3);
tanA3=(cotd(C3/2)*sind(0.5*(Laet3-Las)))/cosd(0.5*(Laet3+Las));
tanB3=(cotd(C3/2)*cosd(0.5*(Laet3-Las)))/sind(0.5*(Laet3+Las));
A3=atand(tanA3);
B3=atand(tanB3);
Y3=A3+B3;
Acimut3=360-Y;
