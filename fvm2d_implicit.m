function [PHI,Q] = fvm2d_implicit(K,F,cells,neighb,model,dt)
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
    PHI = PHI_n = PHI_next = model.PHI_n;
    Q = fvm2d_flux(PHI, cells, neighb);
    pCp = model.rho * model.cp;
    coef = pCp/dt;
    len = length(F);
    Kinv = coef*eye(len) + K;

    for i = 1:model.maxit
      
      if i == 1000
        [K, F] = fvm2d_gen_system(K, F, neighb, cells, model.c, zeros(len));
        [F] = fvm2d_neumann(F, cells, NEU);
        [K, F] = fvm2d_robin(K, F, cells, ROB);
        [K, F] = fvm2d_dirichlet(K, F, cells, DIR);
      endif
      
      PHI_next = Kinv\(F + coef*PHI_n);
      PHI = [PHI PHI_next]
      
      i
      printf("\n");
      
      PHI_n = PHI_next;

      Q_next = fvm2d_flux(PHI_next, cells, neighb);
      Q = [Q Q_next];

      err = norm(PHI_next - PHI_n)/norm(PHI_next)
      model.tol
      if(err < model.tol)
        %disp('El metodo implicito ha completado su calculo.');
        return;
      endif;

    endfor
    %disp('El metodo implicito ha llegado su maximo iteracion.');
endfunction







