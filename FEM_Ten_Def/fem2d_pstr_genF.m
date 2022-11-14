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
    
    localF = [];
    
end