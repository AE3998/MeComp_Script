function Phi = FEM_1D_explicit(K, F, pmt)

    disp('Iniciando el calculo de esquema temporal explicito...')

    rho       = pmt.rho;
    Cp        = pmt.Cp;
    maxit     = pmt.maxit;
    tol       = pmt.tol;
    dt        = pmt.dt;
    Phi_init  = pmt.Phi_init;

    coef = dt/(rho*Cp);
    Phi = Phi_now = Phi_next = Phi_init;

    len = length(F);

    for i = 1:maxit
      Phi_next = coef*F + (eye(len) - coef*K)*Phi_now;

      % Error relativo
      err = norm(Phi_next - Phi_now, 2)/norm(Phi_next, 2);
      Phi = [Phi, Phi_next];
      Phi_now = Phi_next;

      if(err < tol)
        disp(cstrcat("Metodo explicito ha completado su calculo en ", ...
                    num2str(i), " pasos."));
        return;
      endif
    endfor
    disp('Metodo explicito ha llegado la maxima iteracion.');

endfunction





