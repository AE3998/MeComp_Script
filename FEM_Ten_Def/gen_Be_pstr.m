% Rutina que se despeja la expresion de Be segun el parametro xi, eta dado
% donde el intervalo es xi = eta = [-1  1].
% Sirve mas que nada para el cuadrangulo, pues el triangulo Be es constante
function Be = gen_Be_pstr(nodes, xi, eta)
  if size(nodes, 1) == 3
    J = [ nodes(2, :) - nodes(1, :); ...
          nodes(3, :) - nodes(1, :)];
    Baux = J\[-1 1 0; -1 0 1];

    Be = zeros(3, 6);
    % Las filas que contienen dNi/ds
    Be(1, [1 3 5]) = Baux(1, :);
    Be(3, [2 4 6]) = Baux(1, :);

    % Las filas que contienen dNi/dt
    Be(2, [2 4 6]) = Baux(2, :);
    Be(3, [1 3 5]) = Baux(2, :);

  else
    % Generar la derivada segun el valor de xi y eta dado
    s = xi; t = eta;
    dNi = 0.25*[ -(1-t) (1-t) (1+t) -(1+t);...
                 -(1-s) -(1+s) (1+s) (1-s)];
    J = dNi*nodes;
    Baux = J\dNi;%inv(J)*dNi;

    % Armar a pata Be
    Be = zeros(3, 8);

    % Las filas que contienen dNi/ds
    Be(1, [1 3 5 7]) = Baux(1, :);
    Be(3, [2 4 6 8]) = Baux(1, :);

    % Las filas que contienen dNi/dt
    Be(2, [2 4 6 8]) = Baux(2, :);
    Be(3, [1 3 5 7]) = Baux(2, :);
  endif

endfunction
