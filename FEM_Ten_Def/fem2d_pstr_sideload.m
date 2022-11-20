function [F] = fem2d_pstr_sideload(F,Sideload,xnode,th)
% Descripción: módulo para calcular y ensamblar las contribuciones de pares de nodos
% (lados) donde se aplican cargas distribuidas.

% Entrada:
% * F: vector de fuerzas.
% * sideload: matriz con la información sobre fronteras con cargas distribuidas.
%   - Columnas 1-2: dos nodos contiguos formando un lado de un elemento.
%   - Columna 3: valor de fuerza en sentido eje-x.
%   - Columna 4: valor de fuerza en sentido eje-y.
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de cada nodo
%   de la malla.
% * th: espesor de la placa.

% Salida:
% * F: vector de fuerzas. Presenta modificaciones luego de aplicar la condición de borde.
% ----------------------------------------------------------------------
  for i = 1:size(Sideload, 1)
    nodo1 = Sideload(i, 1);
    nodo2 = Sideload(i, 2);

    % Tensiones en eje_x y eje_y
    tx = Sideload(i, 3);
    ty = Sideload(i, 4);

    % Distancia dij
    dij = norm(xnode(nodo2, :) - xnode(nodo1, :));

    % Si el par de nodos es [2 5], sus indices correspondientes son
    % ui = [3 9], vi = [4 10]
    u = 2*Sideload(i, [1 2]) - 1;
    v = 2*Sideload(i, [1 2]);

    F(u) += dij*tx*th*0.5;
    F(v) += dij*ty*th*0.5;
  endfor
end
