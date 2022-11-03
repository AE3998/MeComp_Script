% Resolucion de un problema de conduccion de calor por FEM
% COORDENADAS NATURALES - INTEGRACION NUMERICA
% Funciones de forma cuadraticas

% PDE a resolver: k*(d2T_dx2) - c + G = 0

% Cond. de borde Dirichlet DIR
% Cond. de borde Neumann NEU
% Cond. de borde Robin ROB

% Parametros de entrada:
%   xnode: conjuntos de nodos
%   sp: bandera para trabajar o no con matrices sparse
%       sp != 0 --> matriz sparse
%       sp == 0 --> matriz llena


function [T] = FEM_1D(xnode,sp,k,c,G, DIR, NEU, ROB)
    % Cantidad de nodos y elementos
    Nnod = length(xnode);
    Nelem = Nnod - 1;

    % Funciones de forma para elemento master
    N = @(eta)[eta*(eta-1)*0.5,(1+eta).*(1-eta),eta*(eta+1)*0.5];
    dN_deta = @(eta)[eta-0.5,-2*eta,eta+0.5];

    % 2 puntos de gauss
    % pospg = [-sqrt(3)/3 sqrt(3)/3];
    % pespg = [1 1];

    % 3 puntos de gauss
    % Posicion xi [-1 1]
    pospg = [-sqrt(15)/5 0 sqrt(15)/5];
    % Peso wi
    pespg = [5/9 8/9 5/9];

##   [0 0 0;
##    0 0 0;
##    .... ;
##    0 0 0]
    N_eval = zeros(length(pospg),3);
    dN_eval = zeros(length(pospg),3);

% Generar una matriz donde cada fila corresponde a la funcion N, dN evaluado en
% los puntos de gauss correspondiente. En este caso los 3 puntos xi.
% Cada columna es Ni en la posicion xi.

% N_eval(1, :) = [N(-sqrt(15)/5)] = [a0, b0, c0]
% N_eval(2, :) = [N(0)]           = [a1, b1, c1]
% N_eval(3, :) = [N( sqrt(15)/5)] = [a2, b2, c2]

% Lo mismo con la dN_eval
    for pg=1:length(pospg) % 1..2 o 1..3
        N_eval(pg,:) = N(pospg(pg));
        dN_eval(pg,:) = dN_deta(pospg(pg));
    end


    Kele = zeros(Nelem,3,3); % n_alto * 3_ancho * 3_profundo
    fele = zeros(Nelem,3);   % n_alto * 3_ancho

    % G es funcion handle = true / false
    is_f = sum(class(f) == 'function_handle') > 1;

    % Generacion de matrices y vectores elementales
    for ele=1:Nelem
        h = xnode(ele+1)-xnode(ele);
        J = h/2;
        for l=1:3
            for m=1:3
                % k*[wi*dNl]*[dNm]' = cte
                % Columna l y m de dN
                acum1 = k*(pespg.*dN_eval(:,l)')*dN_eval(:,m);

                % Guardar en cada "piso" los componetes de la matriz Klm de cada elemento
                % Recordar que la cuadratura de gauss es una suma de la funcion
                % evaluado en las posiciones indicadas xi. Cada elemento estaba
                % multiplicado por 2/h y termina cancelando todo quedando
                % uno solo 2/h como el ultimo ejemplo de GTP-1D
                Kele(ele,l,m) = (1/J)*acum1;
            end
            acum2 = pespg*N_eval(:,l);
            fele(ele,l) = G*J*acum2;
        end
    end

    if sp
        rows = [];
        cols = [];
        coef = [];
    else
        Kg = zeros(2*Nnod-1,2*Nnod-1);
    end
    fg = zeros(2*Nnod-1,1);

    % Ensamble
    for iele=1:Nelem
        n = 2*iele-1; % [1 3 5...]
        in_gl = [n n+1 n+2]; % [1 2 3 ] o [ 3 4 5 ] o [ 5 6 7...]
        if sp
            for il=1:3
                ig = in_gl(il);
                for jl=1:3
                    jg = in_gl(jl);
                    rows = [rows;ig];
                    cols = [cols;jg];
                    coef = [coef;Kele(iele,il,jl)];
                end
            end
            % Que sucede con los indices repetidos?? Se suman??
            % ej sparse([1 2 2 2], [1 2 2 2], [1 2 3 4])
            % WTF si se suman!!
            Kg = sparse(rows,cols,coef);
            fg(in_gl) = fg(in_gl) + fele(iele,:)';
        else
            % Reconstruir la matriz a 3x3 y sumarlo al global (tiene mas sentido)
            Klocal = reshape(Kele(iele,:,:),3,3);
            Kg(in_gl,in_gl) = Kg(in_gl,in_gl) + Klocal;
            fg(in_gl) = fg(in_gl) + fele(iele,:)';
        end
    end

    % CB Dirichlet
    % x = 0
    Kg(1,:) = 0;
    Kg(1,1) = 1;
    fg(1) = Ti;
    % x = 1
    Kg(2*Nnod-1,:) = 0;
    Kg(2*Nnod-1,2*Nnod-1) = 1;
    fg(2*Nnod-1) = Td;

    % Resolucion del sist. de ecuaciones
    T = Kg\fg;

    xnuevo = zeros(2*Nnod-1,1);
    for i=1:length(xnode)
        xnuevo(2*i-1) = xnode(i);
        if i ~= length(xnode)
            xnuevo(2*i) = (xnode(i)+xnode(i+1))/2;
        end
    end

    % Grafica de comparacion: analitica vs FEM
    aux = G/(2*k);
    a = Td-Ti+aux;
    xref=0:0.01:1;
    T_an = (-aux)*(xref.^2)+a*xref+Ti;
    figure(1);clf;plot(xnuevo,T,'o-',xref,T_an,'r');
end
