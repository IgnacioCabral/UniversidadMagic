function [ dis, dcord, ang ] = LLS2(x,y,d,xr,yr)

% Variables de entrada:
    % x e y son las cordenadas de las antenas.
    % d seran las distancias medidas por las antenas.
    % xr e yr es la posicion de la antena de referencia.

kr = [ xr^2 + yr^2 ];

% Funcion que aplica el metodo de la variable ficticia.
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

% Aplico metodo WLLS

Fsol = inv((A2'*A2))*A2'*b2; 
plls2 = [Fsol(1), Fsol(2)]; %p de posicion

dis = sqrt(plls2(1)^2+plls2(2)^2);
dcord = [abs(Fsol(1)), abs(Fsol(2))];
ang = atan(plls2(2)/plls2(1))*360/(2*pi);