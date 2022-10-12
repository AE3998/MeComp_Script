function [K,F] = fdm2d_robin(K,F,xnode,neighb,ROB)
% Descripción: módulo para calcular y ensamblar las contribuciones de nodos
% pertenecientes a fronteras de tipo Robin.

% Entrada:
% * K: matriz del sistema (difusión + reacción)
% * F: vector de flujo térmico.
% * xnode: matriz de nodos con pares (x,y) representando las coordenadas de
%   cada nodo de la malla.
% * neighb: matriz de vecindad.
% * ROB: matriz con la información sobre la frontera de tipo Robin.
%   - Columna 1: índice del nodo donde se aplica la condición de borde.
%   - Columna 2: valor de coeficiente de calor (h)
%   - Columna 3: valor de temperatura de referencia (phi_inf).
%   - Columna 4: dirección y sentido del flujo:
%     (1) Flujo en dirección eje-y, sentido negativo (S – South – Sur)
%     (2) Flujo en dirección eje-x, sentido positivo (E – East – Este)
%     (3) Flujo en dirección eje-y, sentido positivo (N – North – Norte)
%     (4) Flujo en dirección eje-x, sentido negativo (W – West – Oeste)

# La misma idea que el metodo Neumann, primero despejar los nodos vecinos del P,
# luego sacar la distancia y usarlo para consturir el componente 2h/dXY y
# sumarlo tanto en el diagonal principal a aquellos nodos que corresponden
# al nodo del borde robin, como el miembro derecho F del sistema multiplicado
# por la phi_inf.
if (size(ROB, 1) == 0)
  return;
endif

  indice_P = ROB(:, 1);
  len_P = length(indice_P);

  for i = 1:len_P
# indice del nodo vecino del nodo p en el sentido inverso de su normal.
# vecino(P(1), normal_P_modificado)
    indice_vecino = neighb(indice_P(i), [3 4 1 2](ROB(i, 4)));

# Distancia entre el nodo P con su vecino usando xnode
    distXY = norm(xnode(indice_P(i), :) -
                            xnode(indice_vecino, :));

# Sacar el coeficiente 2*h/dXY.
    coef = 2*ROB(i, 2)/distXY;

# Sumarle el coef*phi_inf al F, y el coef al K en sus posiciones correspondientes.
    K(indice_P(i), indice_P(i)) += coef;
    F(indice_P(i)) += coef*ROB(i, 3);

# Puede que sea necesario sumarle 1 al inidce vecino
#   K(indice_P(i), indice_vecino) += 1;
  endfor

% Salida:
% * K: matriz del sistema (difusión + reacción) con modificaciones luego de
%   aplicar la condición de borde.
% * F: vector de flujo térmico con modificaciones luego de aplicar la condición
%   de borde.
% ----------------------------------------------------------------------
end
