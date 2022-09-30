close all; clear all; more off;

% El generador de malla NO se tiene en cuenta el problema del ancho de banda.
xmalla = [0, 0.3, 0.5, 0.7, 1];
ymalla = [0, 0.4, 0.6, 1];

% Generador de malla xnode y los icone
xnode = gen_xnode(xmalla, ymalla);
icone = gen_icone(xmalla, ymalla);

borde = gen_borde(xmalla, ymalla);

DIR = gen_DIR(borde, [5 10], [4 2]);
DIR = gen_DIR(xmalla, ymalla, [12 20], [1 3]);



DIR = [
       3, 20.0000000000000000, 3;
       6, 20.0000000000000000, 3;
       9, 20.0000000000000000, 3;
      12, 20.0000000000000000, 3;
];


NEU = [
       1, 5.0000000000000000, 4;
       2, 5.0000000000000000, 4;
       3, 5.0000000000000000, 4;
      10, 10.0000000000000000, 2;
      11, 10.0000000000000000, 2;
      12, 10.0000000000000000, 2;
];

ROB = [
       1, 5.0000000000000000, 15.0000000000000000, 1;
       4, 5.0000000000000000, 15.0000000000000000, 1;
       7, 5.0000000000000000, 15.0000000000000000, 1;
      10, 5.0000000000000000, 15.0000000000000000, 1;
];

disp('---------------------------------------------------------------');
disp('Inicializando modelo de datos...');

model.ncells = size(icone,1);

model.th = 1.0000000000000000;

model.k = [
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
    2.0000000000000000;
];

model.c = [
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
    8.0000000000000000;
];

model.G = [
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
    12.0000000000000000;
];

% Esquema Temporal: [0] Explícito, [1] Implícito, [X] Estacionario
model.ts = 2;

% Parámetros para esquemas temporales
model.rho = 1.0000000000000000;
model.cp = 1.0000000000000000;
model.maxit =            1;
model.tol = 1.000000e-05;

% Condición inicial
model.PHI_n = mean(DIR(:,2))*ones(model.ncells,1);

disp('Iniciando el método numérico...');

% Llamada principal al Método de Volúmenes Finitos
[PHI,Q] = fvm2d(xnode,icone,DIR,NEU,ROB,model);

disp('Finalizada la ejecución del método numérico.');

disp('---------------------------------------------------------------');
disp('Iniciando el post-procesamiento...');

% mode ---> modo de visualización:
%           [0] 2D - Con malla
%           [1] 3D - Con malla
%           [2] 2D - Con malla y centros de celda
%           [3] 3D - Con malla y centros de celda
%           [4] 2D - Sin malla
%           [5] 3D - Sin malla
% graph --> tipo de gráfica:
%           [0] Temperatura (escalar)
%           [1] Temperatura (interpolada)
%           [2] Flujo de Calor (vectorial)
%           [3] Flujo de Calor eje-x (escalar)
%           [4] Flujo de Calor eje-y (escalar)
%           [5] Magnitud de Flujo de Calor (escalar)
mode = 0;
graph = 0;
[neighb] = fvm2d_neighbors(icone);
fvm2d_graph_mesh(PHI,Q,xnode,icone,neighb,DIR,NEU,ROB,model,mode,graph);

disp('Finalizado el post-procesamiento.');
