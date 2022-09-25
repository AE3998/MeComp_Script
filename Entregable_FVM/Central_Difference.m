function [Phi Pex]= Central_Difference(malla, k, pCp, G, v)


% len -> cantidad de "caras"
  len = length(malla);

% Dx -> longitud de cada celda.
  Dx = malla(2:len)-malla(1:len-1);

% xp -> posicion del centro de cada celda
  xp = malla(1:len-1) + Dx/2;

% dx -> distancia entre cada par del centro de celda (puede hacer falta las fronteras)
  dx = xp(2:end) - xp(1:end-1); # la longitud esta reducida, por lo que se recurre usar end.

% De -> k/de, coeficiente acompanado al termino Este del difusivo
  De = k/dx(1:end-1);

% Dw -> k/dw, coeficiente acompanado al termino Oeste del difusivo
  De = k/dx(2:end);

% Las coeficientes de peso Be y Bw se tienen en cuenta solamente las celdas
% interiores que no se tocan con los bordes. [ x | 2 | ... | n-1 | x ] los cuales
% x seran excluidos en los calculos.

% Be -> centro del borde Este - centro de celda xp.
% xe - xp = [ x | 2_| ..._| n-1_| x ]
  Be = malla(3:end-1)-xp(2: end-1);

% Bw -> centro de celda xp - centro del borde Oeste.
% xp - xw = [ x |_2 |_... |_n-1 | x ]
  Bw = xp(2: end-1)-malla(2:end-2);



endfunction
