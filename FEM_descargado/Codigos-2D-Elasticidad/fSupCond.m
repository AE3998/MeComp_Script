function [F] = fSupCond(F,fS,xnode)
    for i=1:size(cN,1)
        x=xnode(fS(i,1),:)-xnode(fS(i,2),:); % Side Coordinaates
        l = sqrt(x*transpose(x));            % Side Size
        indN1 = [fS(i,1)*2-1 fS(i,1)*2];       % Node 1 of side
        indN2 = [fS(i,2)*2-1 fS(i,2)*2];       % Node 2 of side
        indx = [indN1 indN2];                % Side Nodes
        Fx = (l*fS(i,3)/2);
        Fy = (l*fS(i,4)/2);
        force = [Fx Fy Fx Fy];
        F(indx) = F(indx) + force;     
    end
end
