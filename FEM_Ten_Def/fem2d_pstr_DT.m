function [Def,Ten,Ten_VM] = fem2d_pstr_DT(xnode,icone,model,D,U)
% Descripción: módulo para calcular las deformaciones y tensiones a partir de los
% desplazamientos calculados U. También se calculan las tensiones de Von Misses.

% Entrada:
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de cada
%   nodo de la malla.
% * icone: matriz de conectividad. Cada fila de la matriz indica la conectividad
%   de un elemento rectangular, comenzando por el extremo inferior izquierdo y
%   recorriendo el elemento en sentido antihorario.
% * model: struct con todos los datos del modelo (constantes, esquema numérico, etc.).
% * D: matriz constitutiva.
% * U: vector solución (desplazamientos). Cada elemento del vector representa un
%   valor vectorial (dos grados de libertad) asociado a cada nodo de la malla, y
%   su posición dentro del vector depende de cómo se especificó cada nodo en xnode.

% Salida:
% * Def: deformaciones. Para cada nodo de la malla se calculan los tres valores típicos de deformaciones.
% * Ten: tensiones. Para cada nodo de la malla se calculan los tres valores típicos de tensiones.
% * Ten_VM: tensión de Von Misses. Para cada nodo de la malla se calcula el valor de tensión de Von Misses asociado a dicho nodo.
% ----------------------------------------------------------------------
  Def_node = zeros(model.nnodes, 4);
  for e = 1:size(icone, 1)
    if icone(e, 4) == -1
      ele = icone(e, 1:3);
      u = 2*ele-1; v = 2*ele;

      % Indices (ui, vi) de los nodos del elemento e en la matriz global
      %idx = [u(1) v(1) u(2) v(2) u(3) v(3)];
      idx = reshape([u; v], 1, 6);

      nodes = xnode(ele, :);

      J = [ nodes(2, :) - nodes(1, :); ...
            nodes(3, :) - nodes(1, :)];
      Baux = J\[-1 1 0; -1 0 1];

      Be = zeros(3, 6);
      % Las filas que contienen dNi/ds
      Be(1, [1 3 5]) = Baux(1, :);
      Be(3, [2 4 6]) = Baux(1, :);

      % Las filas que contienen dNi/dt
      Be(2, [2 4 6]) = Baux(2, :);
      Be(3, [1 3 5]) = Baux(2, :);

      % Deformacion = [dNi/dx*ui; dNi/dy*vi; dNi/dy*ui+dNi/dx*vi]
      Def_node_xy = [Be*U(idx)]';

      % Agregar en cada "nodo" las Deformaciones y la cantidad que se
      % repite este nodo cuando recorro los elementos
      for i = 1:3
        Def_node(ele(i), :) += [Def_node_xy, 1];
      endfor
    else
      ele = icone(e, :);
      nodes = xnode(ele, :);

      % Indices ui y vi en la matriz global
      u = ele*2-1;
      v = ele*2;

      % [u(1) v(1) ... u(4) v(4)]
      idx = reshape([u; v], 1, 8);

      % Recorrer los 4 puntos con sus pesos wi = 1
      p = [-1 -1 1 1 -1];
       for i = 1:4
          s = p(i+1); % chi
          t = p(i);   % eta
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

          Def_node_xy = [Be*U(idx)]';

          % Agregar a cada "nodo" las Deformaciones y la cantidad que se
          % repite este nodo cuando recorro los elementos
          Def_node(ele(i), :) += [Def_node_xy, 1];
       endfor
    endif
  endfor

  % Matriz de deformacion promediado
  Def(:, 1) = Def_node(:, 1)./Def_node(:, 4);
  Def(:, 2) = Def_node(:, 2)./Def_node(:, 4);
  Def(:, 3) = Def_node(:, 3)./Def_node(:, 4);

  % Matriz de tensiones
  Ten = (D*Def')';

  % Matriz de tension de Von Misses
  Ten_VM = Ten(:, 1).^2 - Ten(:, 1).*Ten(:, 2) +...
           Ten(:, 2).^2 + 3*Ten(:, 3).^2;

endfunction
