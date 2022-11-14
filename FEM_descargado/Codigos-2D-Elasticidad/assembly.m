function [eG] = assembly(eG,eL,ele)
    NNod = length(ele);
    indx = [];
    for i=1:NNod 
        indx = [indx ele(i)*2-1 ele(i)*2];
    end
    if (size(eG,2) == 1) % Assembly of vector
        eG(indx) = eG(indx) + eL;
    else % Assembly of matrix
        eG(indx,indx) = eG(indx,indx) + eL;
    end
end