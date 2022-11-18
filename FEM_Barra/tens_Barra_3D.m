function te = tens_Barra_3D(xnode, icone, ce, ui)
  for i = 1:size(icone, 1)

    idx = icone(i, [1 2]);
    pos = xnode(idx(2), :) - xnode(idx(1), :);

    L = norm(pos);
    Cx = pos(1)/L; Cy = pos(2)/L; Cz = pos(3)/L;

    T = [-Cx -Cy -Cz Cx Cy Cz];

    % Si el par de nodos es [2 5], los indices correspondientes
    % al desplazamiento es d = [4 5 6, 13 14 15]
    u = 3*idx-2;
    v = 3*idx-1;
    w = 3*idx;

    d = [u(1) v(1) w(1) u(2) v(2) w(2)];
    te(i) = ce(i) * T*ui(d);
  endfor
endfunction



