function [D] = fem2d_pstr_const_mat(model)
% Descripción: módulo para calcular la matriz constitutiva del sistema. La misma
% depende de los valores del Módulo de Young y el Coeficiente de Poisson. La forma
% de esta matriz es siempre de 3x3, pero la selección de coeficientes determina el
% tratamiento del sistema como Deformación o Tensión Plana

% Entrada:
% * model: struct con todos los datos del modelo (constantes, esquema numérico, etc.)

% Salida:
% * D: matriz constitutiva del sistema.
% ----------------------------------------------------------------------

  E = model.young;
  v = model.poiss;

  if model.pstrs == 1
    % Tension plana
    D = (E/(1-v*v)) * [1 v 0; v 1 0; 0 0 (1-v)/2];
  else
    % Deformacion plana
    var1 = 1-v; var2 = 1-2*v;
    D = (E/(1+v)*var2) * [var1 v 0; v var1 0; 0 0 var2/2];
  endif

end
