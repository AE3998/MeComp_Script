clear; clc;
% ===============================[test_Barra_3D]================================

% Posciones de los nudos [x, y]
xnode = [72 0 0;
         0 36 0;
         0 36 72;
         0 0 -48];

%Barra con su par de nodos [indice global + angulo en grado]
icone = [1 4;
         1 3;
         1 2];

% Fuerzas externas [idx_nudo, f_x, f_y, f_z]
F_ex = [1 0 -1e3 0];

% Es importante definir uno por uno ya que se puede equivocar los valores
% y se falla todo el sistema.

% L = longitud de cada barra en [m]
% E = Poisson (creo) en         [Pa = N/m^2]
% A = area de cada barra en     [m^2]

L1 = norm(xnode(4, :) - xnode(1, :));
L2 = norm(xnode(3, :) - xnode(1, :));
L3 = norm(xnode(2, :) - xnode(1, :));

L = [L1 L2 L3];
E = ones(1, 3) * 1.2e6;
A = [0.302, 0.729, 0.187];

% nudos empotrados [idx_nudo, empot_x, empot_y, empot_z]
nudo_empot = [2 true true true;
              3 true true true;
              4 true true true];


% =======================[Solucion del sistema]=========================
##[ui, Ri] = Barra_1D(icone, F_ex, ke, nudo_empot);

% Parametro para calcular la tension por barra
ke = (E.*A)./L;
ce = E./L;

[ui, Ri] = Barra_3D(xnode, icone, F_ex, ke, nudo_empot);

te = tens_Barra_3D(xnode, icone, ce, ui);

disp("Los desplazamientos ui son: ");
full(ui)
disp("Las fuerzas externas de reaccion Ri son: ");
full(Ri)
disp("Tension de cada barra Ti son: ");
full(te')


% ================================[Grafica]==================================
  % Escala de desplazamiento, para representar mejor la diferencia entre los puntos
##  esc = 100;
##  graf_Barra_1D(icone, xnode, ui, esc);
  esc = 1;
  graf_Barra_3D(icone, xnode, ui, esc);

% Suma de las fuerzas externas
##sum(Ri(1:3:10))
##sum(Ri(2:3:11))
##sum(Ri(3:3:12))







