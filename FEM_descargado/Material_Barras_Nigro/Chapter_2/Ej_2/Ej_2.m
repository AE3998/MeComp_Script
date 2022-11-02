% MATLAB codes for Finite Element Analysis
% problem2Structure.m
% antonio ferreira 2008

% clear memory
clear all
% p1 : structure
p1=struct();
% E; modulus of elasticity
% A: area of cross section
% L: length of bar
E = 30e6;A=1;EA=E*A; L = 90;
% generation of coordinates and connectivities
% numberElements: number of elements
p1.numberElements=3;
% generation equal spaced coordinates
p1.nodeCoordinates=linspace(0,L,p1.numberElements+1);

p1.xx=p1.nodeCoordinates;
% numberNodes: number of nodes
p1.numberNodes=size(p1.nodeCoordinates,2);
% elementNodes: connections at elements
ii=1:p1.numberElements;
p1.elementNodes(:,1)=ii;
p1.elementNodes(:,2)=ii+1;
% GDof: total degrees of freedom
p1.GDof=p1.numberNodes;
%
 % numberElements: number of Elements
%
 p1.numberElements=size(p1.elementNodes,1);
%
%
 % numberNodes: number of nodes
%
 p1.numberNodes=4;
% for structure:
% displacements: displacement vector
% force : force vector
% stiffness: stiffness matrix
p1.displacements=zeros(p1.GDof,1);
p1.force=zeros(p1.GDof,1);
p1.stiffness=zeros(p1.GDof);
% applied load at node 2
p1.force(2)=3000.0;
% computation of the system stiffness matrix
for e=1:p1.numberElements;
% elementDof: element degrees of freedom (Dof)
elementDof=p1.elementNodes(e,:) ;
nn=length(elementDof);
length_element=p1.nodeCoordinates(elementDof(2))...
-p1.nodeCoordinates(elementDof(1));
detJacobian=length_element/2;invJacobian=1/detJacobian;
% central Gauss point (xi=0, weight W=2)
shapeL2=shapeFunctionL2Structure(0.0);
Xderivatives=shapeL2.naturalDerivatives*invJacobian;
% B matrix
B=zeros(1,nn); B(1:nn) = Xderivatives(:);
p1.stiffness(elementDof,elementDof)=...
p1.stiffness(elementDof,elementDof)+B'*B*2*detJacobian*EA;
end
% prescribed dofs
p1.prescribedDof=find(p1.xx==min(p1.nodeCoordinates(:)) ...
| p1.xx==max(p1.nodeCoordinates(:)))';
% solution
p1.displacements=solutionStructure(p1)
% output displacements/reactions
outputDisplacementsReactionsStructure(p1)

