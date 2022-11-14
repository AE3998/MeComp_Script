clear all; clc;
pos_i = [NaN, NaN];


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
##pos_i = [0 1 2 2];
##
##[ui, Ri] = Barra_1D(icone, F_ex, ke, nudo_empot);

% ===============================[Problema 1]=================================
##
####% Barra con su par de nodos (indice global)
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
##pos_i = [0 0.7 1.4 2.1];

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
##pos_i = [0 1 2];

% ===============================[Problema 4]=================================

##%Barra con su par de nodos [indice global + angulo en grado]
##icone = [2 1 270; % que pasa si pongo [2 1 90]? el angulo no sera 90 sino 270
##         1 3 45;
##         1 4 0 ];
##
##% Fuerzas externas [idx_nudo, f_x, f_y]
##F_ex = [1 0 -10e3];
##
##% Es importante definir uno por uno ya que se puede equivocar los valores
##% y se falla todo el sistema.
##
##% L = longitud de cada barra en [m]
##% E = Poisson (creo) en         [Pa = N/m^2]
##% A = area de cada barra en     [m^2]
##
##L = [10, 10*sqrt(2), 10];
##E = [30e6, 30e6, 30e6];
##A = [2, 2, 2];
##
##% nudos empotrados [idx_nudo, empot_x, empot_y]
##nudo_empot = [2 true true;
##              3 true false;
##              4 false true];
##
##% Posciones de los nudos
##pos_i = [0 0;
##         0 10;
##         10 10;
##         10 0];


% ===============================[Problema 5]=================================

%Barra con su par de nodos [indice global + angulo en grado]
icone = [1 2 90;
         1 3 0;
         2 3 135;
         2 4 0;
         1 4 45;
         3 4 90;
         3 6 45;
         4 5 135;
         4 6 0;
         3 5 0;
         5 6 90];

% Fuerzas externas [idx_nudo, f_x, f_y]
F_ex = [2 0 -50e3;
        4 0 -100e3;
        6 0 -50e3];

% Es importante definir uno por uno ya que se puede equivocar los valores
% y se falla todo el sistema.

% L = longitud de cada barra en [m]
% E = Poisson (creo) en         [Pa = N/m^2]
% A = area de cada barra en     [m^2]

diag = 3*sqrt(2);
L = [3 3 diag 3 diag 3 diag diag 3 3 3];
E = ones(1, 11) * 70e9;
A = ones(1, 11) * 3e-4;

% nudos empotrados [idx_nudo, empot_x, empot_y]
nudo_empot = [1 true true;
              5 false true];

% Posciones de los nudos
pos_i = [0 0;
         0 3;
         3 0;
         3 3;
         6 0;
         6 3];



% =======================[Solucion del sistema]=========================
##[ui, Ri] = Barra_1D(icone, F_ex, ke, nudo_empot);

% Parametro para calcular la tension por barra
ke = (E.*A)./L;
ce = E./L;

[ui, Ri] = Barra_2D(icone, F_ex, ke, nudo_empot);

te = tens_Barra_2D(icone, ce, ui);

disp("Los desplazamientos ui son: ");
full(ui)
disp("Las fuerzas externas de reaccion Ri son: ");
full(Ri)
disp("Tension de cada barra Ti son: ");
full(te')


% ================================[Grafica]==================================
  % Escala de desplazamiento, para representar mejor la diferencia entre los puntos
##  esc = 100;
##  graf_Barra_1D(icone, pos_i, ui, esc);
  esc = 10;
  graf_Barra_2D(icone, pos_i, ui, esc);



