function [K,F] = fem2d_pstr_gen_system(K,F,D,xnode,icone,model)
    % Matrices and vectors elementary -- assembly
    for e=1:model.nelem
        if (icone(e,4) == -1)
            elem = icone(e,1:3);
        else
            elem = icone(e,:);
        end
        nodes = xnode(elem,:);

        % Local Matrices and Vectors
        localK = fem2d_pstr_genK(nodes,D,model.thick);
        localF = fem2d_pstr_genF(nodes,model.gravity,model.thick);

        % Assembly
        indx = [];
        for i = 1 : length(elem)
            indx = [indx elem(i)*2-1 elem(i)*2];
        end

        K(indx,indx) = K(indx,indx) + localK;
        F(indx) = F(indx) + localF;

        % ============[Revision de los elementos]=============
        disp(cstrcat("Elemento ", num2str(e)," :"));
        disp("Local K:");
        full(localK)
        disp("Local F:");
        full(localF)
        disp("indices: ");
        indx
        % =================[Fin de revision]=================

    end
end

