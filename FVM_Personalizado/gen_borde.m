function borde = gen_borde(xmalla, ymalla)

    v = [];
    lenx = length(xmalla);
    leny = length(ymalla);
    n = 1;
    % Indices de celdas del borde inferior
    for i = 1:lenx-1
      v = [v; n] ;
      n+=leny-1;
    endfor
    borde.S = v;
    % Sumar la constante n para generar los indices del borde superior.
    borde.N = v +(leny-2);

    % Generar los indices de celdas del borde izquierda
    v = [1:leny-1]';
    borde.W = v;
    % Cuando es 2, a los indices se le suma un n para ajustar los indices de la
    % cara derecha
    borde.E = v + (lenx-2)*(leny-1);

endfunction
