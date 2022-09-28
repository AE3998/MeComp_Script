function [K,F] = fdm2d_robin(K,F,xnode,neighb,ROB)
    M = size(ROB, 1);
    for n = 1 : M
        P = ROB(n, 1);
        
        % 1) para cada nodo con condicion robin sumar en la diagonal de la fila
        % P de la matriz K el valor 2*h*dist, donde dist es la distancia del
        % nodo P al nodo interior respecto a la normal.
        
        % 2) para cada nodo con condicion robin sumar en el vector F el valor
        % 2*h*phi_inf/dist.
    end
end  