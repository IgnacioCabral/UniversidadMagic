clear all
clc

warning ( 'off' )

%Primero debo ingresar los datos que necesito
%
%--------------Parte Hibrida------------------------------------------------------------------
%Tenemos dos ecuaciones de distancia suponiendo que la red o las anclas son de tipo hibrido
%ya que tendremos 2 RSS y 2 TOA
%---------------------------------------------------------------------------------------------
%Supongamos un ecenario de LxL en metros, de 4 antenas o anclas y en forma cuadrada
%y utilizamos 4 para que la aproximacion sea la minima posible
% 
%   _ _                                                  _ _
%  | ANTENA RSS (0,L) ------------------- ANTENA RSS (L,L)  |
%  |        -                                 -             |      
%  |        -                                 -             |
%  |        -                 AGENTE          -             |
%  |        -                                 -             |
%  |        -                                 -             |
%  | ANTENA TOA (0,0) ------------------- ANTENA TOA (L,0)  |
%   - -                                                  - -

%APARTADO GRAFICO / VISUAL PARA ENTENDER LO QUE CALCULAMOS
imagen = imshow('grafico.bmp');
clc

% El valor de L propuesto por el paper es de 10 metros
L=10;

% Aclara que el agente se puede cambiar la ubicación cada 2 metros
% por lo tanto el cuadrado formado por las antenas será de dividido en 5x5 cudrículas que serán
% las posibles ubicaciones
% 
% ---------------------------------------------------------------------------------------------- 
% Ecuacion principal con la que vamos a trabajar: (una por cada antena que coloquemos generara
% un radio, que cuya intersección será nuestro objetivo)
%
% di = p - pi = ( ( x - xi )^2 + ( y - yi )^2 )^1/2
%
% Esta ecuación no es lineal, por ende utilizaremos diferentes técnicas de mínimo cuadrado
% para linealizar esta ecuación y luego llegar a un valor aproximado
% 
% xi y yi ser+an el centro de la circunferencia, es decir donde está ubicada cada antena

%!!!!!!!!!!!!!!!!ACA EMPIEZA EL PROGRAMA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


% --------------------------------------------------------------------------------------------
% Calculo de distancia por cada antena:
% -------------------TOA1---------------------------------------------------------------------

Trtt1 =  4*10^(-8);         
%Tiempo de ida y vuelta en la medicion de distancia

Ttat =  7.14*10^(-9) ;         
%Tiempo de respuesta del agente 

d(1) = 3*10^8 * ( Trtt1 - Ttat )/2;


%---------------------TOA2--------------------------------------------------------------------

Trtt2 =  4*10^(-8);         
%Tiempo de ida y vuelta en la medicion de distancia

Ttat =  7.14*10^(-9) ;       
%Tiempo de respuesta del agente 

d(2) = 3*10^8 * ( Trtt2 - Ttat )/2;


%-----------------------Rss1-------------------------------------------------------------------
%
% Acá le voy a poner por el momento lo que dice el paper que más o menos da un resultado de 10m
%pero habria que calcular un di por medio de la potencia

d(3)=sqrt(50);


%-----------------------Rss2------------------------------------------------------------------
% Acá le voy a poner por el momento lo que dice el paper que más o menos da un resultado de 10m
%pero habría que calcular un di por medio de la potencia

d(4)=sqrt(50);

%---------------------------------------------------------------------------------------------
    
        

%LUEGO TENGO QUE ARMAR LA MATRIZ Y APLICAR LOS MÉTODOS

x = [ 0 L 0 L ];
y = [ 0 0 L L ];

%/////////////////////////////////////////////////////////////////////////////////////////////
%---------------------------Primer método LLS2------------------------------------------------
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% Primer método ---> Imponemos una variable ficticia "R" que remplazará a
% (x^2+y^2) y además nos queda que F = [ x y R ]'
%
% Entonces quedará la matriz Ai * F = bi

    for i = 1:4
        A (i,1) = [ -2 * x(i) ];
        A (i,2) = [ -2 * y(i) ];
        A (i,3) = 1;
        b (i,1) = d(i)^2 - x(i)^2 - y(i)^2;
    end 

disp('------------------Red Hibrida LLS1----------------------------------')

%Paso la matriz a sparce para ahorro de almacenamiento

    sparse(A);
    sparse(b);

