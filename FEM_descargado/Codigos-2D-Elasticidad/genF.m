function [F] = genF(xnode,Fg)
    Fel = Fg*area_ele(xnode);
    if (size(xnode,1) == 3)
        Fy = (Fel/3);
        F = [0; -Fy; 0; -Fy; 0; -Fy];
    else
        Fy = (Fel/4);
        F = [0; -Fy; 0; -Fy; 0; -Fy; 0; -Fy];
    end
end