% Resolucion de un problema de conduccion de calor por FEM
% COORDENADAS NATURALES - INTEGRACION NUMERICA
% Funciones de forma cuadraticas

% PDE a resolver: k*(d2T_dx2) - c + G = 0

% Cond. de borde Dirichlet DIR
% Cond. de borde Neumann NEU
% Cond. de borde Robin ROB

% Parametros de entrada:
%   xnode: conjuntos de nodos
%   qu != 0 --> funcion cuadratica
%   qu == 0 --> funcion lineal


function [xn, T] = FEM_1D(xnode,qu,pmt, DIR, NEU, ROB)

      k = pmt.k;
      c = pmt.c;
      G = pmt.G;

##     [Klm Fl] = FEM_1D_gen_system_Quad(xnode,k,c,G);

    if qu
      [Klm Fl] = FEM_1D_gen_system_Quad(xnode,k,c,G);
    else
      [Klm Fl] = FEM_1D_gen_system_Lineal(xnode,k,c,G);
    endif

    % CB Dirichlet
    for i = 1:size(DIR, 1);
      % Izquierda
      if(DIR(i, 2) == 0)
        Klm(1,:) = 0;
        Klm(1,1) = 1;
        Fl(1) = DIR(i, 1);
      else
      % Derecha
        Klm(end,:) = 0;
        Klm(end, end) = 1;
        Fl(end) = DIR(i, 1);
      endif
    endfor


    % CB Neumann
    if !isempty(NEU)
      if NEU(2) % Si es 1, Derecha
        Fl(end) -= NEU(1);
      else
        Fl(1) -= NEU(1);
      endif
    endif

    % CB Robin % Verificar Fl += o -=
    if !isempty(ROB)
      h_phi = ROB(1)*ROB(2);

      if ROB(3) % Si es 1, Derecha
        Klm(end, end) += ROB(1);
        Fl(end) += h_phi;
      else
        Klm(1, 1) += ROB(1);
        Fl(1) += h_phi;
      endif
    endif

    % Resolucion del sist. de ecuaciones
    switch (pmt.ts)
    case 0
      % dt explicito, numero de Fourier k = k/pCp cuando pCp != 0
      % Fo = k*dt/dx^2 < 1 => dt < dx^2/k

      dx_prom = mean([xnode(2:end) - xnode(1:end-1)]);
##      dx_prom = max([xnode(2:end) - xnode(1:end-1)]);
##      dx_prom = min([xnode(2:end) - xnode(1:end-1)]);

      pmt.dt = (dx_prom.^2)/(pmt.k/ (pmt.rho * pmt.Cp));
      T = FEM_1D_explicit(Klm, Fl, pmt);
    case 1
      T = FEM_1D_implicit(Klm, Fl, pmt);
    otherwise
      T = Klm\Fl;
    endswitch

    % Reformulacion de xnode si se trata de una malla no uniforme
    if qu
      xn = sort([xnode, (xnode(2:end) + xnode(1:end-1))/2]);
    else
      xn = xnode;
    endif

endfunction
