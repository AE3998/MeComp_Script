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
    N = length(F);
    nt = model.maxit;
    tol = model.tol;
    p = model.rho;
    cp = model.cp;

    PHI = model.PHI_n;
    PHI_prev = model.PHI_n;
    Q = fvm2d_flux(PHI,cells,neighb);
    I = eye(N);
    A = (p*cp)/dt;
    Knew = A*I + K;
    for i = 1:nt
        Fnew = F + A*PHI_prev;
        PHI_new = Knew\Fnew;
        PHI = [PHI PHI_new];
        err = norm(PHI_new-PHI_prev)/norm(PHI_new);
        Qnew = fvm2d_flux(PHI_new,cells,neighb);
        Q = [Q Qnew];
        PHI_prev = PHI_new;
        if(err < tol)
            break;
        end
    end

end







