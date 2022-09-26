% Hoja de prueba entregable FVM
clear
clc

% Definicion de los parametros

% Phi de los bordes tipo Dirichlet
phi_CB = struct(
  "phi_1", 0,
  "phi_L", 0
);
% Parametros de entradas
parametros = struct(
  "k"   , 0.1 ,
  "pCp" , 1   ,
  "G"   , 10  ,
  "v"   , 5
);

% Central difference o Upwind
CD = false;

% Definicion de la malla
x0 = 0; xL = 1;
r = 1;
n = 40;
malla = genMalla(x0, xL, r, n);

[Phi, Pex, PeL, K] = Central_Difference(malla,phi_CB, parametros, CD);

Dx = malla(2:end)-malla(1:end-1);
xp = malla(1:end-1) + Dx/2;
x = [x0, xp, xL];

% Solucion analitica
v = parametros.v;
k = parametros.k;
G = parametros.G;
vk = v/k;
sol = G/v*(x - (1-exp(vk*x))/(1-exp(vk)));

% Plots

plot(x, Phi);
hold on;
plot(x, sol, 'o');

