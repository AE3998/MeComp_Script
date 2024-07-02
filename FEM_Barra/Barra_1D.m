function [ui, Ri] = Barra_1D(icone, F_ex, ke, nudo_empot)

    % Control de error
    if size(icone, 2) == 3
      disp("Entrada icone 1D equivocado, por favor reingrese los valores!");
      ui = Ri = NaN;
      return
    endif


    % Cantidad de nudos
    n_nudos = length(unique(icone));

    Klm = sparse(zeros(n_nudos));
    Fl = sparse(zeros(n_nudos, 1));

    Fl(F_ex(:, 1)) = F_ex(:, 2);

    for i = 1:size(icone, 1)
        nudo = icone(i, :);
        Klm(nudo, nudo) += ke(i)*[1 -1; -1 1];
    endfor

    % Se considera solo aquellos no empotrados
    sist = setdiff(1: n_nudos, nudo_empot);

    K_reduc = Klm(sist, sist)
    F_reduc = Fl(sist)
    ui_reduc = K_reduc\F_reduc;

    % Reconstruir el vector de desplazamiento con los empotrados
    ui = sparse(zeros(n_nudos, 1));

    ui(sist) = ui_reduc;

    Ri = Klm * ui;

endfunction

