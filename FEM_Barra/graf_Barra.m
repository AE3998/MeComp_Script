function graf_Barra(icone, pos_i, ui, esc)

  % Definir las posiciones de los nudos desplazados, a una escala esc
  pos_d = zeros(size(pos_i));
  for i = 1:size(pos_i, 1)
    pos_d(i, :) = pos_i(i, :) + esc*[ui(2*i-1), ui(2*i)];
  endfor

  figure(1);
  hold on;
  for i = 1:size(icone, 1)
    pos_nudos = pos_i(icone(i, [1 2]), :);
    pos_nudos_desp = pos_d(icone(i, [1 2]), :);

    line(pos_nudos(:, 1), pos_nudos(:, 2));
    line(pos_nudos_desp(:, 1), pos_nudos_desp(:, 2));
  endfor

  plot(pos_i(:, 1), pos_i(:, 2), 'ro');
  plot(pos_d(:, 1), pos_d(:, 2), 'go');

  legend("Posicion original", "Posicion desplazado", ...
          cstrcat("Esc desp = ", num2str(esc)));
endfunction
