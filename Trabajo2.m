clear all
clc

warning ( 'off' )


% --------------------------------------------------------------------------------------------
% Calculo de distancia por cada antena:
% -------------------TOA1---------------------------------------------------------------------

Trtt1 =  5e+08 ;          
%Tiempo de ida y vuelta en la medicion de distancia

Ttat =   2.85e+07 ;         
%Tiempo de respuesta del agente 

d(1) = (3*10^8 / 1.0e+16 ) * ( Trtt1 - Ttat )/2;


%---------------------TOA2--------------------------------------------------------------------

Trtt2 =  5e+08 ;         
%Tiempo de ida y vuelta en la medicion de distancia

Ttat =  2.8595e+07 ;       
%Tiempo de respuesta del agente 

d(2) = (3*10^8 / 1.0e+16 ) * ( Trtt2 - Ttat )/2;


%-----------------------Rss1-------------------------------------------------------------------
%
% Ac� le voy a poner por el momento lo que dice el paper que m�s o menos da un resultado de 10m
%pero habria que calcular un di por medio de la potencia
do = 7.01;
gama = 4.58;
p0 = 10;
pr = 9.81;
d (3) = 10 ^ (( p0 - pr )/ ( 10 * gama )) * do;



%-----------------------Rss2------------------------------------------------------------------
% Ac� le voy a poner por el momento lo que dice el paper que m�s o menos da un resultado de 10m
%pero habr�a que calcular un di por medio de la potencia

do = 7.01;
gama = 4.58;
p0 = 10;
pr = 9.81;
d (4) = 10 ^ (( p0 - pr )/ ( 10 * gama )) * do;

%---------------------------------------------------------------------------------------------
    
        

% MATRIZ DE POSICION DE CADA ANTENA

L=10;

x = [ 0 L 0 L ];
y = [ 0 0 L L ];

% ANTENA DE REFERENCIA PARA LLS2 Y WLLS2

xr = 0; yr= 0;

% VARIANZA AL TOMAR MEDICIONES CON LAS ANTENAS
eta = 2;
SNR0 = 25;
d0 = 1;

for i = 1:4
    vartoa(i) = ( 1 / SNR0 ) * ( d(i) / d0 );
    varrss(i) = eta^2 * vartoa(i);
end

var = [ vartoa(1) vartoa(2) varrss(3) varrss(4) ];



%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

%   Calulos para una red 'HIBRIDA'

disp('------------------Red Hibrida LLS1----------------------------------')
[ dis, dcord, ang ] = LLS1(x,y,d); 

    
    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)

xr = 0; yr= 0;

disp('------------------Red Hibrida LLS2----------------------------------')

[ dis, dcord, ang ] = LLS2(x,y,d,xr,yr);
    
    disp('Distancia en metros desde antena de referencia ubicada en (0,0):')
    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)

    
disp('------------------Red Hibrida WLLS1----------------------------------')

[dis,dcord,ang]=WLLS1(var,x,y,d);    
          
    
    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)


disp('------------------Red Hibrida WLLS2----------------------------------')

[ dis , dcord , ang ] = WLLS2 ( x , y , d , var );
    
    disp('Distancia en metros desde antena de referencia ubicada en (0,0):')
    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)

disp('----------------------------------------------------------------------')

%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

%   Calulos para una red ' NO HIBRIDA'

% Repetir el proceso para  ahora tener en cuenta 4 toa entonces remplazar las 2 que eran
% rss por toa

Trtt3 = 5.01e+08 ;; 
d(3) = (3*10^8 / 1.0e+16 ) * ( Trtt3 - Ttat ) / 2;

Trtt4 =  5e+08 ;; 
d(4) = (3*10^8 / 1.0e+16 ) * ( Trtt4 - Ttat ) / 2;


disp('------------------Red no Hibrida LLS1----------------------------------')
[ dis, dcord, ang ] = LLS1 ( x , y , d ); 

    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)

xr = 0; yr= 0;

disp('------------------Red no Hibrida LLS2----------------------------------')

[ dis, dcord, ang ] = LLS2( x , y , d , xr , yr );

    
    disp('Distancia en metros desde antena de referencia ubicada en (0,0):')
    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)

    
disp('------------------Red no Hibrida WLLS1----------------------------------')

[ dis , dcord , ang ] = WLLS1( vartoa , x ,y ,d );    
          

    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)


disp('------------------Red no Hibrida WLLS2----------------------------------')

[ dis , dcord , ang ] = WLLS2 ( x , y , d , vartoa );

    disp('Distancia en metros desde antena de referencia ubicada en (0,0):')
    disp('Distancia:'); disp (dis)
    disp('Coordenadas:'); disp (dcord)
    disp('Angulo expresado en grados'); disp (ang)

disp('----------------------------------------------------------------------')

warning ( 'on' )


       