close all; clear all; more off;

xnode = [
  0.0000000000000000, 0.0000000000000000;
  0.0000000000000000, 0.6500000000000000;
  0.0000000000000000, 1.3000000000000000;
  0.0000000000000000, 1.5000000000000000;
  0.2000000000000000, 0.0000000000000000;
  0.2000000000000000, 0.6500000000000000;
  0.2000000000000000, 1.3000000000000000;
  0.2000000000000000, 1.5000000000000000;
  0.8500000000000000, 1.3000000000000000;
  0.8500000000000000, 1.5000000000000000;
  1.5000000000000000, 1.3000000000000000;
  1.5000000000000000, 1.5000000000000000;
];

icone = [
       1,      5,      6,      2;
       2,      6,      7,      3;
       3,      7,      4,     -1;
       7,      8,      4,     -1;
       7,      9,     10,      8;
       9,     11,     12,     10;
];

Fixnodes = [
       7,      1, -0.1000000000000000;
       7,      2, 0.1000000000000000;
       9,      1, -0.1000000000000000;
       9,      2, 0.1000000000000000;
      11,      1, -0.1000000000000000;
      11,      2, 0.1000000000000000;
];

Sideload = [
       1,      5, 0.0500000000000000, 0.1200000000000000;
       2,      1, -2.0000000000000000, 8.0000000000000000;
       3,      2, -2.0000000000000000, 8.0000000000000000;
       4,      3, -2.0000000000000000, 8.0000000000000000;
       5,      6, 0.0000000000000000, -1.0000000000000000;
       6,      7, 0.0000000000000000, -1.0000000000000000;
       8,      4, 5.0000000000000000, 3.0000000000000000;
      10,      8, 5.0000000000000000, 3.0000000000000000;
      11,     12, -3.0000000000000000, 0.0000000000000000;
      12,     10, 5.0000000000000000, 3.0000000000000000;
];

Pointload = [
];

disp('---------------------------------------------------------------');
disp('Inicializando modelo de datos...');

model.nnodes = size(xnode,1);
model.nelem = size(icone,1);

model.young = 3000000.0000000000000000;
model.poiss = 25000.0000000000000000;
model.gravity = 9.8100000000000005;
model.pstrs = 1;
model.thick = 1.0000000000000000;

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
