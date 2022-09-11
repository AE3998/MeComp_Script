function [F] = fdm2d_neumann(F,xnode,neighb,NEU)
% Descripción: módulo para calcular y ensamblar las contribuciones de nodos
% pertenecientes a fronteras de tipo Neumann.

% Entrada:
% * F: vector de flujo térmico.
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de cada
%   nodo de la malla.
% * neighb: matriz de vecindad.
% * NEU: matriz con la información sobre la frontera de tipo Neumann.
%   - Columna 1: índice del nodo donde se aplica la condición de borde.
%   - Columna 2: valor de flujo térmico (q) asociado al lado del elemento.
%   - Columna 3: dirección y sentido del flujo:
%     (1) Flujo en dirección eje-y, sentido negativo (S – South - Sur)
%     (2) Flujo en dirección eje-x, sentido positivo (E – East - Este)
%     (3) Flujo en dirección eje-y, sentido positivo (N – North - Norte)
%     (4) Flujo en dirección eje-x, sentido negativo (W – West – Oeste)

# En sintecis, hay que restar 2q/dX o 2q/dY segun la normal asociado al nodo
# del borde. Se debe despejar la distancia entre el nodo P y el nodo que esta
# posicionado en la direccion opuesta de la normal.
# Por ejemplo, si la normal se apunta hacia la derecha, debo sacar la distancia
# del punto P con su vecino izquierdo.

# Despejo primero el indice del vecino. Se sabe que si la direccion de la
# normal es indice 1, tengo que buscar al neighb(3) del punto P.
# Se observa una relacion [1 2 3 4] => [3 4 1 2]. Se crea entonces un vector
# para completar el trabajo del cambio de indice:
  i_n = [3 4 1 2];
  cambio_indice = i_n(NEU(:, 3));

  indice_P = NEU(:, 1);

# Se sabe ahora cual vecino del punto P es usado para encontrar la distancia.
# Por conveniencia, introduce un ciclo for para asociar cada indice del vecino
# que corresponde al punto P.
  len_P = length(indice_P);
  indice_vecino = sparse(zeros(len_P, 1));

  for i = 1:len_P
    indice_vecino(i) = neighb(indice_P(i), cambio_indice(i));
  endfor

# En el indice_P tenemos los indices de los nodos con la condicion
# del borde, indice_vecino tiene su correspondiente vecino. Con estas dos
# informaciones junto con xnode se despeja la distancia entre nodos para
# completar el calculo.

  distXY = norm(xnode(indice_P, :) - xnode(indice_vecino, :), "rows");

# Falta restarle 2q/dX o 2q/dY al vector del flujo F que contiene al nodo del
# borde. El valor del flujo q se encuentra en la segunda columna de NEU.

  for i = i:len_P
    F(indice_P(i)) -= 2*NEU(i, 2)./distXY(i);
  endfor

# Modo extendido:

##  indice_P = NEU(:, 1);
##  len_P = length(indice_P);
##
##for i = 1:len_P
##  i_n = [3 4 1 2];
##  cambio_indice = i_n(indice_P(i));
##
##  indice_vecino = neighb(indice_P(i), cambio_indice);
##  distXY = norm(xnode(indice_P(i), :) - xnode(indice_vecino, :));
##  F(indice_P(i)) -= 2*NEU(i, 2)./distXY;
##endfor


% Salida:
% * F: vector de flujo térmico con modificaciones luego de aplicar la condición de borde.
% ----------------------------------------------------------------------
end
