function graf_Barra_1D(icone, pos_i, ui, esc)

  % Definir las posiciones de los nudos desplazados, a una escala esc
  pos_d = pos_i + esc*ui';
  dist = 1e-2;
  figure(1);
  hold on;
  for i = 1:size(icone, 1)
    pos_nudos = pos_i(icone(i, [1 2]));
    pos_nudos_desp = pos_d(icone(i, [1 2]));

    plot(pos_nudos, [0 0], 'r');
    plot(pos_nudos_desp, [0 0]+dist, 'g');
  endfor

  y = zeros(1, length(pos_i));
  plot(pos_i, y, 'ro');
  plot(pos_d, y+dist, 'go');
  grid on;
  axis('equal');
  legend("Rojo = original", "Verde = desplazado", ...
          cstrcat("Esc desp = ", num2str(esc)));
endfunction
