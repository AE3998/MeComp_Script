function [K,F] = fdm2d_gen_system(K,F,xnode,neighb,k,c,G)
    % recorrer todos los nodos de la malla para escribir el stencil de
    % la ecuacion diferencial, es decir, recorrer todas las filas de xnode
    for P = 1 : size(xnode,1)
        % 1) de la estructura neighb obtener los cuatro vecinos de cada
        % nodo P.
        S = neighb(P,1);
        
        
        % 2) obtener la distancia (a partir de la esctructura xnode) de 
        % cada nodo P hacia sus cuatro vecinos. 
        % Si es un nodo de borde (es decir que neighb es -1 en alguna de
        % sus columnas) no definir esa distncia. Luego en el stencil 
        % considerar el reemplazo del nodo ficticio tomando el stencil 
        % clasico para la derivada segunda en esa direccion.
        ds = 0; de = 0; dn = 0; dw = 0;

        if(S ~= -1)
            ds = abs(xnode(S,2) - xnode(P,2));
        end
        % (COMPLETAR LAS DISTANCIAS dn, de y dw)
        
        
        % 3) Considerando d2T/dx2 = ax*T(i+1,j)+bx*T(i,j)+cx*T(i-1,j) y
        % d2T/dy2 = ay*T(i,j+1)+by*T(i,j)i+cy*T(i,j-1), calcular los 
        % coeficientes asociados a cada nodo vecino en base a las distancias 
        % calculadas en el paso anterior y asi definir el stencil.
        if (W == -1)
            ax = 2/(de*de);
            bx = -2/(de*de);
            cx = 0;
        elseif (E == -1)
            ax = 0;
            bx = -2/(dw*dw);
            cx = 2/(dw*dw);
        else
            ax = 2/(de*(de+dw));
            bx = -2/(de*dw);
            cx = 2/(dw*(de+dw));
        end
        % (COMPLETAR LOS COEFICIENTES ay, by y cy)
        
        
        % 4) Asignar en la matriz K los correspondientes valores
        % calculados previamente. Asignar en el vector F el valor de la fuente
        % en el nodo P.
        
        
    end
end