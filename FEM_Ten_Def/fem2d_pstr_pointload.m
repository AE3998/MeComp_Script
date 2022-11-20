function [F] = fem2d_pstr_pointload(F,pointload,xnode,icone)
% Descripción: módulo para calcular y ensamblar las contribuciones producidas por
% fuerzas puntuales aplicadas en posiciones (x,y) dentro de elemento(s) del dominio.
% Estos pares (x,y) también pueden ubicarse en los bordes del elemento, incluso en
% alguno de sus vértices.

% Entrada:
% * F: vector de fuerzas.
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de cada
% nodo de la malla.
% * icone: matriz de conectividad. Indica los 3 ó 4 nodos que integran el elemento,
% recorridos en cualquier orden pero en sentido antihorario. En caso de elementos
% triangulares, la cuarta columna siempre es -1.
% * pointload: matriz con la información sobre las fuentes puntuales aplicadas a
% elementos del dominio.
%   - Columna 1: índice de elemento al que se aplica la fuerza.
%   - Columna 2: valor de la fuerza aplicada en sentido eje-x.
%   - Columna 3: valor de la fuerza aplicada en sentido eje-y.
% Columnas 4-5: posición (x,y) dentro del elemento donde se aplica la fuerza.
%
% Salida:
% * F: vector de fuerzas con modificaciones luego de aplicar la condición de borde.
% ----------------------------------------------------------------------
  for i = 1:size(pointload, 1)
    % Elemento e
    e = pointload(i, 1);

    % Punto (xp, yp)
    xp = pointload(i, 4);
    yp = pointload(i, 5);

    % Saco los indices del elemento e
    if icone(e, 4) == -1
      % Triangulo
      ele = icone(e, 1:3);
    else
      % Cuadrangulo
      ele = icone(e, :);
    endif

    % Saco los xnodes correspondientes, con eso despejo los pesos Ni
    nodes = xnode(ele, :);
    Ni = fem2d_pstr_blerp(nodes, xp, yp);

    % Nuevamente, si los idx de elementos es [1 2 5 | 4], sus idx en u y en v son
    % ui = [1 3 9 | 7], vi = [2 4 10 | 8]
    u = 2*ele - 1;
    v = 2*ele;

    F(u) += Ni*pointload(i, 2);
    F(v) += Ni*pointload(i, 3);

  endfor

endfunction







