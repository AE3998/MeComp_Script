%................................................................
% MATLAB codes for Finite Element Analysis
% problem3.m
% ref: D. Logan, A first couse in the finite element method,
% third Edition, page 121, exercise P3-10
%
% MATLAB codes for Finite Element Analysis
% problem3Structure.m
% antonio ferreira 2008

% clear memory
clear all
% p1 : structure
p1=struct();
% E; modulus of elasticity
% A: area of cross section
% L: length of bar
% k: spring stiffness
E=70000;A=200;k=2000;
% generation of coordinates and connectivities
% numberElements: number of elements
p1.numberElements=3;
p1.numberNodes=4;
p1.elementNodes=[1 2; 2 3; 3 4];
p1.nodeCoordinates=[0 2000 4000 4000];
p1.xx=p1.nodeCoordinates;
% GDof: total degrees of freedom
p1.GDof=p1.numberNodes;
% for structure:
% displacements: displacement vector
% force : force vector
% stiffness: stiffness matrix
p1.displacements=zeros(p1.GDof,1);
p1.force=zeros(p1.GDof,1);
p1.stiffness=zeros(p1.GDof);
% applied load at node 2
p1.force(2)=8000.0;
% computation of the system stiffness matrix
for e=1:p1.numberElements;
% elementDof: element degrees of freedom (Dof)
elementDof=p1.elementNodes(e,:) ;
L=p1.nodeCoordinates(elementDof(2))-...
p1.nodeCoordinates(elementDof(1));
if e<3
ea(e)=E*A/L;
else
ea(e)=k;
end
p1.stiffness(elementDof,elementDof)=...
p1.stiffness(elementDof,elementDof)+ea(e)*[1 -1;-1 1];
end
% prescribed dofs
p1.prescribedDof=[1;4];
% solution
p1.displacements=solutionStructure(p1)
% output displacements/reactions
outputDisplacementsReactionsStructure(p1)

