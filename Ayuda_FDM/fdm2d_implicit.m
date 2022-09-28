function [PHI_vec, Q_vec] = fdm2d_implicit(K,F,xnode,neighb,model,dt)
    
    for n = 1 : model.maxit
        
        % Error relativo entre las últimas dos iteraciones
        err = norm(PHI-PHI_n,2)/norm(PHI,2);

        
        if err < model.tol
          disp('Método terminado por tolerancia de error.');
          return;
        end
    end

    disp('Método terminado por límite de iteraciones.');
end