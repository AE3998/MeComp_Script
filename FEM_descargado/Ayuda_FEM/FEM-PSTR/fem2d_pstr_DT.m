function [Def_prom,Ten_prom,Ten_VM] = fem2d_pstr_DT(xnode,icone,model,D,U)
% Descripci?n: m?dulo para calcular las deformaciones y tensiones a partir de los
% desplazamientos calculados U. Tambi?n se calculan las tensiones de Von Misses.

% Entrada:
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de cada 
%   nodo de la malla.
% * icone: matriz de conectividad. Cada fila de la matriz indica la conectividad
%   de un elemento rectangular, comenzando por el extremo inferior izquierdo y 
%   recorriendo el elemento en sentido antihorario.
% * model: struct con todos los datos del modelo (constantes, esquema num?rico, etc.).
% * D: matriz constitutiva.
% * U: vector soluci?n (desplazamientos). Cada elemento del vector representa un 
%   valor vectorial (dos grados de libertad) asociado a cada nodo de la malla, y 
%   su posici?n dentro del vector depende de c?mo se especific? cada nodo en xnode.

% Salida:
% * Def: deformaciones. Para cada nodo de la malla se calculan los tres valores t?picos de deformaciones.
% * Ten: tensiones. Para cada nodo de la malla se calculan los tres valores t?picos de tensiones.
% * Ten_VM: tensi?n de Von Misses. Para cada nodo de la malla se calcula el valor de tensi?n de Von Misses asociado a dicho nodo.

    Def = zeros(model.nnodes,4);
    for e = 1 : model.nelem
        if (icone(e,4) == -1)
            ele = icone(e,1:3);
            ind_desp = [ele(1)*2-1 ele(1)*2 ele(2)*2-1 ele(2)*2 ele(3)*2-1 ele(3)*2];
        else
            ele = icone(e,:);
            ind_desp = [ele(1)*2-1 ele(1)*2 ele(2)*2-1 ele(2)*2 ele(3)*2-1 ele(3)*2 ele(4)*2-1 ele(4)*2];
        end
        
        nodes = xnode(ele,:);
        desp = U(ind_desp);
        if (size(nodes,1) == 3) % elemento triangular
            J = [nodes(2,1)-nodes(1,1)  nodes(2,2)-nodes(1,2);
                 nodes(3,1)-nodes(1,1)  nodes(3,2)-nodes(1,2)];
            DN = [-1 1 0;-1 0 1];
            V = inv(J)*DN;
            B = [V(1,1)     0     V(1,2)     0     V(1,3)     0   ;
                   0      V(2,1)    0      V(2,2)    0      V(2,3);
                 V(2,1)   V(1,1)  V(2,2)   V(1,2)  V(2,3)   V(1,3)];
            Def_xy = (B*desp)';
            for k=1:3
                Def(ele(k),1:3) = Def(ele(k),1:3) + Def_xy;
                Def(ele(k),4) = Def(ele(k),4) + 1;
            end
        else 
            % cuatro puntos de Gauss con peso w=1
            p = [-1 -1;
                  1 -1;
                  1  1;
                 -1  1];
            B = zeros(2,4);
            for i=1:4
                    s = p(i,1);
                    t = p(i,2);
                    DNnum = [   (-1+t)/4,( 1-t)/4,( 1+t)/4,(-1-t)/4;
                            (-1+s)/4,(-1-s)/4,( 1+s)/4,( 1-s)/4     ];
                        
                    J = DNnum*nodes;
                    V = inv(J)*DNnum;
                    B = [V(1,1)     0     V(1,2)     0     V(1,3)     0     V(1,4)     0;
                           0      V(2,1)    0      V(2,2)    0      V(2,3)    0      V(2,4);
                         V(2,1)   V(1,1)  V(2,2)   V(1,2)  V(2,3)   V(1,3)  V(2,4)   V(1,4)];
                    Def_xy = (B*desp)';
                    Def(ele(i),1:3) = Def(ele(i),1:3) + Def_xy;
                    Def(ele(i),4) = Def(ele(i),4) + 1;
            end
        end
    end
    Def_prom(:,1) = Def(:,1)./Def(:,4);
    Def_prom(:,2) = Def(:,2)./Def(:,4);
    Def_prom(:,3) = Def(:,3)./Def(:,4);
    for i = 1:model.nnodes
        Ten_prom(i,1:3) = (D*Def_prom(i,1:3)')';
    end
    Ten_VM = Ten_prom(:,1).^2 - Ten_prom(:,1).*Ten_prom(:,2) + Ten_prom(:,2).^2 ...
            + 3*(Ten_prom(:,3).^2);

end