function [K,F] = fvm2d_robin(K,F,cells,ROB)
% Descripci贸n: m贸dulo para calcular y ensamblar las contribuciones de
% nodos pertenecientes a fronteras de tipo Robin.

% Entrada:
% * K: matriz del sistema (difusi贸n + reacci贸n)
% * F: vector de flujo t茅rmico.
% * cells: vector de celdas.
% * ROB: matriz con la informaci贸n sobre la frontera de tipo Robin.
%     - Columna 1: 铆ndice de la celda donde se aplica la condici贸n de borde.
%     - Columna 2: valor de coeficiente de calor (h)
%     - Columna 3: valor de temperatura de referencia (phi_inf).
%     - Columna 4: direcci贸n y sentido del flujo:
%         1) Flujo en direcci贸n eje-y, sentido negativo (S 鈥� South 鈥� Sur)
%         2) Flujo en direcci贸n eje-x, sentido positivo (E 鈥� East 鈥� Este)
%         3) Flujo en direcci贸n eje-y, sentido positivo (N 鈥� North 鈥� Norte)
%         4) Flujo en direcci贸n eje-x, sentido negativo (W 鈥� West 鈥� Oeste)
  for P = ROB(:, 1)'
    ki = [cell(P).ks, cell(P).ke, cell(P).kn, cell(P).kw];
    % Distancia a la cara, que puede ser negativo?
    di = [cell(P).ds, cell(P).de, cell(P).dn, cell(P).dw];
    ai = [cell(P).as, cell(P).ae, cell(P).an, cell(P).aw];

    % Coeficiente a y b de la funcion lineal D_phi
    h = ROB(P, 2); % Coeficiente de calor
    i = ROB(P, 4); % Indice vecino
    coef = h/(ki(i)-h*di(i)); % h/k-hd

    % a = 2hPhi_inf/k-hd
    a = 2*ROB(P, 3)*coef;

    % b = -h/k-hd
    b = -coef;

    kA = ki(i)*ai(i);
    K(P, P) += -kA*b;
    F(P) += kA*a;
  endfor
% Salida:
% * K: matriz del sistema (difusi贸n + reacci贸n) con modificaciones luego
% de aplicar la condici贸n de borde.
% * F: vector de flujo t茅rmico con modificaciones luego de aplicar la
% condici贸n de borde.
% ----------------------------------------------------------------------
end
