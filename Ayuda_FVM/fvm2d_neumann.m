function [F] = fvm2d_neumann(F,cells,NEU)
    M = size(NEU,1);

    for i = 1 : M
        P = NEU(i,1);

        q = NEU(i,2);

        if NEU(i,3) == 1
            F(P) = F(P) - q*cells(P).as;
        end

        if NEU(i,3) == 2
            F(P) = F(P) - q*cells(P).ae;
        end
        
        if NEU(i,3) == 3
            F(P) = F(P) - q*cells(P).an;
        end
        
        if NEU(i,3) == 4
            F(P) = F(P) - q*cells(P).aw;
        end
    end
end
