function T = FEM_1D_eval(xn,Phi, qu, x)

##  x = x_eval;
##  Phi = Phi(:, end);

  % Verificar si x esta en el rango [x0 xl]
  if (x>xn(end) || x<xn(1))
    disp("Valor de x invalido!");
    T = NaN;
    return
  endif

  % Verificar si x es uno de los nodos, si lo es, retorna el valor Phi
  % de ese punto
  idx = find(xn == x);
  if !isempty(idx)
    T = Phi(idx);
    return
  endif

  % En el cuadratico existe nodos "aritificiales" y los indices impares son "reales"
  if qu
    % Cuento cuantos numeros son menor que x, que coincide con el indice de partida,
    % luego el indice tiene que ser impar.
    % Ej x = 2.5, sum([1 2 3 4 5] < 2.5) = 2, begin = 2.
    % Los indices impares son los reales y los pares son artificiales,
    % entonces begin = 1.

    begin = sum(xn < x);
    if (!mod(begin, 2))
      begin -= 1;
    endif

    % Se toma los 3 nodos seguidos a partir del begin.
    Phi_val = Phi(begin: begin+2);

    % Construir el sistema en forma isoparametrica
    xc = xn(begin+1);
    h = xn(begin+2) - xn(begin);
    eta = ((x - xc)*2)/h;
    Nl = [eta*(eta-1)*0.5,(1+eta)*(1-eta),eta*(eta+1)*0.5];

    T = Nl*Phi_val;

  else

    begin = sum(xn < x);
   % Se toma los 2 nodos seguidos a partir del begin.
    Phi_val = Phi(begin: begin+1);

    % Construir el sistema en forma isoparametrica
    xc = (xn(begin) + xn(begin+1))*0.5;
    h = xn(begin+1) - xn(begin);
    eta = ((x - xc)*2)/h;
    Nl = [(1-eta)*0.5,(1+eta)*0.5];

    T = Nl*Phi_val;

  endif
endfunction



