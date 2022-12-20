
clear; clc;
nodes = [16 0; 8 8; 4 4; 0 0];
M = map_coor_cuad(nodes);

% Confirmacion Problema 7.5
nodes = [12 5; 20 15; 0 15];

J = [ nodes(2, :) - nodes(1, :);
      nodes(3, :) - nodes(1, :)];

dNi = J\[-1 1 0; -1 0 1];

val = sum(nodes) /3;
xp = val(1); yp = val(2);

blerp_cartes(nodes, xp, yp);

% Problema 1

% xnode( [1 2 3], :);
nodes = [0 0; 2 0; 1 1];

% Centro de los nodos, blerp_cartes
val = sum(nodes) /3;
xp = val(1); yp = val(2);
blerp_cartes(nodes, xp, yp);

pkg load symbolic
syms s

f(s) = sym(1)-sym(sqrt(2))*s + s*s*0.5;
int(f, s, 0, sqrt(2))

% Problema 2
clear; clc
% xnode( [1 2 3 4], :);
nodes = [16 0; 8 8; 4 4; 0 0];

% Centro de los nodos, blerp_cartes
val = sum(nodes) /4;
xp = val(1); yp = val(2);
%fem2d_pstr_blerp(nodes, xp, yp);

map_coor_cuad(nodes);
% integral
pkg load symbolic
syms s
##f(s) = 2*s -1.5*s*s + s*s*s/3;
f(s) = (1+s)*(2-s);
xx = linspace(-1, 1, 20);
y = double(f(xx))
plot(xx, y)
is(s) = int(f, s)

(17/(2*sqrt(2)))*4*sqrt(2)


% Problema 3
clear; clc;

% integral
pkg load symbolic
syms s
f(s) = (1+s);
f(s) = s-s*s;
is(s) = int(f, s, -1, 1)

% Problema 4
clear; clc;
model.young = 3e7;
model.poiss = 0.3;
model.pstrs = 1;
D = fem2d_pstr_const_mat(model);

nodes = [0 1; 0 0; 2 0.5; 2 1];
th = 1;
W = map_coor_cuad(nodes);
localK = fem2d_pstr_genK(nodes,D,th);

aK = localK(5:end, 5:end);
aF = [0 0 0 -20]';
aU = aK\aF;

U = [zeros(4, 1); aU];

% Deformacion PUNTUAL DEL ELEMENTO xi = eta = ALGO
xi = eta = -1;
xi = eta = -sqrt(3)/3;
Be = gen_Be_pstr(nodes, xi, eta);
def = Be*U


% ====================[ Ejemplo 5(EJERCICIO EXAMEN.pdf) ]=======================
clear; clc;

xnode = [0 0; 1 0; 1 0.5; 0 0.5];

model.young = 2.1e11;
model.poiss = 0.3;
% tension o deformacion? h = 10 = th
model.pstrs = 1;
D = fem2d_pstr_const_mat(model);

th = 0.01;

% Elemento 1
nodes = xnode([1 2 4], :);

J1 = [ nodes(2, :) - nodes(1, :);
       nodes(3, :) - nodes(1, :)];

Be = gen_Be_pstr(nodes, 1, 1);
Ke1 = 0.5*Be'*D*Be*det(J1) *th;

% Elemento 2
nodes = xnode([2 3 4], :);

J2 = [ nodes(2, :) - nodes(1, :);
       nodes(3, :) - nodes(1, :)];

Be = gen_Be_pstr(nodes, 1, 1);
Ke2 = 0.5*Be'*D*Be*det(J2) *th;

% Expresar los Ni
N = blerp_cartes(nodes, 1, 1);
f = @(x) x - x*x;
integ = quad(f, 0, 1)

% ====================[ Ejemplo extra (Ejemplo 3.pdf) ]=======================

clear; clc;
xnode = [16 0; 8 8; 0 0];

Ni = blerp_cartes(xnode, 1, 1);

norm([xnode(2, :) - xnode(1, :)] )

f1 = @(s) s + s*s/(4*sqrt(2));
res = 0.125*quad(f1, 0, 8*sqrt(2));

f2 = @(s) sqrt(2) + s*0.125 - s*s/(32*sqrt(2));
res = quad(f2, 0, 8*sqrt(2));


% ====================[ Repaso (Elemento triangular coor cart) ]=======================

xnode = [0 0; 2 0; 1 1];

nodes = xnode;
blerp_cartes(nodes, 1, 1);

f = @(s) (1-s/sqrt(2))*(1-s/sqrt(2));
res1 = quad(f, 0, sqrt(2))

f2 = @(s) (s/sqrt(2))*(1-s/sqrt(2));
res2 = quad(f2, 0, sqrt(2))


% ====================[ Repaso (Ejemplo 3) ]=======================

clear; clc;

xnode = [16 0; 8 8; 4 4; 0 0];

map_coor_cuad(xnode);


f1 = @(x) 4*(1-x)*(2-x);
res1 = quad(f1, -1, 1)

f2 = @(x) 4*(1+x)*(2-x);
res2 = quad(f2, -1, 1)

t = sqrt(32*32*2)

a1 = 48/sqrt(2);
a2 = 16/sqrt(2);

at = a1-a2

