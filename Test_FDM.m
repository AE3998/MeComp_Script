A = [1 3 4 2 34 4 NaN];
A([1 3])

z = sparse([1],[1],[0])
x = [1 0 0; 1 1 1; 0 0 1];

y = [1 2; 3 4];

w = sparse(x)

w(y(:,1), :) = 9
w(2, 2) = 1


w([1 3], [1 3]) -= 1

# Neumann

M = ones(3);
d = diag(2*ones(3,1)); # Diagonal de un vector es una matriz

M -= d;

[a, b] = min(M)
A = M<0

M += M<0

# Despejo primero el indice del vecino. Al indice de la normal le sumo 2 y
# divido por 5 y sacar el resto. Si el valor de la normal es 1, seria entonces
# (1+2)%5 = 3. Usando la idea para despejar el indice correspondiente del
# neighb. El caso de la normal que vale 3, al despejar el resto da como
# resultado (3+2)%5 = 0, lo cual no es un indice valido. En este caso se suma 1
# a aquellos valores que son igual a cero.
#
  indice_vecino = (NEU(:, 3)+2)%5; # [1 2 3 4] => [3 4 0 1]
  indice_vecino += indice_vecino <= 1; # [1 2 3 4] => [3 4 1 2]

# se puede observar que tranquilamente puedo crear un vector y meter los
# valores en orden inverso.

i_v = [3 4 1 2];

Px = [1 1 2 2 3 3 4 4 1 3 1 2 4];

i_v(Px)

dist = [0 1; 0 0]-[ 1 1; 2 0]
norm(dist, "rows")

[1,2,3](3)
% Esto puede ser la causa en que el metodo reducido no funciona.
A = [1 0]
A([1 1]) += 5


