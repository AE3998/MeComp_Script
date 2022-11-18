clear all; clc;
xnode = [NaN, NaN];


% ===============================[Problema 0]=================================
####% Barra con su par de nodos (indice global)
##icone = [1 2;
##         2 3;
##         2 4];
##
##% Fuerzas externas [indice, valor] <- (-) (+) ->
##F_ex = [2 10];
##
##% Es importante definir uno por uno ya que se puede equivocar los valores
##% y se falla todo el sistema.
##
##% L = longitud de cada barra en [m]
##% E = Poisson (creo) en         [Pa/m^2]
##% A = area de cada barra en     [m^2]
##
####L = [0.7, 0.7, 0.7];
####E = [20e9, 20e9, 10e9];
####A = [6e-4, 6e-4, 12e-4];
####ke = (E.*A)./L;
##
##ke = ones(1, 3);
##
##% nudos empotrados (indice global)
##nudo_empot = [1 3 4];
##
##xnode = [0 1 2 2];
##
##[ui, Ri] = Barra_1D(icone, F_ex, ke, nudo_empot);

% ===============================[Problema 1]=================================
##
##% Barra con su par de nodos (indice global)
icone = [1 2;
         2 3;
         3 4];

% Fuerzas externas [indice, valor] <- (-) (+) ->
F_ex = [2 13500];

% Es importante definir uno por uno ya que se puede equivocar los valores
% y se falla todo el sistema.

% L = longitud de cada barra en [m]
% E = Poisson (creo) en         [Pa/m^2]
% A = area de cada barra en     [m^2]

L = [0.7, 0.7, 0.7];
E = [20e9, 20e9, 10e9];
A = [6e-4, 6e-4, 12e-4];
ke = (E.*A)./L;

% nudos empotrados (indice global)
nudo_empot = [1 4];

xnode = [0 0.7 1.4 2.1];

% ===============================[Problema 3]=================================

% Barra con su par de nodos (indice global)
##icone = [1 2;
##         2 3];
##
##% Fuerzas externas [indice, valor] <- (-) (+) ->
##F_ex = [3 -40e3];
##
##% Es importante definir uno por uno ya que se puede equivocar los valores
##% y se falla todo el sistema.
##
##% L = longitud de cada barra en [m]
##% E = Poisson (creo) en         [Pa/m^2]
##% A = area de cada barra en     [m^2]
##
##L = [1, 1];
##E = [200e9, 70e9];
##A = [4e-4, 2e-4];
##ke = (E.*A)./L;
##
##% nudos empotrados (indice global)
##nudo_empot = [1];
##
##xnode = [0 1 2];

% =======================[Solucion del sistema]=========================

% Parametro para calcular la tension por barra
ke = (E.*A)./L;
ce = E./L;

[ui, Ri] = Barra_1D(icone, F_ex, ke, nudo_empot);

te = tens_Barra_1D(icone, ce, ui);

disp("Los desplazamientos ui son: ");
full(ui)
disp("Las fuerzas externas de reaccion Ri son: ");
full(Ri)
disp("Tension de cada barra Ti son: ");
full(te')


% ================================[Grafica]==================================
  % Escala de desplazamiento, para representar mejor la diferencia entre los puntos
  esc = 100;
  graf_Barra_1D(icone, xnode, ui, esc);




