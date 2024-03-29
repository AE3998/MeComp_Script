function [PHI_vec,Q_vec] = fem2d_heat_implicit(K,C,F,xnode,icone,model,dt)
% Descripción: módulo para resolver el sistema lineal de ecuaciones utilizando
% esquema temporal implícito.

% Entrada:
% * K: matriz del sistema (difusión + reacción).
% * C: matriz de masa del sistema (sin escalar por la constante de reacción).
% * F: vector de flujo térmico.
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de
%   cada nodo de la malla.
% * icone: matriz de conectividad. Indica los 3 ó 4 nodos que integran el
%   elemento, recorridos en cualquier orden pero en sentido antihorario.
%   En caso de elementos triangulares, la cuarta columna siempre es -1.
% * model: struct con todos los datos del modelo (constantes, esquema numérico, etc.)
% * dt: paso temporal arbitrario para método implícito.

% Salida:
% * PHI: matriz solución. Cada elemento del vector representa un valor
%   escalar asociado a cada nodo de la malla, y su posición dentro del vector
%   depende de cómo se especificó cada nodo en xnode. Cada columna representa
%   una iteración del esquema temporal (en total nit columnas).
% * Q: matriz de flujo de calor. Para cada nodo se halla un vector bidimensional
%   de flujo de calor, representado por un par (Qx,Qy). Cada par de columnas
%   representa una iteración del esquema temporal (en total 2×nit columnas).
% ----------------------------------------------------------------------
    PHI_vec = PHI_now = PHI_next = model.PHI_n;
    [Q_vec] = fem2d_heat_flux(xnode,icone,model,PHI_now);

    alpha = (model.rho*model.cp)/dt;
    aK = C*alpha + K;
    for i = 1:model.maxit
      aF = F + alpha*C*PHI_now;
      PHI_next = aK\aF;

      err = norm(PHI_next - PHI_now, 2)/norm(PHI_next, 2);
      % Actualizar
      PHI_now = PHI_next;
      PHI_vec = [PHI_vec PHI_next];
      Q = fem2d_heat_flux(xnode,icone,model,PHI_next);
      Q_vec = [Q_vec, Q];

      if err < model.tol
          disp(cstrcat("Metodo implicito terminado por tolerancia de error en ", ...
                num2str(i), " pasos. "));
          return;
      endif
    endfor
    disp("Metodo ha llegado su maxima iteracion.");

endfunction
