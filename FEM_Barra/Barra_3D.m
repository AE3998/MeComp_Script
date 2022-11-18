function [ui Ri] = Barra_3D(xnode, icone, F_ex, ke, nudo_empot)

    % Cantidad de nudos
    n_nudos = length(unique(icone(:, [1 2])));

    % Las matrices con triple del tamanio
    Klm = sparse(zeros(3*n_nudos));
    Fl = sparse(zeros(3*n_nudos, 1));

    for i = 1:size(F_ex, 1)
      nudo = F_ex(i, 1);
      % siendo ui = 2*nudo-1, vi = 2*nudo
      Fl([3*nudo-2, 3*nudo-1, 3*nudo]) = F_ex(i, [2 3 4]);
    endfor

    for i = 1:size(icone, 1)
        % los pares de nudos de cada barra
        nudos = icone(i, [1 2]);

        % cos(ang) = x2-x1/L, sin(ang) = y2-y1/L, cosZ = z2-z1/L
        L = norm(xnode(nudos(2), :) - xnode(nudos(1), :));
        dxyz = xnode(nudos(2), :) - xnode(nudos(1), :);

        % Las funciones trigonometricas
        Cx = dxyz(1)/L; Cy = dxyz(2)/L; Cz = dxyz(3)/L;

        % Construir la matriz k'
        sK = [  Cx*Cx Cx*Cy Cx*Cz;...
                Cy*Cx Cy*Cy Cy*Cz;...
                Cz*Cx Cz*Cy Cz*Cz ];
        K = [sK -sK; -sK sK];

        % Si el par de nudos = [2 5], sus correspondientes indices en
        % la matriz global es idx_uvw = [4 5 6 , 13 14 15]
        ui = 3*nudos - 2;
        vi = 3*nudos - 1;
        wi = 3*nudos;

        idx_uvw = [ui(1) vi(1) wi(1) ui(2) vi(2) wi(2)];
        Klm(idx_uvw, idx_uvw) += ke(i)*K;
    endfor

##    % Se considera solo aquellos no empotrados
##    uv_empot = sort([2*nudo_empot-1, 2*nudo_empot]);
##    sub_sist = setdiff(1: 2*n_nudos, uv_empot);

    sub_sist = zeros(1, 3*n_nudos);

    % uvw empotrados, se toma valor true si esta empotrado el eje del nudo
    for i = 1:size(nudo_empot, 1)
        idx = nudo_empot(i, 1);
        sub_sist([3*idx-2, 3*idx-1, 3*idx]) = nudo_empot(i, [2, 3, 4]);
    endfor

    % Se invierte los valores para considerar solamente aquiellos no empotrados
    sub_sist = !sub_sist;

    K_reduc = Klm(sub_sist, sub_sist);
    F_reduc = Fl(sub_sist);
    ui_reduc = K_reduc\F_reduc;

    % Reconstruir el vector de desplazamiento con los empotrados
    ui = sparse(zeros(3*n_nudos, 1));

    ui(sub_sist) = ui_reduc;
    Ri = Klm * ui;


endfunction

