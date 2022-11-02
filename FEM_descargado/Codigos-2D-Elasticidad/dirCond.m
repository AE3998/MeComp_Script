function [K,F] = dirCond(K,F,dir)
    for i=1:size(dir,1)
        p = 2*dir(i,1)+dir(i,2)-2;
        K(p,:) = 0;
        K(p,p) = 1;
        F(p) = dir(i,3);
    end
end