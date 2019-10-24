function [ dis, dcord, ang ] = WLLS1( var, x, y, d )

% Funcion que aplica el metodo de minimos cuadrdos ponderados con la 
% utlizacion de una variable ficticia.

% Variables de entrada:
    % x e y son las coordenadas de las antenas.
    % d es la distancai medida por las antenas.
    % var es el vector de la varianza de las mediciones de las antenas.
    
% Variables de salida:
    % dis es la distancia de de la antena al agente en cuestion.
    % dcord son las coordenadas del agente.
    % ang es el angulo del agente segun la referencia.

    
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

Fsol = inv((A3'*inv(c3)*A3))*A3'*inv(c3)*b3; 

%Defino variables auxiliares al calculo

G = [1 0; 0 1; 1 1];

K(1,1) = 2*Fsol(1);
k(2,2) = 2*Fsol(2);
k(3,3) = 1;

h = [ Fsol(1)^2 , Fsol(2)^2, Fsol(3) ]';
Fi = K*inv((A3'*inv(c3)*A3))*K;
z = inv((G'*inv(Fi)*G))*G'*inv(Fi)*h; 

pwlls1 = [sign(Fsol(1)) * sqrt(abs( z(1)) ) , sign(Fsol(2))*sqrt(abs( z(2)) )];

dis = sqrt(pwlls1(1)^2+pwlls1(2)^2);
dcord = [abs(pwlls1(1)),abs(pwlls1(2))];
ang = atan(pwlls1(2)/pwlls1(1))*360/(2*pi);