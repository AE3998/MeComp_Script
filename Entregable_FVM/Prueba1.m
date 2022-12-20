% Hoja de prueba entregable FVM
clear; clc;

% Definicion de los parametros

% Phi de los bordes tipo Dirichlet
phi_CB = struct(
  "phi_1", 10,
  "phi_L", 100
);
% Parametros de entradas
parametros = struct(
  "k"   , 0.1 ,
  "pCp" , 1   ,
  "G"   , 0  ,
  "v"   , 10 ,
  "A"   , 2
);

% True = Central difference, False = Upwind
CD = false;

% Definicion de la malla
x0 = 0; xL = 1;
r = 1;
n = 5;
malla = genMalla(x0, xL, r, n);

[Phi, Pex, PeL, K] = Central_Difference(malla,phi_CB, parametros, CD);


v = parametros.v;
k = parametros.k;
G = parametros.G;


Dx = malla(2:end)-malla(1:end-1);
xp = malla(1:end-1) + Dx/2;
x = [x0, xp, xL]';

% Plots
plot(x, Phi);
hold on;
plot(x, Phi, 'ro');
xlabel("X");
ylabel('\Phi');
##axis([0 1 0 2]);

posy = (max(Phi)+min(Phi))/2;
posx = malla(end)*0.1+malla(1)*0.9;
text(posx, posy, cstrcat("PeX = ", num2str(Pex), "\n",
                        "PeL = ", num2str(PeL), "\n"));

metodo = "Upwind";
if(CD)
  metodo = "Diferencia central";
endif
legend(metodo, 'location', 'northwest');

hold off;

Peloc = [(Dx*v)/k]'

disp("Temperaturas: "); Phi

disp("K: "); full(K)


