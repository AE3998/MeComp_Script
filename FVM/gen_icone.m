function icone = gen_icone(xmalla, ymalla)
  x = length(xmalla);
  y = length(ymalla);

  icone = [];
  n = 1;
  for i = 1:x-1
    for j = 1:y-1
      icone = [icone; [n, n+y, n+y+1, n+1]];
      n+=1;
    endfor
    n+=1;
  endfor
endfunction

