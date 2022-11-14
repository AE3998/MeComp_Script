function [reaction] = fem2d_pstr_reaction(K,F,U,Fixnodes)
% Descripción: módulo para calcular las reacciones presentes en nodos con condición
% de borde Dirichlet.

% Entrada:
% * K: matriz del sistema.
% * F: vector de fuerzas.
% * U: vector solución (desplazamientos). Cada elemento del vector representa un
%   valor vectorial (dos grados de libertad) asociado a cada nodo de la malla, y
%   su posición dentro del vector depende de cómo se especificó cada nodo en xnode.
% * Fixnodes: matriz con la información sobre la frontera de tipo Dirchlet.
%   - Columna 1: índice de nodo
%   - Columna 2: valor del desplazamiento en x.
%   - Columna 3: valor del desplazamiento en y.

% Salida:
% * reaction: vector de reacciones. Por cada nodo se computan las componentes x e y 
%   de la reacción en dicho nodo.
% ----------------------------------------------------------------------

    reaction = [];

end