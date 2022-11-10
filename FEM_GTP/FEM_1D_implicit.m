function Phi= FEM_1D_implicit(K, F, pmt)

    disp('Iniciando el calculo de esquema temporal implicito...')

    rho       = pmt.rho;
    Cp        = pmt.Cp;
    maxit     = pmt.maxit;
    tol       = pmt.tol;
    dt        = pmt.dt;
    Phi_init  = pmt.Phi_init;


    Phi = Phi_now = Phi_next = Phi_init;
    pCp = rho * Cp;
    coef = pCp/dt;
    len = length(F);
    Kinv = coef*eye(len) + K;

    for i = 1: maxit
      f = (F + coef*Phi_now);
      Phi_next = Kinv\f;
      Phi = [Phi Phi_next];

      err = norm(Phi_next - Phi_now)/norm(Phi_next);
      Phi_now = Phi_next;

      if(err < tol)
               disp(cstrcat("Metodo implicito ha completado su calculo en ", ...
                    num2str(i), " pasos."));
        return;
      endif;

    endfor
    disp('El metodo implicito ha llegado su maxima iteracion.');
endfunction







