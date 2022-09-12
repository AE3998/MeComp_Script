function [K,F] = fdm2d_gen_system(K,F,xnode,neighb,k,c,G)
% Descripción: módulo para ensamblar los términos difusivo, reactivo y fuente de
% todos los nodos de la malla, generando el stencil adecuado dependiendo de si es
% un nodo interior o de frontera.

% Entrada:
% * K: matriz del sistema (difusión + reacción)
% * F: vector de flujo térmico.
% * xnode: matriz de pares (x,y) representando cada nodo de la malla.
% * neighb: matriz de vecindad.
% * k: conductividad térmica del material. Es un vector que permite representar k(x,y).
% * c: constante de reacción del material. Es un vector que permite representar c(x,y).
% * G: fuente de calor. Es un vector que permite representar G(x,y).

# La funcion consiste en armar la matriz K teniendo en cuenta si cada nodo es
# un nodo del borde o no.

len_sis = length(G);
K = sparse(zeros(len_sis)); # No se si es necesario inicializar la matriz.

for i = 1:len_sis
  # inicializar las distancias con 0
  #ds = de = dn = dw = 0;
  dist = zeros(1, 4);

# Asignar las distancias cuando esto no es -1 en el vector dist de 4 elementos.
  for j = 1:4
    indice_vecino = neighb(i, j);
    if (indice_vecino != -1)
      dist(j) = norm( xnode(i, :) -
                      xnode(indice_vecino, :));
    endif
  endfor

  coef = -1;
# Trabajar con el eje x
# Llamo la coef para reemplazar la parte de+dw y coefY = dn+ds. Cuando uno de
# ellos vale -1 la multiplicacion vardra negativo. En ese caso segun la
# condicion Robin o Neumann los divisores
  ax = bx = cx = 0;

# Recordar que 2 es E y 4 es W, generar los coeficientes correspondientes
  if (dist(2)*dist(4) == 0)
    if (dist(2) == 0)
      cx = 2/(dist(4)*dist(4));
      bx = -cx;
    else
      ax = 2/(dist(2)*dist(2));
      bx = -ax;
    endif
  else
    coef = dist(2) + dist(4);
    ax = 2/(dist(2)*coef);
    bx = -2/(dist(2)*dist(4));
    cx = 2/(dist(4)*coef);
  endif

  ay = by = cy = 0;
# Recordar que 1 es S y 3 es N, generar los coeficientes correspondientes
  if (dist(1)*dist(3) == 0)
    if (dist(1) == 0)
      ay = 2/(dist(3)*dist(3));
      by = -ay;
    else
      cy = 2/(dist(1)*dist(1));
      by = -cy;
    endif
  else
    coef = dist(1) + dist(3);
    ay = 2/(dist(3)*coef);
    by = -2/(dist(1)*dist(3));
    cy = 2/(dist(1)*coef);
  endif

# Sumar los coeficientes a la matriz K
  K(i,i) += bx + by;

# Siguiendo la nomenclatura, [1 2 3 4] => [S E N W]
  coef = [cy ax ay cx];

  for j = 1:4
    if(neighb(i, j) != -1)
      K(i, neighb(i, j)) += coef(j);
    endif
  endfor

# La fila se multiplica por la constante -k y luego
# se suma la constante c.
K(i, :) *= -k(i);
K(i, i) += c(i);
  
endfor

F = G;
% Salida:
% * K: matriz del sistema (difusión + reacción) con modificaciones luego del ensamble.
% * F: vector de flujo térmico con modificaciones luego del ensamble.
% ----------------------------------------------------------------------
end
