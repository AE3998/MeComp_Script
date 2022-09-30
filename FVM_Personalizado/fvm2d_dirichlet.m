function [K,F] = fvm2d_dirichlet(K,F,cells,DIR)
% Descripción: módulo para calcular y ensamblar las contribuciones de celdas
% pertenecientes a fronteras de tipo Dirichlet.

% Entrada:
% * K: matriz del sistema (difusión + reacción)
% * F: vector de flujo térmico.
% * cells: vector de celdas.
% * DIR: matriz con la información sobre la frontera de tipo Dirchlet.
%   - Columna 1: índice de la celda donde se aplica la condición de borde.
%   - Columna 2: valor en la cara de la celda (escalar)
%   - Columna 3: cara a la que se aplica la condición de borde:
%       1) S  1�7 South  1�7 Sur
%       2) E  1�7 East  1�7 Este
%       3) N  1�7 North  1�7 Norte
%       4) W  1�7 West  1�7 Oeste

for P = DIR(:, 1)'
  % Seguir la nomenclatura [1 2 3 4] -> [s e n w] en los parametros
  k = [cells(P).ks, cells(P).ke, cells(P).kn, cells(P).kw];
  d = [cells(P).ds, cells(P).de, cells(P).dn, cells(P).dw];
  a = [cells(P).as, cells(P).ae, cells(P).an, cells(P).aw];

  % Extraer el indice i
  i = DIR(P, 3);

  % Despejar el coeficiente que tiene la condicion del borde
  R = k(i)*a(i)/d(i);

  K(P, P) += R;
  F(P) += R*DIR(P, 2);
endfor

% Salida:
% * K: matriz del sistema (difusión + reacción) con modificaciones luego de
%   aplicar la condición de borde.
% * F: vector de flujo térmico con modificaciones luego de aplicar la condición
%   de borde.
% ----------------------------------------------------------------------
end