%Calculo directamente los mínimos cuadrados a partir de la variable ficticia
%Siendo F lo que nos linealizá el sistema para que podamos resolver, será
%entonces nuestra variable a encontrar:
%F tendrá 3 componentes, 2 son las cordenadas, las primeras dos ( x , y )

    Fsol = inv((A'*A))*A'*b; 
    plls1 = [Fsol(1), Fsol(2)];

disp('Distancia en metros desde antena de referencia ubicada en (0,0):')
%Tomo la distancia como:
dis = sqrt( plls1(1) ^ 2 + plls1(2) ^ 2 )
dcord = [ abs( Fsol(1) ) , abs ( Fsol(2) ) ]
disp('Ángulo en grados:')
angle = atan ( plls1(2) / plls1(1) ) * 360 / ( 2 * pi )


%Repetiré el proceso para  ahora tener en cuenta 4 toa entonces remplazaré las 2 que eran
%rss por toa

    Trtt3 =  4*10^(-8); 
    d(3) = 3 * 10^8 * ( Trtt3 - Ttat ) / 2;

    Trtt4 =  4*10^(-8); 
    d(4) = 3 * 10^8 * ( Trtt4 - Ttat ) / 2;


    for i = 1:4
        A (i,1) = [ -2 * x(i) ] ;
        A (i,2) = [ -2 * y(i) ] ;
        A (i,3) = 1;
        b (i,1) = d(i) ^ 2 - x(i)^2 - y(i)^2 ;
    end 

sparse(A);
sparse(b);

%Realizo un cálculo propuesto por el paper para encontrar el valor de la
%variable, que es despejar la variable

Fsol = inv( ( A' * A) )* A' * b ; 

%La primer componente de Fsol es la x y la segunda es la Y
%por lo tanto:

plls1 = [Fsol(1), Fsol(2)]; %p de posicion


%Luego tomo la distancia como:
%
disp('---------------------Red no hibrida LLS1---------------------------------')
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt ( plls1(1)^2 + plls1(2) ^ 2 )
dcord = [ abs ( Fsol(1) ) , abs( Fsol(2) ) ]
disp('Ángulo en grados')
angle = atan ( plls1(2) / plls1(1) ) * 360 / ( 2 * pi )





%//////////////////////////////////////////////////////////////////////////////////////////////
%---------------------------Segundo metodo LLS2------------------------------------------------
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%
%Para el segundo método nececitamos fijar alguna antena como referencia
%EL paper nos propone 4 formas, para probar el método utilizo tomar una antena aleatoriamente
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
    sparse (A2);
    sparse (b2);
    sparse (k);
%Ahora debería hacer Aii * p = bii donde p tiene dos componentes, x e y
%que serán las cordenadas

Fsol = inv((A2'*A2))*A2'*b2; 
plls2 = [Fsol(1), Fsol(2)]; %p de posicion


disp('---------------------Red no hibrida LLS2---------------------------------')
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt( plls2(1) ^ 2 + plls2(2) ^ 2 )
dcord = [ abs( Fsol(1) ), abs( Fsol(2) ) ]
disp('Ángulo en grados')
angle = atan ( plls2(2) / plls2(1) ) * 360 / ( 2 * pi )

%Datos de antenas RSS
d(4) = sqrt(50);  d(3) = sqrt(50);

%repito proceso
xr = 0; yr= 0;
kr = [ xr^2 + yr^2 ];
for i = 1:4
    A2(i,1) = [ 2 * ( x(i) - xr ) ];
    A2(i,2) = [ 2 * ( y(i) - yr )];
    k(i,1) = [ x(i)^2 + y(i)^2 ];
    b2(i,1) = d(1)^2 - d(i)^2 - kr - k(i,1);
end 

sparse(A2);
sparse(b2);
sparse(k);

%Ahora deberia hacer Aii * p = bii donde p tiene dos componentes, x e y
%que seran las cordenadas

Fsol = inv((A2'*A2))*A2'*b2; 
plls2 = [Fsol(1), Fsol(2)]; %p de posicion


disp('---------------------Red hibrida LLS2---------------------------------')
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt( plls2(1) ^ 2 + plls2(2) ^ 2 )
dcord = [ abs( Fsol(1) ) , abs( Fsol(2) ) ]
disp('Angulo en grados')
angle = atan ( plls2(2) / plls2(1) ) * 360 / (2 * pi)




%//////////////////////////////////////////////////////////////////////////////////////////////
%---------------------------Tercer método WLLS1------------------------------------------------
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%
%Cuando incluimos las varianzas en la medicion, utilizar el método de  WWL se 
%lograría una ubicación aún más exacta, el paper nos menciona dos errores o varianzas
%ocasionadas por ruido blanco que serán quienes influyan y si obtenemos estos
%resultados es posible mejorarlo al programa

% Sigue el método de la variable simbólica pero luego agrega una variable más: 'C'
%Tengo que calcular las varianzas:
%las dejo 'supuestas' debo acordarme de calcularlo
var = [ 0.3 0.3 1.76 1.76 ];

for i = 1:4
    A3(i,1) = [ -2 * x(i) ];
    A3(i,2) = [ -2 * y(i) ];
    A3(i,3) = 1;
    b3(i,1) = d(i)^2 - x(i)^2 - y(i)^2;


    c3(i,i) = 4*var(i)*d(i)^2; 
    
end 

sparse(A3);
sparse(b3);
sparse(c3);

Fsol = inv ( ( A3' * inv(c3) * A3 ) ) * A3' * inv(c3) * b3; %%%%%%%%%Marca

%Aá copio las ecuaciones que propone el paper, no explica qué son y no se muy bien

G = [1 0; 0 1; 1 1];

K(1,1) = 2*Fsol(1);
k(2,2) = 2*Fsol(2);
k(3,3) = 1;

h = [ Fsol(1) ^ 2 , Fsol(2) ^ 2 , Fsol(3) ]';

Fi = K*inv((A3'*inv(c3)*A3))*K;

z = inv((G'*inv(Fi)*G))*G'*inv(Fi)*h; 

%Llegando al final a un resultado tal

pwlls1 = [ sign ( Fsol(1) ) * sqrt ( abs( z(1) ) ) , sign ( Fsol(2) ) * sqrt ( abs ( z(2) ) ) ];

disp('---------------------Red hibrida WLLS1---------------------------------')

disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt(pwlls1(1)^2+pwlls1(2)^2)
dcord = [abs(pwlls1(1)),abs(pwlls1(2))]
disp('Angulo en grados')
angle = atan(pwlls1(2)/pwlls1(1))*360/(2*pi)







%//////////////////////////////////////////////////////////////////////////////////////////
%---------------------------------Ultimo metodo WLLS2--------------------------------------
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

x = [ 0 L 0 L ];
y = [ 0 0 L L ];
% r = ( 0 , 0), coordenadas de la antena de referencia
j=1;
for i = 1:4
    
c4(i,j) = 4 * d(1)^2 * var(1)^2 + 3*var(1)^4 - var(1)^2 * (var(i)^2 + var(j)^2) + var(i)^2 * var(j)^2;
        if ( i == j )
            valor = 1;
        else
            valor = 0;
        end 

c4(i,j) = c4(i,j) - valor * ( 4 * d(i)^2 * var(i)^2 + 2 * var(i)^4);

    j=j+1;
end

% La antena de referencia no hay que tomarla

xr = 0; yr= 0;
kr = [ xr^2 + yr^2 ];
for i = 1:4
    A4(i,1) = [ 2 * ( x(i) - xr ) ];
    A4(i,2) = [ 2 * ( y(i) - yr )];
    k(i,1) = [ x(i)^2 + y(i)^2 ];
    b4(i,1) = d(1)^2 - d(i)^2 - kr - k(i,1);
end 

sparse(A4);
sparse(b4);
sparse(k);

%Ahora debería hacer Aii * p = bii donde p tiene dos componentes, x e y
%que serán las cordenadas

Fsol = inv((A4'*inv(c4)*A4))*A4'*inv(c4)*b4; 
pwlls2 = [Fsol(1), Fsol(2)]; %p de posicion

disp('---------------------Red hibrida WLLS2---------------------------------')
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
dis = sqrt(pwlls2(1)^2+pwlls2(2)^2)
dcord = [abs(pwlls2(1)),abs(pwlls2(2))]
disp('Ángulo en grados')
angle = atan(pwlls2(2)/pwlls2(1))*360/(2*pi)


warning ( 'on' )
