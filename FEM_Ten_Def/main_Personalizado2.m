% ====================[ Ejemplo 03 personalizado ]=======================

close all; clear all; more off; clc;


xnode = [ 0 0;
          16 0;
          14 2;
          12 4;
          10 6;
          8 8];

##xnode = [16 0; 8 8; 0 0];

% Nodos del elemento
icone = [
  1 2 3 -1;
  1 3 4 -1;
  1 4 5 -1;
  1 5 6 -1
];

##icone = [1 2 3 -1];

% Dirichlet
% Desplazamiento fijo, [nodo, direccion (1: x, 2: y), valor desplazamiento]
Fixnodes = [
  1 1 0;
  1 2 0;
  2 2 0
];


% Neumann
% Carga distribuida sobre un borde con 2 nodos,
% [nodo1, nodo2, tension_x, tension_y]
tx = ty = 3e2/sqrt(2);
Sideload = [
    2 3 tx ty;
    3 4 tx ty;
    4 5 tx ty;
    5 6 tx ty;

];

##Sideload = [
##    2 3 tx ty;
##];


% Carga puntual dentro de un elemento (incluye su borde)
% [idx_elemento, fuerza_x, fuerza_y, xp, yp]
Pointload = [1 1e5 0 16 0];

disp('---------------------------------------------------------------');
disp('Inicializando modelo de datos...');

model.nnodes = size(xnode,1);
model.nelem = size(icone,1);

model.young = 2.1e11;
model.poiss = 0.3;
% Es el parametro rho*g, supuestamente rho = 1 por defecto.
% Cuando se trata de fuerza volumnetrica, es el genF el encargado
% de generar el vector, pero el parametro Fg es la gravedad sola.
##model.gravity = 9.8100000000000005;
model.gravity = 0;
model.pstrs = 1;
model.thick = 0.01;

disp('Iniciando el método numérico...');

% Llamada principal al Método de Elementos Finitos
[U,reaction,Def,Ten,Ten_VM] = fem2d_pstr(xnode,icone,Fixnodes,Sideload,Pointload,model);

disp('Finalizada la ejecución del método numérico.');

disp('---------------------------------------------------------------');
disp('Iniciando el post-procesamiento...');

% mode ---> modo de visualización:
%           [0] 2D - Con malla
%           [1] 2D - Sin malla
% graph --> tipo de gráfica:
%           [0] Estado inicial vs. desplazamiento
%           [1] Von Misses (escalar)
%           [2] Reacciones (vectorial)
% scale --> factor de escala para U (en veces)
mode = 0;
graph = 0;
scale = 1;
U = scale * U;
fem2d_pstr_graph_mesh(U,reaction,Ten_VM,xnode,icone,mode,graph);

disp('Finalizado el post-procesamiento.');


% =============================[ PosProceso ]===================================
rU = reshape(full(U'), 2, model.nnodes);
rU = rU';

scale = 1e3;
d_xnode = xnode + scale*rU;
plot(xnode(:, 1), xnode(:, 2), 'ro');
hold on;
plot(d_xnode(:, 1), d_xnode(:, 2), 'go');
xlabel("eje x");
ylabel("eje y");



