clear; clc;
% p1 : structure
% E; modulus of elasticity
% A: area of cross section
% L: length of bar

E = 30e6;
A = 1;
EA = E*A;
L = 90;

n_elemnt = 3;
% generation equal spaced coordinates
xnode = linspace(0,L,n_elemnt+1);

% numberNodes: number of nodes
node_len = length(xnode);

% e_node: connections at elements
e_node = [1:node_len; 2:node_len+1]';

% GDof: total degrees of freedom
GDof = node_len;


## numberNodes=4;
% for structure:
% displacements: displacement vector
% force : force vector
% stiffness: stiffness matrix
displacements = zeros(GDof,1);
force         = zeros(GDof,1);
stiffness     = zeros(GDof);

% applied load at node 2
force(2)=3000.0;

% computation of the system stiffness matrix
for e=1:n_elemnt;
    % elementDof: element degrees of freedom (Dof)
    elementDof = e_node(e,:) ;

    nn=length(elementDof); %whyyyyyyy?? para que?? si ya sabes que son siempre 2??

    he = xnode(elementDof(2)) - xnode(elementDof(1));
    detJ = he/2;
    invJ = 1/detJacobian;

    % central Gauss point (xi=0, weight W=2)
      shape = [1; 1]*0.5;
      naturalDerivatives = [-1; 1]*0.5;

    Xderivatives = naturalDerivatives*invJ;

    % B matrix
    B = zeros(1,nn);
    B(1:nn) = Xderivatives(:);
    stiffness(elementDof,elementDof) += B'*B*2*detJacobian*EA;
end

% ============= [Falta arreglar lo que estan abajo bruh]
% prescribed dofs
prescribedDof = [min(xnode), max(xnode)];

% solution
displacements=solutionStructure(p1)

    activeDof=setdiff([1:GDof]', [prescribedDof]);
    U=stiffness(activeDof,activeDof)\force(activeDof);
    displacements=zeros(GDof,1);
    displacements(activeDof)=U;

% output displacements/reactions
outputDisplacementsReactionsStructure(p1)
    % output of displacements and reactions in
    % tabular form
    % GDof: total number of degrees of freedom of
    % the problem
    % displacements
    disp('Displacements')
    jj=1:p.GDof; format
    [jj' p.displacements]
    % reactions
    F=p.stiffness*p.displacements;
    reactions=F(p.prescribedDof);
    disp('reactions')
    [p.prescribedDof reactions]
