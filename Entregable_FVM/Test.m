
c = [1 2 3]

1./c

K*Phi
exp(c)

i = 0;
if(!i)
  i += 10;
endif
i

x = {
  a = 1;
  b = 2;
}

x.a
  dx = xp(2:end) - xp(1:end-1); # la longitud esta reducida, por lo que se recurre usar end.


% De -> k/de, coeficiente acompanado al termino Este del difusivo
  %De = k./dx(2:end);

% Dw -> k/dw, coeficiente acompanado al termino Oeste del difusivo
  %Dw = k./dx(1:end-1);

% Suposicion que De = Dw = k/dx ya que depende solamente por donde esta posicionado

% x seran excluidos en los calculos.

% Be -> centro del borde Este - centro de celda xp.
% xe - xp = [ x | 2_| ..._| n-1_| x ]
  Be = malla(3:end-1)-xp(2: end-1);

% Bw -> centro de celda xp - centro del borde Oeste.
% xp - xw = [ x |_2 |_... |_n-1 | x ]
  Bw = xp(2: end-1)-malla(2:end-2);

% A modo de complemento, por si esta equivocado se puede borrar:
% Se supone que cada borde tienen sus coeficientes correspondientes. Si hablo de
% de la frontera Oeste, el coeficiente es Bw = (xp - xw)/(xp - xW) con xW = xw.
% Esto significa que Bw en este caso valdra 1. El proceso sera identico con
% el tratamiento de Be con la frontera Este. Be = (xe - xp)/(xE - xp) siendo
% xE = xe y Be = 1 en aquella frontera. Se calcula de esta manera ya que el centro
% de cada frontera es tratado como un "centro de celda adicional".
% Se agrega el peso de cada frontera como se muestra en la siguiente
% explicacion.

% Be += [ x_| 2 | ... | n-1 | x_]
%  Be = [malla(2)-xp(1), Be, 1];

% Bw += [_x | 2 | ... | n-1 |_x ]
%  Bw = [1, Bw, xp(end)-malla(end-1)];

% Repasando la teoria, parece que nuna hay un tratamiento con el peso de la
% frontera. -> [ x_] y [_x ] no van creo. De hecho el tamano del vector tampoco
% se coinciden si luego lo combino con el vector de dx. De esta manera se crea un sistema
% de ecuacion con los extremos 1, con las incongnitas los centros del celdas.

%% 1er Suposicion, la dx esta bien y B estan mal. no deberia incluirse las fronteras
% En este caso -aw,2 y -aw,m del sistema seran 0.


% Be += [ x_| 2 | ... | n-1 | x ]
  Be = [malla(2)-xp(1), Be];

% Bw += [ x | 2 | ... | n-1 |_x ]
  Bw = [Bw, xp(end)-malla(end-1)];

% Se procede a calcular los coeficientes de la matriz, sabiendo que aE, aW tienen
