function [F] = fvm2d_neumann(F,cells,NEU)
% Descripción: módulo para calcular y ensamblar las contribuciones de
% celdas con caras pertenecientes a fronteras de tipo Neumann.

% Entrada:
% * F: vector de flujo térmico.
% * cells: vector de celdas.
% * NEU: matriz con la información sobre la frontera de tipo Neumann.
%     - Columna 1: índice de la celda donde se aplica la condición de borde.
%     - Columna 2: valor de flujo térmico (q) asociado al lado del elemento.
%     - Columna 3: dirección y sentido del flujo:
%         1) Flujo en dirección eje-y, sentido negativo (S  1�71ￄ1�77 South - Sur)
%         2) Flujo en dirección eje-x, sentido positivo (E  1�71ￄ1�77 East - Este)
%         3) Flujo en dirección eje-y, sentido positivo (N  1�71ￄ1�77 North  1�71ￄ1�77 Norte)
%         4) Flujo en dirección eje-x, sentido negativo (W  1�71ￄ1�77 West  1�71ￄ1�77 Oeste)
  for i = 1:length(NEU(:, 1))

    P = NEU(i, 1);
    % Cara en que se trabaja
    ai = [cells(P).as, cells(P).ae, cells(P).an, cells(P).aw];

    % Celda en que se trabaja
    F(P) -= NEU(i, 2)*ai(NEU(i, 3));
  endfor
% Salida:
% * F: vector de flujo térmico con modificaciones luego de aplicar la
% condición de borde.
% ----------------------------------------------------------------------
end
