function [dt] = fem2d_heat_explicit_delta_t(xnode,icone,model)
% Descripción: módulo para calcular el paso temporal crítico para esquema 
% temporal explícito a partir de las constantes del modelo y las dimensiones
% de los elementos de la malla.

% Entrada:
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de 
%   cada nodo de la malla.
% * icone: matriz de conectividad. Indica los 3 ó 4 nodos que integran el 
%   elemento, recorridos en cualquier orden pero en sentido antihorario. 
%   En caso de elementos triangulares, la cuarta columna siempre es -1.
% * model: struct con todos los datos del modelo (constantes, esquema numérico, etc.)

% Salida:
% * dt: paso temporal crítico para método explícito.

    alpha = mean(model.kx,model.ky)/(model.rho*model.cp);

    delta = [];
    
    for e = 1 : model.nelem
        if icone(e,4) == -1
            ele = icone(e,1:3);
            d1 = norm(xnode(ele(1),:)-xnode(ele(2),:),2);
            d2 = norm(xnode(ele(2),:)-xnode(ele(3),:),2);
            d3 = norm(xnode(ele(3),:)-xnode(ele(1),:),2);
            % promedio de los 3 lados dividido 2
            delta = [delta (d1+d2+d3)/6];
        else
            ele = icone(e,:);
            d1 = norm(xnode(ele(1),:)-xnode(ele(2),:),2);
            d2 = norm(xnode(ele(2),:)-xnode(ele(3),:),2);
            d3 = norm(xnode(ele(3),:)-xnode(ele(4),:),2);
            d4 = norm(xnode(ele(4),:)-xnode(ele(1),:),2);
            % promedio de los 4 lados dividido 2
            delta = [delta (d1+d2+d3+d4)/8];
        end
    end
    dx = min(delta);
    dt = 0.5*dx^2/(2*alpha);
    
end

