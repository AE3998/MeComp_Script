close all; clear all; more off; clc;

% El generador de malla NO se tiene en cuenta el cuestion de ancho de banda.
xmalla = [0, 0.1, 0.3, 0.6];
ymalla = [0, 0.1, 0.2, 0.3];

% Definicion de los parametros de entrada
th = 1;
k = 100;
c = 0;
G = 0;

% Definicion de los parametros no estacionario
rho = 1;
cp = 1;
maxit = 1;
tol = 1e-05;

% Esquema Temporal: [0] Explicito, [1] Implicito, [X] Estacionario
ts = 2;
dt = 0.01;

% Definicion de los datos de CB

% Dirichlet
val_DIR = 50; dir_DIR = 4;

% Neumann
val_NEU = [100 0]; dir_NEU = [1 2];

% Robin
h_ROB = 20; Tinf_ROB = 25; dir_ROB = 3;

% mode ---> modo de visualizacion:
%           [0] 2D - Con malla
%           [1] 3D - Con malla
%           [2] 2D - Con malla y centros de celda
%           [3] 3D - Con malla y centros de celda
%           [4] 2D - Sin malla
%           [5] 3D - Sin malla
% graph --> tipo de grafica:
%           [0] Temperatura (escalar)
%           [1] Temperatura (interpolada)
%           [2] Flujo de Calor (vectorial)
%           [3] Flujo de Calor eje-x (escalar)
%           [4] Flujo de Calor eje-y (escalar)
%           [5] Magnitud de Flujo de Calor (escalar)
mode = 0;
graph = 0;

disp('---------------------------------------------------------------');
disp('Generando la malla con su condiciones del borde...');

% Generador de malla xnode, icone y los indices de borde
xnode = gen_xnode(xmalla, ymalla);
icone = gen_icone(xmalla, ymalla);
borde = gen_borde(xmalla, ymalla);

% DIR = gen_DIR(borde, val, dir);
DIR = gen_DIR(borde, val_DIR, dir_DIR);

% NEU = gen_NEU(borde, val, dir);
NEU = gen_NEU(borde, val_NEU, dir_NEU);
NEU(1, 2) = 0;

% ROB = gen_ROB(borde, h, Tinf, dir);
ROB = gen_ROB(borde, h_ROB, Tinf_ROB, dir_ROB);



disp('Asignando los datos personalizados...'); printf("\n");


disp('Finalizacion de la asignacion de malla y las condiciones del borde. ');

printf("\n\n");
disp('---------------------------------------------------------------');
disp('Inicializando modelo de datos...');

% Numero de centro de celdas
nc = (length(xmalla)-1)*(length(ymalla)-1);

model.ncells = size(icone,1);
model.th = th;

model.k = ones(nc, 1)*k;
model.k(1:3) = 0.001;

model.c = ones(nc, 1)*c;
model.G = ones(nc, 1)*G;

% Esquema Temporal: [0] Explicito, [1] Implicito, [X] Estacionario
model.ts = ts;
model.dt = dt;

% Parametros para esquemas temporales
model.rho = rho;
model.cp = cp;
model.maxit = maxit;
model.tol = tol;

% Condicion inicial
model.PHI_n = mean(DIR(:,2))*ones(model.ncells,1);

disp('Iniciando el metodo numerico...');

% Llamada principal al Metodo de Volumenes Finitos
[PHI,Q] = fvm2d(xnode,icone,DIR,NEU,ROB,model);

disp('Finalizada la ejecucion del metodo numerico.');

disp('---------------------------------------------------------------');
disp('Iniciando el post-procesamiento...');


[neighb] = fvm2d_neighbors(icone);
fvm2d_graph_mesh(PHI,Q,xnode,icone,neighb,DIR,NEU,ROB,model,mode,graph);

disp('Finalizado el post-procesamiento.');
