% Hoja de prueba entregable FVM
clear
clc

% Definicion de los parametros
phi_1 = phi_L = 0;

k = 0.1;
pCp = 1;
G = 10;
v = 5;

% Definicion de la malla
x0 = 0; xL = 1;
r = 1;
n = 40;

malla = genMalla(x0, xL, r, n);

[Phi, Pex, PeL, K] = Central_Difference(malla, phi_1, phi_L, k, pCp, G, v);

Dx = malla(2:end)-malla(1:end-1);
xp = malla(1:end-1) + Dx/2;
x = [x0, xp, xL];

% Plots
##plot(x, 1, 'ro-');
##grid on;
##hold on;
vk = v/k;
sol = G/v*(x - (1-exp(vk*x))/(1-exp(vk)));

plot(x, Phi);
hold on;
plot(x, sol);

