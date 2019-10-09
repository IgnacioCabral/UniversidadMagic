clear all
clc

%Primero debo ingresar los datos que necesito
%
%
%--------------Parte HIbrida------------------------------------------------------------------
%Tenemos dos ecuaciones de distancia suponiendo que la red o las anclas son de tipo hibrido
%es decir, tendremos 2 RSS y 2 TOA
%---------------------------------------------------------------------------------------------
%Supongamos un ecenario de LxL en metros, de 4 antenas o anclas y en forma cuadrada como para
%ubicarse mejor
% 
%   ANTENA RSS (0,L) ------------------- ANTENA RSS (L,L)
%          -                                 -
%          -                                 -     
%          -                 AGENTE          -     
%          -                                 -
%   ANTENA TOA (0,0) ------------------- ANTENA TOA (L,0)
%
% El valor de L propuesto por el paper es de 10 metros
    
L=10;

% Aclara que el agente se puede cambiar la ubicacion cada 2 metros
% por lo tanto el cuadrado formado por las antenas sera de dividido en 5x5 cudriculas que seran
% las posibles ubicaciones
% 
% ---------------------------------------------------------------------------------------------- 
% Ecuacion principal con la que vamos a trabajar:
% d = p - pi = ( ( x - xi )^2 + ( y - yi )^2 )^1/2
%
% ESta ecuacion no es lineal, por ende utilizaremos diferentes tecnicas de minimo cuadrado
% para linealizar esta ecuacion y luego llegar a un valor aproximado
% 
% ----------------------------------------------------------------------------------------------
% Primer metodo ---> Imponemos una variable ficticia "R" que remplazara a x^2+y^2
% 
% y ademas nos queda que F = [ x y R ]'
%
% Entonces quedara la matriz Ai * F = bi

%Ai = [ [-2 * xi]' , [- 2 * y(i)]', unos];

%bi = d(i)^2 - x(i)^2 - y(i)^2;

%Siendo F lo que nos linealiza el sistema para que podamos resolver, es
%entonces nuestra variable a encontrar
%------------------------------------------------------------------------------------------------
%Resolucion
%Supongamos que en el cuadrado de 10x10 el movil esta en aproximadamente
%4 en x y 5 en y
%Valores supuesto de mediciones
xi = ( 4.5 - 3.5 ) .* rand(10,1)+ 3.5;
yi = ( 5.5 - 4.5) .* rand(10,1)+ 4.5;
largo = length(xi);
unos = ones(1,10);
%Armo la matriz
xmatriz = -2 * xi;
ymatriz = - 2 * yi;
Ai = [  xmatriz , ymatriz , unos'];
%Armo el vector b resultado
di=10; %Lo saque de paper esto
bi = di^2 - xi.^2 - yi.^2;
%---------------------------------------------------------------------------------------------
%
%Paso la matriz a una formato ralo
%
sparse(Ai);
%
%Realizo un calculo propuesto por el paper para encontrar el valor de la
%variable, que es despejar la variable

Fsol = inv((Ai'*Ai))*Ai'*bi; 

%La primer componente de Fsol es la x y la segunda es ls Y
%por lo tanto:

plls1 = [Fsol(1), Fsol(2)]; %p de posicion

%--------------------------------------------------------------------------------------------
%Luego tomo la distancia como:
%
disp('Distancia en metros desde antena de referencia ubicada en (0,0)')
d = sqrt(plls1(1)^2+plls1(2)^2)
disp('Angulo en grados')
angle = atan(plls1(2)/plls1(1))*360/(2*pi)

%%%%%Hay que verlo bien pero creo que por aca va la cosa, yo intente hacer
%%%%%el primer metodo que es el LL1







