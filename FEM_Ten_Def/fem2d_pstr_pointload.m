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
end