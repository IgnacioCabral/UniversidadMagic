function [ dis , dcord , ang ] = WLLS2 ( x , y , d , var )
%Algoritmo de localizacion WLLS-2
%Se debe ingresar las posicionnes de las antenas "x" "y", la distancia "d"
%del agente a las antenas y sus respectivas varianzas "var".
%La funci�n devolver� un vector cuya componente:
%1: la distancia de la antena al agente en cuesti�n
%2: las coordenadas [ x y ] del agente
%3: �ngulo del agente seg�n la referencia 

j=1;
for i = 1:4
    
c4(i,j) = 4 * d(1)^2 * var(1)^2 + 3*var(1)^4 - var(1)^2 * (var(i)^2 + var(j)^2) + var(i)^2 * var(j)^2;

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

%Ahora deberia hacer Aii * p = bii donde p tiene dos componentes, x e y
%que seran las cordenadas

Fsol = inv((A4'*inv(c4)*A4))*A4'*inv(c4)*b4; 

pwlls2 = [Fsol(1), Fsol(2)]; %p de posicion

dis = sqrt(pwlls2(1)^2+pwlls2(2)^2);

dcord = [abs(pwlls2(1)),abs(pwlls2(2))];

ang = atan(pwlls2(2)/pwlls2(1))*360/(2*pi);