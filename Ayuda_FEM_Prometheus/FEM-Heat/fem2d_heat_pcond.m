function [F] = fem2d_heat_pcond(F,xnode,icone,PUN)
% Descripción: módulo para calcular y ensamblar las contribuciones producidas
% por fuentes puntuales aplicadas en posiciones (x,y) dentro del dominio. Estos
% pares (x,y) también pueden ubicarse en los bordes del elemento, incluso en 
% alguno de sus vértices.

% Entrada:
% * F: vector de flujo térmico.
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de 
%   cada nodo de la malla.
% * icone: matriz de conectividad. Indica los 3 ó 4 nodos que integran el 
%   elemento, recorridos en cualquier orden pero en sentido antihorario. 
%   En caso de elementos triangulares, la cuarta columna siempre es -1.
% * PUN: matriz con la información sobre las fuentes puntuales aplicadas a 
%   elementos del dominio. 
%   - Columna 1: número de elemento al que se aplica la fuente.
%   - Columna 2: valor de la fuente aplicada (G). 
%   - Columnas 3-4: posición absoluta (x,y) donde se aplica la fuente 
%     (cualquier parte del dominio).

% Salida:
% * F: vector de flujo térmico con modificaciones luego de aplicar la condición
%   de borde.

    for n = 1 : size(PUN,1)
        e = PUN(n,1);
        G = PUN(n,2);
        xp = PUN(n,3);
        yp = PUN(n,4);
        if icone(e,4) == -1 % triangular element
            ele = icone(e,1:3);
        else
            ele = icone(e,:);
        end
        nodes = xnode(ele,:);
        N = fem2d_heat_blerp(nodes,xp,yp); % evaluación de las funciones de forma en coordenadas naturales
        f = N*G;
        F(ele) = F(ele) + f;
    end

end