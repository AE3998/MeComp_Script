function PHI_borde = get_PHI_borde(PHI, cells, DIR, NEU, ROB)
  % La funcion genera los datos de temperatura del borde como salida.
  % La estructura de la salida es PHI_borde(n_celda, direccion, valor).

  % Borde Dirichlet
  B_DIR = [DIR(:, 1), DIR(:, 3), DIR(:, 2)];

  % Borde Neumann
  %delta_x, y siempre son positivo
  %Para la celda del borde, la k es de la del celda.

  B_NEU = [];
  len_neu = length(NEU(:, 1));

  for i = 1:len_neu
    P = NEU(i, 1);
    q = NEU(i, 2);
    dir = NEU(i, 3);

    ki = [cells(P).ks, cells(P).ke, cells(P).kn, cells(P).kw];
    di = [cells(P).ds, cells(P).de, cells(P).dn, cells(P).dw];

    % Ecuacion de Tex = Tp - q*dxy/k
    Tex = PHI(P) - (q*di(dir))/ki(dir);
    B_NEU = [B_NEU; [P, dir, Tex]];
  endfor

  % Borde Robin

  B_ROB = [];
  len_rob = length(ROB(:, 1));

  for i = 1:len_rob
    P = ROB(i, 1);
    h = ROB(i, 2);
    Tinf = ROB(i, 3);
    dir = ROB(i, 4);

    ki = [cells(P).ks, cells(P).ke, cells(P).kn, cells(P).kw];
    di = [cells(P).ds, cells(P).de, cells(P).dn, cells(P).dw];

    % Asignar los valores y trabajar en forma directo
    ki = ki(dir);
    di = di(dir);

    % fi = h*Tinf*di / k + h*di
    % gi = k / k + h*di
    fi = (h*Tinf*di)/(ki + h*di);
    gi = ki/(ki + h*di);

    Tex = fi + PHI(P)*gi;

    B_ROB = [B_ROB; [P, dir, Tex]];
  endfor
  M = [B_DIR; B_NEU; B_ROB];
  PHI_borde = sortrows(M, [2 1]);

endfunction

