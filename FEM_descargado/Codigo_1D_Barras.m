% Calculo Elementos de Barra 1D
% Barra1D.m
% Ejercicio 1
% Resolvemos un sistema de barras en 1D con el m�todo de elementos de barras.
% Apunte Norberto Nigro.
% Ver el Ejemplo 1 y luego plantear los ejemplos siguientes.

% Variables a Usar:
% Nele = Es un escalar que define el n�mero de barras (elementos)que tiene el
% sistema.

% E =  Modulo de elasticidad de las barras. Nota: Lo usamos asi por si tenemos
% diferentes valores en cada barra. Si todos tienen el mismo usa
% �ndices en E para definir el mismo valor n veces en un vector
% (por ejemplo: E(1:Nele) = X)
% Si algunas o todas la barras tienen diferentes valores para E, escribe
% cada uno en un vector (E = [E1 E2 E3 ...]). Luego direccionamos a ese vector

% area = Area de la seccion transversal de cada barra. Al igual que con E,
% si todas las barras tienen la misma area usa indices
% (por ejemplo: area(1:Nele) = X)
% Si algunas o todas la barras tienen diferentes valores de area, escribe
% cada uno en un vector (area = [area1 area2 area3 ...])

% xnod = Son las coordenadas X de cada nodo en las unidades que se defina en el
% problema. Es importante poner el origen en el primer nodo (mas facil)

% icone = Son los indices de los nodos que conforman a cada barra y como se rela-
% cionan entre ella. Cada barra es unida por dos nodos, por lo que si la barra 1
% comienza en 0 (nodo 1) y termina en 30 (nodo 2), la barra se define con los
% indices [1 2], y asi para cada barra.

% Desplaz = Condiciones de frontera para cada nodo (0 si el nodo
% est� empotrado y 1 si el nodo puede moverse).

% Fuerzas = Vector de fuerzas del sistema (0 si no hay una fuerza actuando
% en el nodo y un valor cualquiera si hay una fuerza. Dependiendo del
% sentido de cada fuerza, se deberia usar un signo negativo o positivo).

% L = Longitud de cada barra
% Nomenclatura de matrices
% MG Matriz global
% MGR Matriz global reducida

% limpiamos la ventana
clc; clear all; clf;

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Configuracion~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%%

% Ejemplo 1
% En este ejemplo tenemos los valores en unidades inglesas o metricas
% Fuerza en libra (lb) o Newtons (N), desplazamiento en pulgadas (in) o (mm),
% Tension en (psi) o (N/m^2)(Pa)

% UNIDADES EN SISTEMA INGLES

##Nele = 3;                             % Numero de elementos
##E = [30*10^6 30*10^6 15*10^6];        % Modulo de elasticidad por barra/elemento
##area = [1 1 2];                       % Areas de cada elemento
##xnod = [0 ; 30 ; 60 ; 90];            % Coordenadas de cada nodo
##icone = [1 2 ; 2 3 ; 3 4];            % conectividad de cada barra
##Desplaz = [0 1 1 0];                  % Desplazamientos por nodo s cond. borde
##Fuerzas = [0 3000 0 0];               % Fuerzas aplicadas por nodo
##L = [30 30 30];                       % Longitud de cada barra en un vector.

% Ejemplo 1
% UNIDADES EN SISTEMA METRICO

Nele = 3;                             % Numero de elementos
E = [20*10^9 20*10^9 10*10^9];        % Modulo de elasticidad por barra/elemento
area = [0.0006 0.0006 0.0012];        % Areas de cada elemento
xnod = [0 ; 700 ; 1400 ; 2100];       % Coordenadas de cada nodo
icone = [1 2 ; 2 3 ; 3 4];            % conectividad de cada barra
Desplaz = [0 1 1 0];                  % Desplazamientos por nodo s cond. borde
Fuerzas = [0 13500 0 0];              % Fuerzas aplicadas por nodo
L = [700 700 700];                    % Longitud de cada barra en un vector.

