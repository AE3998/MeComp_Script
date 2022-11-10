function [Klm Fl] = FEM_1D_gen_system_Lineal(xnode,k,c,G)
   % nodos.size() y elementos.size()
    xlen = length(xnode);
    elen = xlen - 1;

% Funciones de forma Nl y dNl para elemento master
    Nl = @(eta)[(1-eta)*0.5,(1+eta)*0.5];
    dNl = [-1/2,1/2];
% Nl(x)  = [N1(x), N2(x)]
% dNl(x) = [dN1(x), dN2(x)]


% Puntos y pesos de gauss xi = [-1 <= x <= 1]
      xi = [-1/sqrt(3), 1/sqrt(3)];
##    wi = [1 1]; % Son todo 1, no tiene sentido en este caso

% Nl evaluado en 2 puntos
    N_eval = Nl(xi');
    dN_eval = [dNl; dNl];

% [x1 = -1/sqrt(3), x2 = 1/sqrt(3)]
% N_eval(1, :) = [N1(x1), N2(x1)]
% N_eval(2, :) = [N1(x2), N2(x2)]

% dN_eval(1,:) = [dN1(x1), dN2(x1)]
% dN_eval(2,:) = [dN1(x2), dN2(x2)]


    Klm = sparse(zeros(xlen));
    Fl = sparse(zeros(xlen, 1));

% G es funcion_handle = true / false
    is_f = sum(class(G)) == 1585;

% Generacion de matrices Kele, vectores Fele y ensamble
    for e = 1:elen
        h = xnode(e+1)-xnode(e);
        J = h/2;

        % Los 3 puntos en el sistema real [xc+x1*h/2, xc+x2*h/, xc+x3*h/2]
        xc = (xnode(e) + xnode(e+1))*0.5;
        pos_x = xc + J*xi;

        % https://es.wikipedia.org/wiki/Cuadratura_de_Gauss

        % Generacion de la Matriz K del elemento e

        % La integral de Gauss del componente Klm de cada elemento es:
        % K11 = 2k/h * (w1 * dN1(x1)*dN1(x1) + w2 * dN1(x2)*dN1(x2))
        % K12 = 2k/h * (w1 * dN1(x1)*dN2(x1) + w2 * dN1(x2)*dN2(x2))
        % ...
        Kele = k*(dN_eval')*dN_eval /J;


        % C11 = c * (w1 * N1(x1)*N1(x1) + w2 * N1(x2)*N1(x2))
        % C12 = c * (w1 * N1(x1)*N2(x1) + w2 * N1(x2)*N2(x2))
        % ...
        if c
          Kele += c* (N_eval')*N_eval * J;
        endif

        % Generacion del vector F del elemento e

        % La integral de Gauss del componente Fl de cada elemento es:
        % F1 = h/2 * G(pos_x1) * (w1 * N1(x1)+ w2 * N1(x2))
        % F2 = h/2 * G(pos_x2) * (w1 * N2(x1)+ w2 * N2(x2))

        acum2 = J*N_eval;
        % Meter el parametro G, si es una funcion G(x) o una constante
        if is_f
          Fele = G(pos_x).*([1 1]*acum2);
        else
          Fele = G*[1 1]*acum2;
        endif

        % Ensamble
        % Indice de cada submatriz Kele 3x3
        ind = [e, e+1]; % [1 2] o [2 3] o [3 4] ...

        Klm(ind, ind) += Kele;
        Fl(ind) += Fele';
    endfor

endfunction


