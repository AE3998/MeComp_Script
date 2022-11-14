function [Klm Fl] = FEM_1D_gen_system_Quad(xnode,k,c,G)
   % nodos.size() y elementos.size()
    xlen = length(xnode);
    elen = xlen - 1;

% Funciones de forma Nl y dNl para elemento master
    Nl = @(eta)[eta*(eta-1)*0.5,(1+eta).*(1-eta),eta*(eta+1)*0.5];
    dNl = @(eta)[eta-0.5,-2*eta,eta+0.5];
% Nl(x)  = [N1(x), N2(x), N3(x)]
% dNl(x) = [dN1(x), dN2(x), dN3(x)]


% Puntos y pesos de gauss xi = [-1 <= x <= 1]
      xi = [-sqrt(15)/5 0 sqrt(15)/5];
      wi = [5/9 8/9 5/9];
      xilen = 3;

##    if !qu
##      % 2 puntos de gauss
##      xi = [-sqrt(3)/3 sqrt(3)/3];
##      wi = [1 1];
##      xilen = 2;
##    endif

% Nl y dNl evaluado en 3 puntos
    N_eval = zeros(length(xi),3);
    dN_eval = zeros(length(xi),3);

% Generar una matriz donde cada fila corresponde a la funcion N, dN evaluado en
% los puntos xi de gauss correspondiente, en este caso los 3 puntos.
% Cada columna es Ni en la posicion xi.

    for m = 1:xilen % 1..3
        N_eval(m,:) = Nl(xi(m));      % [N1(x), N2(x), N3(x)]
        dN_eval(m,:) = dNl(xi(m));    % [dN1(x), dN2(x), dN3(x)]
    end
% [x1 = -sqrt(15)/5 , x2 = 0 , x3 = sqrt(15)/5]
% N_eval(1, :) = [N1(x1), N2(x1), N3(x1)]
% N_eval(2, :) = [N1(x2), N2(x2), N3(x2)]
% N_eval(3, :) = [N1(x3), N2(x3), N3(x3)]
% dN_eval(1,:) = [dN1(x1), dN2(x1), dN3(x1)]
% dN_eval(2,:) = [dN1(x2), dN2(x2), dN3(x2)]
% dN_eval(3,:) = [dN1(x3), dN2(x3), dN3(x3)]

% Tamanio del sistema
    nlen = 2*elen + 1;

    Klm = sparse(zeros(nlen));
    Fl = sparse(zeros(nlen, 1));

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
        % K11 = 2k/h * (w1 * dN1(x1)*dN1(x1) + w2 * dN1(x2)*dN1(x2) + w3 * dN1(x3)*dN1(x3))
        % K12 = 2k/h * (w1 * dN1(x1)*dN2(x1) + w2 * dN1(x2)*dN2(x2) + w3 * dN1(x3)*dN2(x3))
        % ...
        Kele = k*(wi.*dN_eval')*dN_eval /J;


        % C11 = c * (w1 * N1(x1)*N1(x1) + w2 * N1(x2)*N1(x2) + w3 * N1(x3)*N1(x3))
        % C12 = c * (w1 * N1(x1)*N2(x1) + w2 * N1(x2)*N2(x2) + w3 * N1(x3)*N2(x3))
        % ...
        if c
          Kele += c* (wi.*N_eval')*N_eval * J;
        endif

        % Generacion del vector F del elemento e

        % La integral de Gauss del componente Fl de cada elemento es:
        % F1 = h/2 * G(pos_x1) * (w1 * N1(x1)+ w2 * N1(x2) + w3 * N1(x3))
        % F2 = h/2 * G(pos_x2) * (w1 * N2(x1)+ w2 * N2(x2) + w3 * N2(x3))
        % F3 = h/2 * G(pos_x3) * (w1 * N3(x1)+ w2 * N3(x2) + w3 * N3(x3))

        acum2 = J*wi*N_eval;
        % Meter el parametro G, si es una funcion G(x) o una constante
        if is_f
          Fele = G(pos_x).*acum2;
        else
          Fele = G*acum2;
        endif

        % Ensamble
        % Indice de cada submatriz Kele 3x3
        ind = [2*e-1: 2*e+1]; % [1 2 3] o [3 4 5] o [5 6 7] ...

        Klm(ind, ind) += Kele;
        Fl(ind) += Fele';
    endfor

endfunction


