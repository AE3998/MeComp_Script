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

for P = 1:length(G)
  % Seguir la nomenclatura [1 2 3 4] -> [s e n w] en los parametros
  ki = [cells(P).ks, cells(P).ke, cells(P).kn, cells(P).kw];
  di = [cells(P).ds, cells(P).de, cells(P).dn, cells(P).dw];
  ai = [cells(P).as, cells(P).ae, cells(P).an, cells(P).aw];

  % Los coeficientes de cada vecino
  Ri = ki.*ai./di;

  % Recorrer los vecinos y verificar si es un borde, cuando es falso
  % se suma los coeficientes.
  for i = 1:4
    if(neighb(P, i) != -1)
      K(P,P) += Ri(i);
      K(P, neighb(P, i)) = -Ri(i);
    endif
  endfor
  % Termino cV
  K(P, P) += c(P)*cell(P).v;
  endfor

F = G.*cell(:).v;

% Salida:
% * K: matriz del sistema (difusión + reacción) con modificaciones luego del ensamble.
% * F: vector de flujo térmico con modificiaciones luego del ensamble.
% ----------------------------------------------------------------------
end
