% Hoja de prueba entregable FVM


% Definicion de los parametros
phi_1 = phi_L = 0;

k = 0.1;
pCp = 1;
G = 10;
v = 5;

% Definicion de la malla
x0 = 0; xL = 1;
r = 1;
n = 30;

malla = genMalla(x0, xL, r, n);

[Phi, Pex, PeL] = Central_Difference()
