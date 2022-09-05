rho_Cp = 2;
clear;
clc;

k = 2;
c = 2;
G = 75;

% Definir la frotera de x, cantidad de nodos y 
% el paso delta X.
x = [0 1];
n = 6;
dX = (x(2)-x(1))/(n-1);

h = 2;
Tinf = 10;
%CB



%a. 
xs = linspace(x(1), x(2), n);

%Crear la matriz K
row = [[1:n] [2:n] [1:n-1]];
col = [[1:n] [1:n-1] [2:n]];
val = [-2*ones(1,n),ones(1,n-1),ones(1,n-1)];

K = sparse(row, col, val);

% Definir el vector phi
phi = zeros(n, 1);

% Armar la f
f = G * ones(n, 1);

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



