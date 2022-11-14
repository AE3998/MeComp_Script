function [PHI, Q] = fdm2d_explicit(K,F,xnode,neighb,model,dt)
% Descripción: módulo para resolver el sistema lineal de ecuaciones utilizando esquema
% temporal explícito.

% Entrada:
% * K: matriz del sistema (difusión + reacción)
% * F: vector de flujo térmico.
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de cada nodo 
% de la malla.
% * neighb: matriz de vecindad.
% * model: struct con todos los datos del modelo (constantes, esquema numérico, etc.)
% * dt: paso temporal crítico para método explícito.

% Salida:
% * PHI: matriz solución. Cada elemento del vector representa un valor escalar 
%   asociado a cada nodo de la malla, y su posición dentro del vector depende de
%   cómo se especificó cada nodo en xnode. Cada columna representa una iteración
%   del esquema temporal (en total nit columnas).
% * Q: matriz de flujo de calor. Para cada nodo se halla un vector bidimensional
%   de flujo de calor, representado por un par (Qx,Qy). Cada par de columnas 
%   representa una iteración del esquema temporal (en total 2×nit columnas).
% ----------------------------------------------------------------------
       disp('Se inicializa al calculo del modelo EXPLICITO...');
    nt = model.maxit;
    N = size(xnode,1);
    tol = model.tol;
    PHI = model.PHI_n;
    PHIn = model.PHI_n;
    Q = fdm2d_flux(PHI,neighb,xnode,model.k);
    a = dt/(model.rho*model.cp);
    I = eye(N,N);
    for i=1:nt
        PHIa = a*F + (I-a*K)*PHIn;
        err = norm(PHIa-PHIn,2)/norm(PHIa,2);
        PHIn = PHIa;
        PHI = [PHI PHIa];
        Qa = fdm2d_flux(PHIa,neighb,xnode,model.k);
        Q = [Q Qa];
        if (err < tol)
            disp('Ha completado el calculo IMPLICITO.');
            break;
        endif
        
    endfor
    disp('Llego la maxima iteracion EXPLICITO.');
endfunction