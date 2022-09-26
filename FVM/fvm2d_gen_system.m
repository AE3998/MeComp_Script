function [K,F] = fvm2d_gen_system(K,F,neighb,cells,c,G)
% Descripción: módulo para ensamblar los términos difusivo, reactivo y fuente de
% todas las celdas de la malla, generando el stencil adecuado dependiendo de si 
% alguna de sus caras pertenece o no a la frontera.

% Entrada:
% * K: matriz del sistema (difusión + reacción).
% * F: vector de flujo térmico.
% * neighb: matriz de vecindad.
% * cells: vector de celdas.
% * c: constante del término reactivo. Es un vector que permite representar c(x,y).
% * G: fuente volumétrica. Es un vector que permite representar G(x,y).

% Salida:
% * K: matriz del sistema (difusión + reacción) con modificaciones luego del ensamble.
% * F: vector de flujo térmico con modificiaciones luego del ensamble.
% ----------------------------------------------------------------------
end
