function ROB = gen_ROB(borde, h, Tinf, dir)

  ROB = [];
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
    ROB = [ROB; v, ones(lenv, 1)*h(c), ones(lenv, 1)*Tinf(c), ones(lenv, 1)*dir(c)];
  endfor
endfunction
