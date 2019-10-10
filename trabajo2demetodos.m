clear all
clc

%Primero debo ingresar los datos que necesito
%
%
%--------------Parte Hibrida------------------------------------------------------------------
%Tenemos dos ecuaciones de distancia suponiendo que la red o las anclas son de tipo hibrido
%es decir, tendremos 2 RSS y 2 TOA
%---------------------------------------------------------------------------------------------
%Supongamos un ecenario de LxL en metros, de 4 antenas o anclas y en forma cuadrada como para
%ubicarse mejor, de forma mas sencilla y utilizamos 4 para que la aproximacion sea la minima 
%posible
% 
%   ANTENA RSS (0,L) ------------------- ANTENA RSS (L,L)
%          -                                 -
%          -                                 -     
%          -                 AGENTE          -     
%          -                                 -
%   ANTENA TOA (0,0) ------------------- ANTENA TOA (L,0)
%APARTADO GRAFICO - O VISUAL PARA ENTENDER LO QUE CALCULAMOS
imagen = imshow('grafico.bmp');
clc
%
% El valor de L propuesto por el paper es de 10 metros
    
L=10;

% Aclara que el agente se puede cambiar la ubicacion cada 2 metros
% por lo tanto el cuadrado formado por las antenas sera de dividido en 5x5 cudriculas que seran
% las posibles ubicaciones
% 
% ---------------------------------------------------------------------------------------------- 
% Ecuacion principal con la que vamos a trabajar: (una por cada antena que coloquemos generara
% un radio, que cuya intersepcion sera nuestro objetivo)
%
% di = p - pi = ( ( x - xi )^2 + ( y - yi )^2 )^1/2
%
% Esta ecuacion no es lineal, por ende utilizaremos diferentes tecnicas de minimo cuadrado
% para linealizar esta ecuacion y luego llegar a un valor aproximado
% 
% xi y yi seran el centro de la circunferencia, es decir donde esta ubicada cada antena

%!!!!!!!!!!!!!!!!ACA EMPIEZA EL PROGRAMA EN SI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% --------------------------------------------------------------------------------------------
% Calculo de distancia por cada antena:
% -------------------TOA1---------------------------------------------------------------------
Trtt1 =  4*10^(-8);          %Tiempo de ida y vuelta en la medicion de distancia
Ttat =  7.14*10^(-9) ;         %Tiempo de respuesta del agente 

d(1) = 3*10^8 * ( Trtt1 - Ttat )/2;

%----Hay que agregar un error aca que tiene el calculo de toa por interrupcion de ruido blanco

%---------------------TOA2--------------------------------------------------------------------
Trtt2 =  4*10^(-8);         %Tiempo de ida y vuelta en la medicion de distancia
Ttat =  7.14*10^(-9) ;        %Tiempo de respuesta del agente 

d(2) = 3*10^8 * ( Trtt2 - Ttat )/2;
%----Hay que agregar un error aca que tiene el calculo de toa por interrupcion de ruido blanco

%-----------------------Rss1-------------------------------------------------------------------
%
% Aca le voy a poner por el momento lo que dice el paper que mas o menos da un resultado de 10m
%pero habria que calcular un di por medio de la potencia
d(3)=sqrt(50);


%-----------------------Rss2------------------------------------------------------------------
% Aca le voy a poner por el momento lo que dice el paper que mas o menos da un resultado de 10m
%pero habria que calcular un di por medio de la potencia
d(4)=sqrt(50);

%---------------------------------------------------------------------------------------------


%LUEGO TENGO QUE ARMAR LA MATRIZ Y APLICAR LOS METODOS

x = [ 0 L 0 L ];
y = [ 0 0 L L ];

% Primer metodo ---> Imponemos una variable ficticia "R" que remplazara a x^2+y^2
% 
% y ademas nos queda que F = [ x y R ]'
%
% Entonces quedara la matriz Ai * F = bi

    for i = 1:4
        A(i,1) = [ -2 * x(i) ];
        A(i,2) = [ -2 * y(i) ];
        A(i,3) = 1;
        b(i,1) = d(i)^2 - x(i)^2 - y(i)^2;
    end 

disp('------------------Red Hibrida LLS1----------------------------------')

%Paso la matriz a sparce para ahorro de almasenamiento

    sparse(A);
    sparse(b);

