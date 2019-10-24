function [ dis , dcord , ang ] = WLLS2 ( x , y , d , var )

% Funcion que aplica el metodo de minimos cuadrdos ponderados con la 
% utlizacion de una antena de referencia.
% Variables de entrada:
    % x e y son las coordenadas de las antenas.
    % d es la distancai medida por las antenas.
    % var es el vector de la varianza de las mediciones de las antenas.
    
% Variables de salida:
    % dis es la distancia de de la antena al agente en cuestion.
    % dcord son las coordenadas del agente.
    % ang es el angulo del agente segun la referencia.

j=1;

for i = 1:4
    
c4(i,j) = 4 * d(1)^2 * var(1)^2 + 3*var(1)^4 - var(1)^2 * (var(i)^2 + var(j)^2) + var(i)^2 * var(j)^2;

j=j+1;

end

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


Fsol = inv((A4'*inv(c4)*A4))*A4'*inv(c4)*b4; 

pwlls2 = [Fsol(1), Fsol(2)]; %p de posicion

dis = sqrt(pwlls2(1)^2+pwlls2(2)^2);

dcord = [abs(pwlls2(1)),abs(pwlls2(2))];

ang = atan(pwlls2(2)/pwlls2(1))*360/(2*pi);