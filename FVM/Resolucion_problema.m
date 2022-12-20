%===========================[ Problema parcial 1]===============================
clear; clc;

k = 205;
T = 40;
q = 100;
h = 100; pinf = 50;
pCp = 2700*900;

d = 0.5*tan(pi/6);

a_rob = (h*pinf)/(k+h*d);
b_rob = -h/(k+h*d);

c_rob = (h*pinf*d)/(k+h*d);
d_rob = k/(k+h*d);

Phi_p = (k*T/d - q - a_rob)/(k/d + b_rob)

% Temperatura de los bordes

% Neumann
Phi_neu = Phi_p - d*q/k
% Robin
Phi_rob = c_rob + d_rob*Phi_p

% Esquema temporal
maxit = 3600;
tol = 1e-6;
coef = 1/pCp;

F = Phi_p;
PHI_n = 10;
PHI = [10];

for i = 1:maxit
  PHI_next = coef*F + (1 - coef)*PHI_n;

  % Error relativo
  err = norm(PHI_next - PHI_n, 2)/norm(PHI_next, 2);
  PHI = [PHI, PHI_next];
  PHI_n = PHI_next;

  if(err < model.tol)
    disp(cstrcat('Metodo explicito terminado en ', num2str(i), ' pasos.'));
  endif
endfor

