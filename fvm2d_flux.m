function [Q] = fvm2d_flux(PHI,cells,neighb)
% Descripción: módulo calcular el flujo de calor en todo el dominio. Se aplica la
% Ley de Fourier y se evalúa como fluye el calor en todos los centros de celdas del
% dominio.

% Entrada:
% * PHI: vector solución. Cada elemento del vector representa un valor escalar }
% asociado a cada celda de la malla, y su posición dentro del vector depende de
% cómo se especificó en icone.
% * neighb: matriz de vecindad.
% * cells: vector de celdas.

% Salida:
% * Q: vector de flujo de calor. Se forma de una componente en sentido x, Qx, y
% una componente en sentido y, Qy.
% ----------------------------------------------------------------------
    len = length(neighb(:, 1));
    Qx = Qy = zeros(len, 1);
    for i = 1:len
      S = neighb(i, 1);
      E = neighb(i, 2);
      N = neighb(i, 3);
      W = neighb(i, 4);

      if(E != -1 && W != -1)
        de = cells(i).de;
        dw = cells(i).dw;

        fx = de/(de+dw); %

        k = cells(i).ke * fx + cells(i).kw * (1 - fx);% Que??

        Qx(i) = -k * (PHI(E) - PHI(W))/(de+dw);%
      elseif (E != -1)
        Qx(i) = -cells(i).ke * (PHI(E) - PHI(i))/(cells(i).de);
      else
        % Si, usa la coordenada global x, y
        Qx(i) = -cells(i).kw * (PHI(i) - PHI(W))/(cells(i).dw);
      endif

      if(N != -1 && S != -1)
        dn = cells(i).dn;
        ds = cells(i).ds;

        fx = dn/(dn+ds); %

        k = cells(i).kn * fx + cells(i).ks * (1 - fx);% Que??

        Qy(i) = -k * (PHI(N) - PHI(S))/(dn+ds);%
      elseif (N != -1)
        Qy(i) = -cells(i).kn * (PHI(N) - PHI(i))/(cells(i).dn);
      else
        % Si, usa la coordenada global x, y
        Qy(i) = -cells(i).ks * (PHI(i) - PHI(S))/(cells(i).ds);
      endif
    endfor
    Q = [Qx Qy];
end
