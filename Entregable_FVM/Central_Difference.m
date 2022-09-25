function [Phi Pex]= Central_Difference(malla, k, pCp, G, v)

% Reconstruir la k
  k = k/pCp;

% len -> cantidad de "caras"
  len = length(malla);

% Dx -> longitud de cada celda.[_x_]
  Dx = malla(2:len)-malla(1:len-1);

% xp -> posicion del centro de cada celda [ x ]
  xp = malla(1:len-1) + Dx/2;

% dx -> distancia entre cada par del centro de celda (puede hacer falta las fronteras)
% [ 1_|_2 ... | n-1_|_n ]
  dx = xp(2:end) - xp(1:end-1); # la longitud esta reducida, por lo que se recurre usar end.

% De -> k/de, coeficiente acompanado al termino Este del difusivo
  De = k/dx(1:end-1);

% Dw -> k/dw, coeficiente acompanado al termino Oeste del difusivo
  Dw = k/dx(2:end);

% Las coeficientes de peso Be y Bw se tienen en cuenta solamente las celdas
% interiores que no se tocan con los bordes. [ x | 2 | ... | n-1 | x ] los cuales
% x seran excluidos en los calculos.

% Be -> centro del borde Este - centro de celda xp.
% xe - xp = [ x | 2_| ..._| n-1_| x ]
  Be = malla(3:end-1)-xp(2: end-1);

% Bw -> centro de celda xp - centro del borde Oeste.
% xp - xw = [ x |_2 |_... |_n-1 | x ]
  Bw = xp(2: end-1)-malla(2:end-2);

% A modo de complemento, por si esta equivocado se puede borrar:
% Se supone que cada borde tienen sus coeficientes correspondientes. Si hablo de
% de la frontera Oeste, el coeficiente es Bw = (xp - xw)/(xp - xW) con xW = xw.
% Esto significa que Bw en este caso valdra 1. El proceso sera identico con
% el tratamiento de Be con la frontera Este. Be = (xe - xp)/(xE - xp) siendo
% xE = xe y Be = 1 en aquella frontera. Se calcula de esta manera ya que el centro
% de cada frontera es tratado como un "centro de celda adicional".
% Se agrega el peso de cada frontera como se muestra en la siguiente
% explicacion.

% Be += [ x_| 2 | ... | n-1 | x_]
%  Be = [malla(2)-xp(1), Be, 1];

% Bw += [_x | 2 | ... | n-1 |_x ]
%  Bw = [1, Bw, xp(end)-malla(end-1)];

% Repasando la teoria, parece que nuna hay un tratamiento con el peso de la
% frontera. -> [ x_] y [_x ] no van creo. De hecho el tamano del vector tampoco
% se coinciden si luego lo combino con el vector de dx. De esta manera se crea un sistema
% de ecuacion con los extremos 1, con las incongnitas los centros del celdas.

%% 1er Suposicion, la dx esta bien y B estan mal. no deberia incluirse las fronteras
% En este caso -aw,2 y -aw,m del sistema seran 0.


% Be += [ x_| 2 | ... | n-1 | x ]
  Be = [malla(2)-xp(1), Be];

% Bw += [ x | 2 | ... | n-1 |_x ]
  Bw = [Bw, xp(end)-malla(end-1)];

% Se procede a calcular los coeficientes de la matriz, sabiendo que aE, aW tienen
% tamano n-1 siendo n la cantidad del centro de celda. Esto se debe a que
% la cantidad de distancia entre pares de celdas es n-1.

% aE = (De - ve*Be)/Dx
  aE = [(De - v*Be)/Dx), 0];

% aW = (Dw + vw*Bw)/Dx
  aW = [0, (Dw + v*Bw)/Dx];

% ap = aE + aW
  ap = aE + aW

% Creacion de la matriz K. Recordar que el centro de celda hay n, la cnatidad de
% centro de caras hay n+2 que es len+1.
K = sparse( [[1:len+1]  , [2:len+1] , [1:len]]    ,
            [[1:len+1]  , [1:len]   , [2:len+1]]  ,
            [[1, ap, 1] , [aW]      , [aE]]       );

f = []

Pex = max(v*Dx/k);
endfunction
