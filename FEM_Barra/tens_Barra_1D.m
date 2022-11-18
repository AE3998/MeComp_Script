function te = tens_Barra_1D(icone, ce, ui)
  for i = 1:size(icone, 1)
    idx = icone(i, [1 2]);
    te(i) = ce(i)*(ui(idx(2)) - ui(idx(1)));
  endfor
endfunction
