clear; clc;
% ===============================[Problema 4]=================================
##
##% Barra con su par de nodos [indice global + angulo en grado]
##icone = [2 1; % que pasa si pongo [2 1 90]? el angulo no sera 90 sino 270
##         1 3;
##         1 4];
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
##L = [120, 120*sqrt(2), 120];
##E = [30e6, 30e6, 30e6];
##A = [2, 2, 2];
##
##% nudos empotrados [idx_nudo, empot_x, empot_y]
##nudo_empot = [2 true true;
##              3 true true;
##              4 true true];
##
##% Posciones de los nudos
##xnode = [0 0;
##         0 10;
##         10 10;
##         10 0];


% ===============================[Problema 5]=================================
##% Posciones de los nudos [x, y]
##xnode = [0 0;
##         0 3;
##         3 0;
##         3 3;
##         6 0;
##         6 3];
##
##%Barra con su par de nodos [indice global + angulo en grado]
##icone = [1 2;
##         1 3;
##         2 3;
##         2 4;
##         1 4;
##         3 4;
##         3 6;
##         4 5;
##         4 6;
##         3 5;
##         5 6];
##
##% Fuerzas externas [idx_nudo, f_x, f_y]
##F_ex = [2 0 -50e3;
##        4 0 -100e3;
##        6 0 -50e3];
##
##% Es importante definir uno por uno ya que se puede equivocar los valores
##% y se falla todo el sistema.
##
##% L = longitud de cada barra en [m]
##% E = Poisson (creo) en         [Pa = N/m^2]
##% A = area de cada barra en     [m^2]
##
##diag = 3*sqrt(2);
##L = [3 3 diag 3 diag 3 diag diag 3 3 3];
##E = ones(1, 11) * 70e9;
##A = ones(1, 11) * 3e-4;
##
##% nudos empotrados [idx_nudo, empot_x, empot_y]
##nudo_empot = [1 true true;
##              5 false true];


% ===============================[Problema 4]=================================

% Barra con su par de nodos [indice global + angulo en grado]
icone = [1 3; % que pasa si pongo [2 1 90]? el angulo no sera 90 sino 270
         2 3];

% Fuerzas externas [idx_nudo, f_x, f_y]
P = 2300*(7.854e-5+1e-4)*9.81;
F_ex = [3 0 -P];

% Es importante definir uno por uno ya que se puede equivocar los valores
% y se falla todo el sistema.

% L = longitud de cada barra en [m]
% E = Poisson (creo) en         [Pa = N/m^2]
% A = area de cada barra en     [m^2]

At = pi*0.005*0.005;
Ac = 0.01*0.01;


L = [2 2];
E = [2.1e6 2.1e6];
A = [Ac At];

% nudos empotrados [idx_nudo, empot_x, empot_y]
nudo_empot = [1 true true;
              2 true true];


% Posciones de los nudos
xnode = [0 0;
         0 2*sqrt(2);
         sqrt(2) sqrt(2)];


aK = [93.7334   11.2666;
      11.2666   93.7334]

aF = [0 ; -P];
aU = aK\aF
% =======================[Solucion del sistema]=========================
% Parametro para calcular la tension por barra
ke = (E.*A)./L;
ce = E./L;

[ui, Ri] = Barra_2D(xnode, icone, F_ex, ke, nudo_empot);

te = tens_Barra_2D(xnode, icone, ce, ui);

disp("Los desplazamientos ui son: ");
full(ui)
disp("Las fuerzas externas de reaccion Ri son: ");
full(Ri)
disp("Tension de cada barra Ti son: ");
full(te')


% ================================[Grafica]==================================
  % Escala de desplazamiento, para representar mejor la diferencia entre los puntos
  esc = 1;
  graf_Barra_2D(icone, xnode, ui, esc);








