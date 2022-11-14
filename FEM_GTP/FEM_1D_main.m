% Las condiciones del borde, el ultimo parametro indica la frontera:
% 0 => Izquierda , 1 => Derecha.

rho = 0; Cp = 0;
% ===============================[ GTP_1a ]=====================================

##% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
##clear; clc;
##x0 = 0; xl = 1; n = 8;
##
##% Nodo equiespaciado
##xnode = linspace(x0, xl, n);
##
##% Parametros
##k = 2; c = 0;
##G = 100;
##qu = true;
##
##% CB
##DIR = [10 0 ; 50 1];
##NEU = [];
##ROB = [];

% ===============================[ GTP_1b ]=====================================

##% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
##clear; clc;
##x0 = 0; xl = 2; n = 8;
##
##% Nodo equiespaciado
##xnode = linspace(x0, xl, n);
##
##% Parametros
##c = k = 1;
##G = 0;
##qu = true;
##
##% CB
##DIR = [100 0];
##NEU = [0 1];
##ROB = [];

% ===============================[ GTP_1c ]=====================================

% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
clear; clc;
x0 = 1; xl = 5; n = 8;

% Nodo equiespaciado
xnode = linspace(x0, xl, n);

% Parametros
k = 1; c = 0;
G = @(x) 100*(x-3).^2;
qu = true;

% CB
DIR = [0 1];
NEU = [2 0];
ROB = [];

% ===============================[ GTP_1d ]=====================================

##% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
##clear; clc;
##x0 = 0; xl = 1; n = 8;
##
##% Nodo equiespaciado
##xnode = linspace(x0, xl, n);
##
##% Parametros
##c = k = 1;
##h = 0.2; phi_inf = 50;
##G = 50;
##qu = true;
##
##% CB
##DIR = [10 0];
##NEU = [];
##ROB = [h phi_inf 1];

% ===============================[ GTP_1e ]=====================================

##% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
##clear; clc;
##x0 = 5; xl = 10; n = 8;
##
##% Nodo equiespaciado
##xnode = linspace(x0, xl, n);
##
##% Parametros
##k = 2;
##c = 0;
##h = 2; phi_inf = 100;
##G = @(x) x.^3;
##
##rho = 1; Cp = 1;
##
##qu = true;
##
##% CB
##DIR = [50 1];
##NEU = [];
##ROB = [h phi_inf 0];

% ===============================[ GTP_1f ]=====================================

##% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
##clear; clc;
##x0 = 0; xl = 1; n = 12;
##
##% Nodo equiespaciado
####xnode = linspace(x0, xl, n);
##xnode = genMalla(x0, xl, 0.95, n-1);
##
##% Parametros
##k = 2;
##c = 2;
##h = 2; phi_inf = 10;
##G = 75;
##
##rho = 1; Cp = 2;
##
##qu = false;
##
##% CB
##DIR = [0 0];
##NEU = [];
##ROB = [h phi_inf 1];

% ===============================[ GTP_1g ]=====================================

##% Posicion de nodo inicial, final y cantidad de nodo en total (con las fronteras).
##clear; clc;
##x0 = 0; xl = 1; n = 8;
##
##% Nodo equiespaciado
##xnode = linspace(x0, xl, n);
##
##% Parametros
##k = 2;
##c = -2;
##G = 0;
##
##rho = 1; Cp = 1;
##
##qu = true;
##
##% CB
##DIR = [50 0];
##NEU = [5 1];
##ROB = [];


% ===========================[ Esquema temporal]================================
maxit = 2500;
tol = 1e-6;
dt = 0.1;

% Condicion inicial
len_init = [n, 2*n-1](qu+1);
Phi_init = mean(DIR(:, 1))*ones(len_init, 1);

% Esquema Temporal: [0] Explicito, [1] Implicito, [X] Estacionario
pmt.ts = 2;

% =============================[ Resolucion ]===================================

% Funcion de forma: [true] Cuadratica, [false] Lienal
##qu = true;

disp('Empezando a la resolucion del sistema...')
pmt.k = k;
pmt.c = c;
pmt.G = G;

pmt.rho       = rho;
pmt.Cp        = Cp;
pmt.maxit     = maxit;
pmt.tol       = tol;
pmt.dt        = dt;
pmt.Phi_init  = Phi_init;


[xn, Phi] = FEM_1D(xnode,qu,pmt, DIR, NEU, ROB);
[i, j] = size(Phi);

disp("Se ha completado la resolucion del sistema de ecuacion.");
disp(cstrcat("El tamanio de Phi es ", num2str(i), "x", num2str(j), "."));

% =========================[ Evaluacion puntual ]===============================

x_eval = 1.123;
Phi_eval = FEM_1D_eval(xn, Phi(:, end), qu, x_eval);

disp(cstrcat("Phi(", num2str(x_eval), ") = ", num2str(Phi_eval)));

% =========================[ Solucion analitica ]===============================

% Soluciones analiticas
% 1a
##Tx = -25*xn.*xn + 65*xn + 10;

% 1b
##Tx = (100*exp(-xn).*(exp(2*xn) + exp(4)))/(1 + exp(4));

% 1c
Tx = (-25*xn.^4 + 300*xn.^3 - 1350*xn.^2 + 1906*xn + 2345)/3;

% 1d
##Tx = -36.6897*exp(-xn) - 3.3103*exp(xn) + 50;

% 1e
##Tx = -(xn.^5)/40 + (1225*xn - 4600)/3;

% 1f
##Tx = (-1.25*exp(-xn - 1)).*(exp(xn) - 1).*(11*exp(xn) + 11 - 30*e);

% 1g
##Tx = 73.2433*sin(xn) + 50*cos(xn);


% ===============================[ Grafica ]====================================
plot(xn, Tx);
hold on;

plot(xn, Phi(:, end)); % Muestra siempre la ultima columna
plot(x_eval, Phi_eval, 'ro');

title(cstrcat("Puntos n = ", num2str(n)));
legend("Analitica", "Phi", ...
      cstrcat("Phi(", num2str(x_eval), ") = ", num2str(Phi_eval))...
      , 'location', 'northwest');




