function [K] = genK(xnode,D)
    if (size(xnode,1) == 3) % elemento triangular
        J = [xnode(2,1)-xnode(1,1)  xnode(2,2)-xnode(1,2);
             xnode(3,1)-xnode(1,1)  xnode(3,2)-xnode(1,2)];
        DN = [-1 1 0;-1 0 1];
        V = inv(J)*DN;
        B = [V(1,1)     0     V(1,2)     0     V(1,3)     0   ;
               0      V(2,1)    0      V(2,2)    0      V(2,3);
             V(2,1)   V(1,1)  V(2,2)   V(1,2)  V(2,3)   V(1,3)];
        A = 0.5;
        K = (B'*D*B)*det(J)*A;
    else
        DN = @(s,t)[(-1+t)/4,( 1-t)/4,( 1+t)/4,(-1-t)/4;
                    (-1+s)/4,(-1-s)/4,( 1+s)/4,( 1-s)/4]; 
        % cuatro puntos de Gauss con peso w=1
        p = sqrt(3)/3;
        pospg = [-p,p];
        K = zeros(8,8);
        for i=1:2
            for j=1:2
                DNnum = DN(pospg(i),pospg(j));
                J = DNnum*xnode;
                V = inv(J)*DNnum;
                B = [V(1,1)     0     V(1,2)     0     V(1,3)     0     V(1,4)     0;
                       0      V(2,1)    0      V(2,2)    0      V(2,3)    0      V(2,4);
                     V(2,1)   V(1,1)  V(2,2)   V(1,2)  V(2,3)   V(1,3)  V(2,4)   V(1,4)];
                K = K + B'*D*B*det(J);
            end
        end
    end
end