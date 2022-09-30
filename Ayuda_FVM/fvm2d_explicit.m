function [PHI_vec,Q_vec] = fvm2d_explicit(K,F,cells,neighb,model,dt)
    A = dt/(model.rho*model.cp);

    % Initialize phi solution vector.
    PHI = model.PHI_n;
    PHI_n = model.PHI_n;
    PHI_vec = PHI;
    Q_vec = zeros(model.ncells,2);

    % Identity matrix
    I = eye(model.ncells,model.ncells);
    
    for n = 1 : model.maxit
        PHI = A*F + (I - A*K)*PHI_n;

        % Error relativo entre las últimas dos iteraciones
        err = norm(PHI-PHI_n,2)/norm(PHI,2);
        
        % actualizo phi(n+1) será phi(n) para el siguiente paso
        PHI_n = PHI;
        PHI_vec = [PHI_vec PHI];
        [Q] = fvm2d_flux(PHI,cells,neighb);
        Q_vec = [Q_vec, Q];
        
        if err < model.tol
            return;
        end
    end
end
