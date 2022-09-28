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
%         1) Flujo en direcci贸n eje-y, sentido negativo (S 鈥�1锟�7 South 鈥�1锟�7 Sur)
%         2) Flujo en direcci贸n eje-x, sentido positivo (E 鈥�1锟�7 East 鈥�1锟�7 Este)
%         3) Flujo en direcci贸n eje-y, sentido positivo (N 鈥�1锟�7 North 鈥�1锟�7 Norte)
%         4) Flujo en direcci贸n eje-x, sentido negativo (W 鈥�1锟�7 West 鈥�1锟�7 Oeste)
  for j = 1:length(ROB(:, 1))

    P = ROB(j, 1);

    ki = [cells(P).ks, cells(P).ke, cells(P).kn, cells(P).kw];
    di = [cells(P).ds, cells(P).de, cells(P).dn, cells(P).dw];
    ai = [cells(P).as, cells(P).ae, cells(P).an, cells(P).aw];

    % Coeficiente a y b de la funcion lineal D_phi
    h = ROB(j, 2); % Coeficiente de calor
    i = ROB(j, 4); % Indice vecino
    coef = h/(ki(i)-h*di(i)); % h/k-hd

    % a = 2hPhi_inf/k-hd
    a = 2*ROB(j, 3)*coef;

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
