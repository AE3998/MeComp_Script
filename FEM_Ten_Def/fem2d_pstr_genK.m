function [localK] = fem2d_pstr_genK(nodes,D,th)
% Descripción: módulo para calcular y evaluar de forma numérica la matriz de rigidez K.
% Se utilizan funciones de forma en coordenadas naturales y se resuelve la integral
% de forma numérica utilizando cuadratura de Gauss.

% Entrada:
% * nodes: nodos (x,y) del elemento. Los elementos admisibles son de 3 o 4 nodos.
% * D: matriz constitutiva.
% * t: espesor de la placa.

% Salida:
% * localK: matriz de rigidez del elemento (local).
% ----------------------------------------------------------------------
  n = size(nodes, 1);
  localK = zeros(n);

  if n == 3
  % Elemento triangular
    J = [nodes(2, :) - nodes(1, :);...
         nodes(3, :) - nodes(1, :)];
    % Determinar las derivadas parciales dNi/dx, dNi/dy (inv(J)*[dNi/ds; dNi/dt)
    Baux = J\[-1 1 0; -1 0 1];
    % Armar a pata Be
    Be = zeros(3, 6);

    % Las filas que contienen dNi/ds
    Be(1, [1 3 5]) = Baux(1, :);
    Be(3, [2 4 6]) = Baux(1, :);

    % Las filas que contienen dNi/dt
    Be(2, [2 4 6]) = Baux(2, :);
    Be(3, [1 3 5]) = Baux(2, :);

    localK = 0.5* (Be'*D*Be)*det(J) *th;

  else
  % Elemento cuadrangular
    xi = sqrt(3)/3;
    p = [-xi, -xi, xi, xi, -xi];
    for i = 1:4
      s = p(i);   % chi
      t = p(i+1); % eta
      dNi = 0.25*[ -(1-t) (1-t) (1+t) -(1+t);...
                   -(1-s) -(1+s) (1+s) (1-s)];
      J = dNi*nodes;
      Baux = J\dNi;%inv(J)*dNi;

      % Armar a pata Be
      Be = zeros(3, 8);

      % Las filas que contienen dNi/ds
      Be(1, [1 3 5 7]) = Baux(1, :);
      Be(3, [2 4 6 8]) = Baux(1, :);

      % Las filas que contienen dNi/dt
      Be(2, [2 4 6 8]) = Baux(2, :);
      Be(3, [1 3 5 7]) = Baux(2, :);

      localK += (Be'*D*Be)*det(J) *th;
    endfor

  endif

endfunction
