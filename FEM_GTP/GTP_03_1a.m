% La solucion requiere el archivo FuncLineales que esta guardaado en el otro archivo

clear; clc;
x0 = 0; xl = 1; n = 6;
xnode = linspace(x0, xl, n);
sp = true;
k = 2;
G = 100;
Ti = 10; Td = 50;
T = FuncLineales(xnode,sp,k,G,Ti,Td);

an = -25*xnode.*xnode + 65*xnode + 10;

plot(xnode, T);
hold on;
plot(xnode, an);
legend("Phi", "Analitica");


