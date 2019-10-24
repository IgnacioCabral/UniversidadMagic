function [ dis, dcord, ang ] = LLS2( x, y, d, xr, yr )

% Funcion que aplica el metodo de minimos cuadrdos con la utilizacion de
% una antena de referencia

% Variables de entrada:
    % x e y son las cordenadas de las antenas.
    % d seran las distancias medidas por las antenas.
    % xr e yr es la posicion de la antena de referencia.
    
% Variables de salida:
    % dis es la distancia de de la antena al agente en cuestion.
    % dcord son las coordenadas del agente.
    % ang es el angulo del agente segun la referencia.

kr = [ xr^2 + yr^2 ];

% Esta creada para 4 antenas ubicadas en cuadrado respecto de cero
% es decir (0,0)...(L,L).

% Creacion de la matriz

for i = 1:4
    A2(i,1) = [ 2 * ( x(i) - xr ) ];
    A2(i,2) = [ 2 * ( y(i) - yr )];
    k(i,1) = [ x(i)^2 + y(i)^2 ];
    b2(i,1) = d(1)^2 - d(i)^2 - kr - k(i,1);
end 

sparse(A2);
sparse(b2);
sparse(k);

% Aplico metodo LLS

Fsol = inv((A2'*A2))*A2'*b2; 
plls2 = [Fsol(1), Fsol(2)]; %p de posicion

dis = sqrt(plls2(1)^2+plls2(2)^2);
dcord = [abs(Fsol(1)), abs(Fsol(2))];
ang = atan(plls2(2)/plls2(1))*360/(2*pi);