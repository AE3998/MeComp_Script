function [F] = fvm2d_neumann(F,cells,NEU)
% Descripci贸n: m贸dulo para calcular y ensamblar las contribuciones de
% celdas con caras pertenecientes a fronteras de tipo Neumann.

% Entrada:
% * F: vector de flujo t茅rmico.
% * cells: vector de celdas.
% * NEU: matriz con la informaci贸n sobre la frontera de tipo Neumann.
%     - Columna 1: 铆ndice de la celda donde se aplica la condici贸n de borde.
%     - Columna 2: valor de flujo t茅rmico (q) asociado al lado del elemento.
%     - Columna 3: direcci贸n y sentido del flujo:
%         1) Flujo en direcci贸n eje-y, sentido negativo (S 鈥�1锟�7 South - Sur)
%         2) Flujo en direcci贸n eje-x, sentido positivo (E 鈥�1锟�7 East - Este)
%         3) Flujo en direcci贸n eje-y, sentido positivo (N 鈥�1锟�7 North 鈥�1锟�7 Norte)
%         4) Flujo en direcci贸n eje-x, sentido negativo (W 鈥�1锟�7 West 鈥�1锟�7 Oeste)
  for i = 1:length(NEU(:, 1))

    P = NEU(i, 1);
    % Cara en que se trabaja
    ai = [cells(P).as, cells(P).ae, cells(P).an, cells(P).aw];

    % Celda en que se trabaja
    F(P) -= NEU(i, 2)*ai(NEU(i, 3));
  endfor
% Salida:
% * F: vector de flujo t茅rmico con modificaciones luego de aplicar la
% condici贸n de borde.
% ----------------------------------------------------------------------
end