% Definimos las matrices de rigidez por cada barra/elemento
A = zeros(2,2,Nele);
for i = 1:Nele
    % Matrices de rigidez por elemento
    A(:,:,i) = ((E(i).*area(i))./L(i))*[1 -1 ; -1 1];
end
% Las visualizamos
format short g
% Vemos cada una de las matrices
A

% Ensamblamos las matrices de rigidez de cada elemento en la matriz global
% que denominamos MG

S = size(xnod,1);  % Cantidad de nodos.
MG=zeros(S,S);     % Matriz global vac�a
% Recorremos las barras
for i = 1:Nele
    m = icone(i,1);
    n = icone(i,2);
    % Incorporamos las matrices de cada barra en la matriz global
    MG([m n],[m n],i) = A(:,:,i);
end
MG
% Proceso de ensamble de todas las matrices (globales) de cada barra en una unica
% matriz

MG = sum(MG,3)

% Para el calculo podemos seguir un `proceso de reduccion de la matriz global

v = find(Desplaz==0); % buscamos los valores nulos donde pusimos las condiciones
                      % de contorno (fijaciones)
% Formamos la matriz reducida
MGR=MG;
MGR(v,:)=0;  % ponemos ceros en la filas relacionadas con el nodo fijado
MGR(:,v)=0;  % ponemos ceros en la columnas relacionadas con el nodo fijado

indicefil = zeros(1,S);
indicecol = zeros(1,S);

for i=1:S
    if MGR(i,:)==0
        indicefil(i)=i;
    end
    if MGR(:,i)==0
        indicecol(i)=i;
    end
end
% Eliminar filas y columnas con ceros para tener la matriz global reducida
MGR(indicefil~=0,:)=[];
MGR(:,indicecol~=0)=[]

% Eliminar filas y columnas con ceros de las fuerzas (vector del lado derecho)
% le llamamos Fuerzas a este vector

Fuerzas(indicefil~=0)=[]


% Calculamos los desplazamientos por nodo
d = MGR\Fuerzas' % los calculamos con el modelo directo de Octave

k = 1;
d2 = zeros(S,1);

% Desplazamientos calculados en el vector de desplazamientos original
for i=1:length(Desplaz)
    if Desplaz(i)==0
        d2(i,1)=0;
    else
        d2(i,1)=d(k);
        k=k+1;
    end
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~Resultados Pedidos~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Esfuerzos (tensiones)
Esfuerzos =zeros(1,Nele);
for i=1:Nele     %Calcular los esfuerzos por barra/elemento
    indice = icone(i,:);
    Esfuerzos(i)=(E(i)./L(i))*[-1 1]*[d2(indice(1,1));d2(indice(1,2))];
end

% Mostramos resultados
% vector completo con los desplazamientos
d2

% Tensiones en cada barra
Esfuerzos

% Calcular las reacciones por barra/elemento (ver teoria)
Reacciones = MG*d2

%~~~~~~~~~~~~~~~~~~~~Graficamos el dominio con resultados~~~~~~~~~~~~~~~~~~~~~~%

figure(1)
line([xnod(1) xnod(end)],[0 0],'Color','k','LineWidth',2);
hold on
plot(xnod',zeros(1,length(xnod)),'or','MarkerSize',6,'MarkerFaceColor','r');
grid on
grid minor

NodosDesp = xnod' + d2';
Nocero = find(d2~=0);
hold on

plot(NodosDesp(Nocero),zeros(1,length(Nocero)),'og','MarkerSize',6,'MarkerFaceColor','g');
axis([xnod(1)-10 xnod(end)+10 -1 1]);
title('Ejercicio Resuelto(Hacer zoom en cada nodo hasta ver el desplazamiento');

legend({'Barra';'Nodos empotrados' ; 'Nodos desplazados'});



