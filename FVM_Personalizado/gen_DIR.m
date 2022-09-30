function DIR = gen_DIR(xmalla, ymalla, val, dir)

  DIR = [];
  for c = 1:length(dir)
    if(dir(c)>4 || dir(c)<=0)
      disp('direccion invalido');
      break;
    endif
    v = [];
    lenx = length(xmalla);
    leny = length(ymalla);

    if(mod(dir(c), 2)) % true cuando dir(c) es 1 o 3 (S o N)
      n = 1;
      % Indices de celdas del borde inferior
      for i = 1:lenx-1
        v = [v; n] ;
        n+=leny-1;
      endfor
        % Cuando en realidad se trata de la cara superior, se le suma el n necesario
        % para convertir a los indices superiores.
      v += (leny-2)*(dir(c)==3);
    else
      % Generar los indices de celdas del borde izquierda
      v = [1:leny-1]';
      % Cuando es 2, a los indices se le suma un n para ajustar los indices de la
      % cara derecha
      v += (dir(c)==2)*(lenx-2)*(leny-1);
    endif


    lenv = length(v);
    DIR = [DIR; v, ones(lenv, 1)*val(c), ones(lenv, 1)*dir(c)];
  endfor
endfunction
