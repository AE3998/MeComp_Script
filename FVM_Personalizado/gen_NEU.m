function NEU = gen_NEU(borde, val, dir)

  NEU = [];
  for c = 1:length(dir)
    v = [];
    switch dir(c)
      case 1
        v = borde.S;
      case 2
        v = borde.E;
      case 3
        v = borde.N;
      otherwise
        v = borde.W;
    endswitch
    lenv = length(v);
    NEU = [NEU; v, ones(lenv, 1)*val(c), ones(lenv, 1)*dir(c)];
  endfor
endfunction
