clear; clc;
pos_i = [NaN, NaN];
% ===============================[Problema 1]=================================

##% Barra con su par de nodos (indice global)
##icone = [1 2;
##         2 3;
##         3 4];
##
##% Fuerzas externas [indice, valor] <- (-) (+) ->
##F_ex = [2 13500];
##
##% Es importante definir uno por uno ya que se puede equivocar los valores
##% y se falla todo el sistema.
##
##% L = longitud de cada barra en [m]
##% E = Poisson (creo) en         [Pa/m^2]
##% A = area de cada barra en     [m^2]
##
##L = [0.7, 0.7, 0.7];
##E = [20e9, 20e9, 10e9];
##A = [6e-4, 6e-4, 12e-4];
##ke = (E.*A)./L;
##
##% nudos empotrados (indice global)
##nudo_empot = [1 4];
##

% ===============================[Problema 3]=================================

##% Barra con su par de nodos (indice global)
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
####Los desplazamientos ui son:
####            0
####  -5.0000e-04
####  -3.3571e-03

% ===============================[Problema 4]=================================

% Barra con su par de nodos [indice global + angulo en grado]
icone = [2 1 270; % que pasa si pongo [2 1 90]? el angulo no sera 90 sino 270
         1 3 45;
         1 4 0 ];

% Fuerzas externas [idx_nudo, valor de fuerza de x e y]
F_ex = [1 0 -10e3];

% Es importante definir uno por uno ya que se puede equivocar los valores
% y se falla todo el sistema.

% L = longitud de cada barra en [m]
% E = Poisson (creo) en         [Pa/m^2]
% A = area de cada barra en     [m^2]

L = [10, 10*sqrt(2), 10];
E = [30e6, 30e6, 30e6];
A = [2, 2, 2];
ke = (E.*A)./L;

% nudos empotrados (indice global)
nudo_empot = [2 3 4];

% Posciones de los nudos
pos_i = [0 0;
         0 10;
         10 10;
         10 0];

% =======================[Solucion del sistema]=========================
##Barra_1D(icone, F_ex, ke, nudo_empot);
[ui, Ri] = Barra_2D(icone, F_ex, ke, nudo_empot);

disp("Los desplazamientos ui son: ");
full(ui)
disp("Las fuerzas externas de reaccion Ri son: ");
full(Ri)

% ================================[Grafica]==================================
  % Escala de desplazamiento, para representar mejor la diferencia entre los puntos
  esc = 5e2;
  graf_Barra(icone, pos_i, ui, esc);



