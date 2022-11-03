% Las condiciones del borde, el ultimo parametro indica la frontera:
% 0 => Izquierda , 1 => Derecha.

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
##
##Phi = FEM_1D(xnode,qu,k,c,G, DIR, NEU, ROB);
##
##
##if qu
##  xnode = linspace(x0, xl, 2*n-1);
##endif
##
##Tx = -25*xnode.*xnode + 65*xnode + 10;

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
##
##Phi = FEM_1D(xnode,qu,k,c,G, DIR, NEU, ROB);
##
##
##if qu
##  xnode = linspace(x0, xl, 2*n-1);
##endif
##
##Tx = (100*exp(-xnode).*(exp(2*xnode) + exp(4)))/(1 + exp(4));

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

Phi = FEM_1D(xnode,qu,k,c,G, DIR, NEU, ROB);


if qu
  xnode = linspace(x0, xl, 2*n-1);
endif

Tx = (100*exp(-xnode).*(exp(2*xnode) + exp(4)))/(1 + exp(4));


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
##
##Phi = FEM_1D(xnode,qu,k,c,G, DIR, NEU, ROB);
##
##
##if qu
##  xnode = linspace(x0, xl, 2*n-1);
##endif
##
##Tx = -36.6897*exp(-xnode) - 3.3103*exp(xnode) + 50;




% ===============================[ Grafica ]====================================
plot(xnode, Tx);
hold on;
plot(xnode, Phi);
title(cstrcat("Puntos n = ", num2str(n)));
legend("analitica", "Phi", 'location', 'northwest');


