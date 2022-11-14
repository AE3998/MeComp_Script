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

    Def = [];
    Ten = [];
    Ten_VM = [];

end