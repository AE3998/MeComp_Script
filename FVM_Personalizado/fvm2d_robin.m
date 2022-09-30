function [K,F] = fvm2d_robin(K,F,cells,ROB)
% Descripción: módulo para calcular y ensamblar las contribuciones de
% nodos pertenecientes a fronteras de tipo Robin.

% Entrada:
% * K: matriz del sistema (difusión + reacción)
% * F: vector de flujo térmico.
% * cells: vector de celdas.
% * ROB: matriz con la información sobre la frontera de tipo Robin.
%     - Columna 1: índice de la celda donde se aplica la condición de borde.
%     - Columna 2: valor de coeficiente de calor (h)
%     - Columna 3: valor de temperatura de referencia (phi_inf).
%     - Columna 4: dirección y sentido del flujo:
%         1) Flujo en dirección eje-y, sentido negativo (S  1�71ￄ1�77 South  1�71ￄ1�77 Sur)
%         2) Flujo en dirección eje-x, sentido positivo (E  1�71ￄ1�77 East  1�71ￄ1�77 Este)
%         3) Flujo en dirección eje-y, sentido positivo (N  1�71ￄ1�77 North  1�71ￄ1�77 Norte)
%         4) Flujo en dirección eje-x, sentido negativo (W  1�71ￄ1�77 West  1�71ￄ1�77 Oeste)
  for j = 1:length(ROB(:, 1))

    P = ROB(j, 1);

    ki = [cells(P).ks, cells(P).ke, cells(P).kn, cells(P).kw];
    di = [cells(P).ds, cells(P).de, cells(P).dn, cells(P).dw];
    ai = [cells(P).as, cells(P).ae, cells(P).an, cells(P).aw];

    % Coeficiente a y b de la funcion lineal D_phi
    h = ROB(j, 2); % Coeficiente de calor
    i = ROB(j, 4); % Indice vecino
    coef = h/(ki(i)+h*di(i)); % h/k-hd

    % a = 2hPhi_inf/k-hd
    a = ROB(j, 3)*coef;

    % b = -h/k-hd
    b = -coef;

    kA = ki(i)*ai(i);
    K(P, P) -= kA*b;
    F(P) += kA*a;
  endfor
% Salida:
% * K: matriz del sistema (difusión + reacción) con modificaciones luego
% de aplicar la condición de borde.
% * F: vector de flujo térmico con modificaciones luego de aplicar la
% condición de borde.
% ----------------------------------------------------------------------
end
