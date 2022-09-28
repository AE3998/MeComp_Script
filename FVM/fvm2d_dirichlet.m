function [K,F] = fvm2d_dirichlet(K,F,cells,DIR)
% Descripci贸n: m贸dulo para calcular y ensamblar las contribuciones de celdas
% pertenecientes a fronteras de tipo Dirichlet.

% Entrada:
% * K: matriz del sistema (difusi贸n + reacci贸n)
% * F: vector de flujo t茅rmico.
% * cells: vector de celdas.
% * DIR: matriz con la informaci贸n sobre la frontera de tipo Dirchlet.
%   - Columna 1: 铆ndice de la celda donde se aplica la condici贸n de borde.
%   - Columna 2: valor en la cara de la celda (escalar)
%   - Columna 3: cara a la que se aplica la condici贸n de borde:
%       1) S 鈥� South 鈥� Sur
%       2) E 鈥� East 鈥� Este
%       3) N 鈥� North 鈥� Norte
%       4) W 鈥� West 鈥� Oeste

for P = DIR(:, 1)'
  % Seguir la nomenclatura [1 2 3 4] -> [s e n w] en los parametros
  k = [cell(P).ks, cell(P).ke, cell(P).kn, cell(P).kw];
  d = [cell(P).ds, cell(P).de, cell(P).dn, cell(P).dw];
  a = [cell(P).as, cell(P).ae, cell(P).an, cell(P).aw];

  % Extraer el indice i
  i = DIR(P, 3);

  % Despejar el coeficiente que tiene la condicion del borde
  R = k(i)*a(i)/d(i);

  K(P, P) += R;
  F(P) += R*DIR(P, 2);
endfor

% Salida:
% * K: matriz del sistema (difusi贸n + reacci贸n) con modificaciones luego de
%   aplicar la condici贸n de borde.
% * F: vector de flujo t茅rmico con modificaciones luego de aplicar la condici贸n
%   de borde.
% ----------------------------------------------------------------------
end
