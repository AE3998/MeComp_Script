function [localF] = fem2d_pstr_genF(nodes,Fg,th)
% Descripción: módulo para calcular el vector de fuerzas F para cada elemento,
% producto de la presencia de una fuerzas por unidad de volumen (generalmente
% la gravedad) en dicho elemento. La integral se resuelve mediante cuadratura
% de punto medio, y se requiere evaluar el área del elemento.

% Entrada:
% * nodes: nodos (x,y) del elemento. Los elementos admisibles son de 3 o 4 nodos.
% * Fg: magnitud de la fuerza gravitatoria.
% * th: espesor de la placa.

% Salida:
% * localF: vector local de fuerzas.
% ----------------------------------------------------------------------
  n = size(nodes, 1);
  F = zeros(1, 2*n);
  if n == 3
    % Area del triangulo
    Ae = 0.5* det([ones(3, 1) nodos]);
    F([2 4 6]) = -Ae*Fg*th/3;
  else
    % Area de 2 triangulos = cuadrado
    A1 = 0.5* det([ones(3, 1) nodos([1 2 3], :)]);
    A2 = 0.5* det([ones(3, 1) nodos([1 3 4], :)]);
    Ae = A1 + A2;
    F([2 4 6 8]) = -Ae*Fg*th/4;
  endif

endfunction
