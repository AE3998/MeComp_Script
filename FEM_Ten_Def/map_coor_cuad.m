function M = map_coor_cuad(nodes)
  disp("x(s, t) = SUM[ xm*Nm");
  disp("y(s, t) = SUM[ ym*Nm");

  coe1 = sum(nodes)/4;
  % xi
  coe2 = 0.25*(sum(nodes([2, 3], :)) - sum(nodes([1, 4], :)));
  % eta
  coe3 = 0.25*(sum(nodes([3, 4], :)) - sum(nodes([1, 2], :)));
  % xi*eta
  coe4 = 0.25*(sum(nodes([3, 1], :)) - sum(nodes([4, 2], :)));

  % Transpuesta
  printf("[cte | xi | eta | xi*eta ]");
  M = [coe1; coe2; coe3; coe4]'

endfunction