%Calculo directamente los minimos cuadrados a partir de la variable ficticia
%Siendo F lo que nos linealiza el sistema para que podamos resolver, es
%entonces nuestra variable a encontrar:
%F tendra 3 componentes, 2 son las cordenadas, las primeras dos

    Fsol = inv((A'*A))*A'*b; 
    plls1 = [Fsol(1), Fsol(2)];

disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
%Luego tomo la distancia como:
dis = sqrt(plls1(1)^2+plls1(2)^2)
dcord = [Fsol(1), Fsol(2)]
disp('Angulo en grados')
angle = atan(plls1(2)/plls1(1))*360/(2*pi)


%Repetire el proceso para  ahora tener en cuenta 4 toa entonces remplazare las 2 que eran
%rss por toa

    Trtt3 =  4*10^(-8); 
    d(3) = 3*10^8 * ( Trtt3 - Ttat )/2;

    Trtt4 =  4*10^(-8); 
    d(4) = 3*10^8 * ( Trtt4 - Ttat )/2;


    for i = 1:4
        A(i,1) = [ -2 * x(i) ];
        A(i,2) = [ -2 * y(i) ];
        A(i,3) = 1;
        b(i,1) = d(i)^2 - x(i)^2 - y(i)^2;
    end 

sparse(A);
sparse(b);

%Realizo un calculo propuesto por el paper para encontrar el valor de la
%variable, que es despejar la variable

Fsol = inv((A'*A))*A'*b; 

%La primer componente de Fsol es la x y la segunda es ls Y
%por lo tanto:

plls1 = [Fsol(1), Fsol(2)]; %p de posicion

%--------------------------------------------------------------------------------------------
%Luego tomo la distancia como:
%
disp('---------------------Red no hibrida LLS1---------------------------------')
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt(plls1(1)^2+plls1(2)^2)
dcord = [Fsol(1), Fsol(2)]
disp('Angulo en grados')
angle = atan(plls1(2)/plls1(1))*360/(2*pi)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------------Segundo metodo LLS2------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Para el segundo metodo nececitamos fijar alguna antena como referencia
%EL paper nos propone 4 formas, para probar el metodo utilizo tomar una antena aleatoreamente
%supongamos que esa va a ser la ubicada en (0,0)
%
    xr = 0; yr= 0;
    kr = [ xr^2 + yr^2 ];
    for i = 1:4
        A2(i,1) = [ 2 * ( x(i) - xr ) ];
        A2(i,2) = [ 2 * ( y(i) - yr )];
        k(i,1) = [ x(i)^2 + y(i)^2 ];
        b2(i,1) = d(1)^2 - d(i)^2 - kr - k(i,1);
    end 

%Ahora deberia hacer Aii * p = bii donde p tiene dos componentes, x e y
%que seran las cordenadas

Fsol = inv((A2'*A2))*A2'*b2; 
plls1 = [Fsol(1), Fsol(2)]; %p de posicion


disp('---------------------Red no hibrida LLS2---------------------------------')
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt(plls1(1)^2+plls1(2)^2)
dcord = [Fsol(1), Fsol(2)]
disp('Angulo en grados')
angle = atan(plls1(2)/plls1(1))*360/(2*pi)

%Datos de antenas RSS
d(4)=sqrt(50);d(3)=sqrt(50);

%repito proceso
xr = 0; yr= 0;
kr = [ xr^2 + yr^2 ];
for i = 1:4
    A2(i,1) = [ 2 * ( x(i) - xr ) ];
    A2(i,2) = [ 2 * ( y(i) - yr )];
    k(i,1) = [ x(i)^2 + y(i)^2 ];
    b2(i,1) = d(1)^2 - d(i)^2 - kr - k(i,1);
end 

%Ahora deberia hacer Aii * p = bii donde p tiene dos componentes, x e y
%que seran las cordenadas

Fsol = inv((A2'*A2))*A2'*b2; 
plls1 = [Fsol(1), Fsol(2)]; %p de posicion


disp('---------------------Red hibrida LLS2---------------------------------')
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt(plls1(1)^2+plls1(2)^2)
dcord = [Fsol(1), Fsol(2)]
disp('Angulo en grados')
angle = atan(plls1(2)/plls1(1))*360/(2*pi)