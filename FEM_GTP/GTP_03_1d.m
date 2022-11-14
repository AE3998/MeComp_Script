clear; clc;
pkg load symbolic;
syms x

% 1. d.
% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
x0 = sym(0); xl = sym(1); n = 8;

% Nodo equiespaciado
xn = linspace(x0, xl, n);

% Distancia entre cada nodo
he = xn(2:end)-xn(1:end-1);

disp("Ensamblando la matriz Klm...");
K = sym(zeros(n));
% Ensamble de Klm
for i = 1:n-1
  h = he(i);
  x1 = xn(i);
  x2 = xn(i+1);

  K11 = ( 1 + x2*x2 - int(2*x2*x - x*x , x1, x2)/h)/h;
  K12 = (-1 - x2*x1 + int((x1+x2)*x - x*x, x1, x2)/h)/h;
  K22 = ( 1 + x1*x1 - int(2*x1*x - x*x , x1, x2)/h)/h;

  aK = [K11, K12; K12, K22];
  K([i, i+1], [i, i+1]) += aK;

endfor
% Agregar los terminos de las frontera

% Robin = Nl*Nm/5 (x = 1)
K(end, end) += sym(2)/10;

% Dirichlet
K(1, 1) = 1;
K(1, 2:end) = 0;

% Ensamble de Fl
disp("Ensamblando el vector Fl...");
F = sym(zeros(n, 1));

for i = 1:n-1
  F([i, i+1]) += 25*he(i);
endfor
% Fronteras Dirichlt y  Robin Nl*10 (x = 1)
F(end) += 10;
F(1) = 10;

disp("Rsolucion del sistema...");
Phi = K\F;
Phi = double(Phi);

% Solucion analitica
xn = double(xn);
Tx = -36.6897*exp(-xn) - 3.3103*exp(xn) + 50;

disp("Proceso terminado con exito!");
%Grafica
plot(xn, Tx);
hold on;
plot(xn, Phi);
title(cstrcat("Puntos n = ", num2str(n)));
legend("analitica", "Phi", 'location', 'northwest');


