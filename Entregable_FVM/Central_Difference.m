function [Phi Pex PeL K]= Central_Difference(malla, phi_1, phi_L, k, pCp, G, v)

% Reconstruir la k, L longitud global
  k = k/pCp;
  L = malla(end);

% len -> cantidad de "caras"
  len = length(malla);

% Dx -> longitud de cada celda.[_x_]
  Dx = malla(2:len)-malla(1:len-1);

% xp -> posicion del centro de cada celda [ x ]
  xp = malla(1:len-1) + Dx/2;

% dx -> distancia entre cada par del centro de celda
% [ 1_|_2 ... | n-1_|_n ]
  dx = xp(2:end) - xp(1:end-1);

% Suposicion que De = Dw = k/dx ya que depende solamente por donde esta posicionado
  De = Dw = k./dx;

% Las coeficientes de peso Be y Bw se tienen en cuenta solamente las celdas
% interiores que no se tocan con los bordes. [ x | 2 | ... | n-1 | x ] los cuales
% x seran excluidos en los calculos.

% Be -> centro del borde Este - centro de celda xp.
% xe - xp = [ x_| 2_| ..._| n-1_| x ]
  Be = malla(2:end-1)-xp(1: end-1);

% Bw -> centro de celda xp - centro del borde Oeste.
% xp - xw = [ x |_2 |_... |_n-1 |_x ]
  Bw = xp(2: end)-malla(2:end-1);

% Se procede a calcular los coeficientes de la matriz, sabiendo que aE, aW tienen
% tamano n-1 siendo n la cantidad del centro de celda. Esto se debe a que
% la cantidad de distancia entre pares de celdas es n-1.

% Esto debe incluir las
% las condiciones de borde, los los cuales Be y Bw seran 1.

DeCB = 2*k/Dx(end);
DwCB = 2*k/Dx(1);


% aE = (De - ve*Be)/Dx
  aE = [(De - v*Be)./Dx(1:end-1), (DeCB - v)./Dx(end)];

% aW = (Dw + vw*Bw)/Dx
  aW = [(DwCB + v)./Dx(1), (Dw + v*Bw)./Dx(2:end)];

% ap = aE + aW
  ap = aE + aW;

% Creacion de la matriz K. Recordar que el centro de celda hay n, la cnatidad de
% centro de caras en el borde hay 2, que en total son n+2 y es len+1.

K = sparse( [[1:len+1]    , [2:len]   , [2:len]],
            [[1:len+1]    , [1:len-1] , [3:len+1]]  ,
            [[1, ap, 1]   , [aW]      , [aE]]     );

% Definicion de f como un vector; si G es un escalar lo pasa a un vector
if(length(G) == 1)
  G = ones(1, length(xp))*G;
endif
f = [phi_1, G, phi_L]';

Phi = K\f;

Pex = max(v*Dx/k);
PeL = (v*L/k);


endfunction
