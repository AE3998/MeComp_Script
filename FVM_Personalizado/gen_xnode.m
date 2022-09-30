function xnode = gen_xnode(xmalla, ymalla)
% El generador de malla NO se tiene en cuenta el ancho de banda, siempre recorre
% primero hacia y+ y despues se desplaza hacia el +x

xnode = []

  for i = 1:length(xmalla)
    for j = 1:length(ymalla)
        xnode = [xnode; xmalla(i), ymalla(j)];
    endfor
  endfor

endfunction

