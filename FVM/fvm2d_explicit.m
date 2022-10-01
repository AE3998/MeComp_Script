function [PHI,Q] = fvm2d_explicit(K,F,cells,neighb,model,dt)
% Descripción: módulo para resolver el sistema lineal de ecuaciones utilizando
% esquema temporal explícito.

% Entrada:
% * K: matriz del sistema (difusión + reacción)
% * F: vector de flujo térmico.
% * cells: vector de celdas.
% * neighb: matriz de vecindad.
% * model: struct con todos los datos del modelo (constantes, esquema numérico, etc.)
% * dt: paso temporal.

% Salida:
% * PHI: vector solución. Cada elemento del vector representa un valor escalar asociado
% al centroide de cada celda de la malla, y su posición dentro del vector depende de
% cómo se especificó cada celda en icone. Se devuelve un resultado por cada iteración
% del método (nit columnas).
% * Q: vector de flujo de calor. Se forma de una componente en sentido x, Qx, y una
% componente en sentido y, Qy. Se devuelve un resultado por cada iteración del
% método (2xnit columnas).
% ----------------------------------------------------------------------
    disp('Iniciando el calculo de essquema temporal explicito...')
    coef = dt/(model.rho*model.cp);
    PHI = PHI_n = PHI_next = model.PHI_n;

    Q = flux(PHI, cells, neighb;
    len = length(F);

    for i = 1:model.maxit;
      PHI_next = coef*F + (eye(len) - coef*K)*PHI_n;

      % Error relativo
      err = norm(PHI_next - PHI_n, 2)/norm(PHI_next, 2);
      PHI = [PHI, PHI_next];
      PHI_n = PHI_next;

      Q_next = fvm2d_flux(PHI_next, cells, neighb);
      Q = [Q, Q_next];

      if(err < model.tol)
        disp('Metodo explicito ha completado su calculo.');
        return;
      endif
    endfor
    disp('Metodo explicito ha llegado la maxima iteracion.');
endfunction








