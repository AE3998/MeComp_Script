function [Qn] = fem2d_heat_flux(xnode,icone,model,PHI)
% Descripción: módulo calcular el flujo de calor en todo el dominio. Se aplica
% la Ley de Fourier y se evalúa como fluye el calor en todos los puntos (nodos)
% del dominio.

% Entrada:
% * K: matriz del sistema (difusión + reacción)
% * F: vector de flujo térmico.
% * PHI: vector solución. Cada elemento del vector representa un valor escalar
%   asociado a cada nodo de la malla, y su posición dentro del vector depende
%   de cómo se especificó cada nodo en xnode.

% Salida:
% * Q: vector de flujo de calor.
% ----------------------------------------------------------------------
  Q = zeros(model.nnodes,3);
  for e = 1 : model.nelem
      if (icone(e,4) == -1)
          ele = icone(e,1:3);
      else
          ele = icone(e,:);
      end
      nodes = xnode(ele,:);
      temp = PHI(ele);
      k = [model.kx 0;0 model.ky];

      if (size(nodes,1) == 3) % elemento triangular
          J = [nodes(2,1)-nodes(1,1)  nodes(2,2)-nodes(1,2);
               nodes(3,1)-nodes(1,1)  nodes(3,2)-nodes(1,2)];
          DN = [-1 1 0;-1 0 1];
          B = J\DN; % inv(J)*DN
          qxy = (-k*B*temp)';
          for k=1:3
              Q(ele(k),1:2) = Q(ele(k),1:2) + qxy;
              Q(ele(k),3) = Q(ele(k),3) + 1;
          end
      else
          % cuatro puntos de Gauss con peso w=1
          p = [-1 -1;
                1 -1;
                1  1;
               -1  1];

          for i=1:4
            s = p(i,1);
            t = p(i,2);
            DNnum = 0.25*[(-1+t),( 1-t),( 1+t),(-1-t);
                     (-1+s),(-1-s),( 1+s),( 1-s)];
            J = (DNnum)*nodes;
            B = J\DNnum; % inv(J)*DNnum;
            qxy = (-k*B*temp)';
            Q(ele(i),1:2) = Q(ele(i),1:2) + qxy;
            Q(ele(i),3) = Q(ele(i),3) + 1;
          endfor
      endif
  endfor

  Qn(:,1) = Q(:,1)./Q(:,3);
  Qn(:,2) = Q(:,2)./Q(:,3);
end

