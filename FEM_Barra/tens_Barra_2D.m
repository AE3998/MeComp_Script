function te = tens_Barra_2D(icone, ce, ui)
  for i = 1:size(icone, 1)

    idx = icone(i, [1 2]);
    rad = (icone(i, 3)*pi)/180;

    C = cos(rad); S = sin(rad);

    T = [-C -S C S];

    u = 2*idx-1;
    v = 2*idx;

    d = [u(1) v(1) u(2) v(2)];
    te(i) = ce(i) * T*ui(d);
  endfor
endfunction
