function [K,F] = fem2d_pstr_fixnodes(K,F,Fixnodes)
% Descripción: módulo para calcular y ensamblar las contribuciones de nodos
% pertenecientes a fronteras con desplazamientos fijos.

% Entrada:
% * K: matriz del sistema.
% * F: vector de fuerzas.
% * Fixnodes: matriz con la información sobre la frontera de tipo Dirchlet.
%   - Columna 1: índice de nodo
%   - Columna 2: dirección de desplazamiento:
%       1- sentido eje-x.
%       2- sentido eje-y.
%   - Columna 3: valor del desplazamiento.

% Salida:
% * K: matriz del sistema luego de realizar las simplificaciones que surgen de
% aplicar la condición de borde.
% * F: vector de fuerzs luego de realizar las simplificaciones que surgen de
% aplicar la condición de borde.
% ----------------------------------------------------------------------
  for i = 1:size(Fixnodes, 1)
    nodo = Fixnodes(i, 1);

    % Indice de fila de la matriz a manipular, que justo vale 1 o 2
    %idx = 2*nodo + Fixnodes(i, 2) - 2;
    if (Fixnodes(i, 2) == 1)
      idx = 2*nodo-1;
    else 
      idx = 2*nodo;
    endif
    
    K(idx, :) = 0;
    K(idx, idx) = 1;
    F(idx) = Fixnodes(i, 3);
  endfor

endfunction
