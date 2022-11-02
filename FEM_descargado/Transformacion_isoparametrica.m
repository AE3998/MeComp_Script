function [X2S,S2X,Jaco] = xy2st(xnod,icone,psipg,etapg);
%-------------------------------------------------------------------
%          --- FEMCODE routine ---
%
%     [X2S,S2X,Jaco] = xy2st(xnod,icone,psipg,etapg);
%
%  (1) Calculo del jacobiano y tensor metrico transformacion
%      al elemento master
%-------------------------------------------------------------------

[nnod,ndm]=size(xnod);
[nele,nen]=size(icone);

if ndm==1,

  xs = v2m(xnod(icone,1),nele);

  if nen==2,

   dN1d1  = -0.5;
   dN2d1  = +0.5;
   x1     = xs(1,:)';
   x2     = xs(2,:)';
   dxdpsi = x1*dN1d1+x2*dN2d1;
   Jaco   = dxdpsi;
   S2X    = dxdpsi;
   X2S    = 1 ./ Jaco;

  elseif nen==3,
  % Elementos cuadraticos

   dN1d1  = -0.5*(1-2*psipg);
   dN2d1  = -2*psipg;
   dN3d1  = +0.5*(1+2*psipg);
   x1     = xs(1,:)';
   x2     = xs(2,:)';
   x3     = xs(3,:)';
   dxdpsi = x1.*dN1d1+x2.*dN2d1+x3.*dN3d1;
   Jaco   = dxdpsi;
   S2X    = dxdpsi;
   X2S    = 1 ./ Jaco;

  elseif nen==4,
  % Elementos cubicos

  dN1d1 =  -9/16*( ...
    (psipg-1/3).*(psipg-1)+(psipg+1/3).*(psipg-1)+(psipg+1/3).*(psipg-1/3));
  dN2d1 = +27/16*( ...
    (psipg-1/3).*(psipg-1) + (psipg+  1).*(psipg-1) + (psipg+  1).*(psipg-1/3));
  dN3d1 = -27/16*( ...
   (psipg+1/3).*(psipg-1) + (psipg+  1).*(psipg-1) + (psipg+  1).*(psipg+1/3));
  dN4d1 =  +9/16*( ...
   (psipg+1/3).*(psipg-1/3)+(psipg+  1).*(psipg-1/3)+(psipg+  1).*(psipg+1/3));
   x1     = xs(1,:)';
   x2     = xs(2,:)';
   x3     = xs(3,:)';
   x4     = xs(4,:)';
   dxdpsi = x1.*dN1d1+x2.*dN2d1+x3.*dN3d1+x4.*dN4d1;
   Jaco   = dxdpsi;
   S2X    = dxdpsi;
   X2S    = 1 ./ Jaco;

  else,
    error(' Mala eleccion de las funciones de interpolacion')
  end

else
  if nen==4,

  psi = [-1 1 1 -1 ];
  eta = [-1 -1 1 1 ];

  % Calculo jacobiano transformacion al elemento master
  %--------------------------------------------------------

  xs = v2m(xnod(icone,1),nele);
  x1 = xs(1,:)';
  x2 = xs(2,:)';
  x3 = xs(3,:)';
  x4 = xs(4,:)';
  ys = v2m(xnod(icone,2),nele);
  y1 = ys(1,:)';
  y2 = ys(2,:)';
  y3 = ys(3,:)';
  y4 = ys(4,:)';

  % Calculo de las derivadas de las funciones de forma
  % respecto a cada direccion del elemento master
  %                dN_j/dpsi_k

  dN1d1 = 0.25*psi(1)*(1+eta(1)*etapg);
  dN1d2 = 0.25*eta(1)*(1+psi(1)*psipg);

  dN2d1 = 0.25*psi(2)*(1+eta(2)*etapg);
  dN2d2 = 0.25*eta(2)*(1+psi(2)*psipg);

  dN3d1 = 0.25*psi(3)*(1+eta(3)*etapg);
  dN3d2 = 0.25*eta(3)*(1+psi(3)*psipg);

  dN4d1 = 0.25*psi(4)*(1+eta(4)*etapg);
  dN4d2 = 0.25*eta(4)*(1+psi(4)*psipg);

  % Calculo de las componentes del tensor metrico
  %
  %        dx/dpsi        dx/deta
  %        dy/dpsi        dy/deta
  %

  dxdpsi = x1.*dN1d1+x2.*dN2d1+x3.*dN3d1+x4.*dN4d1;
  dxdeta = x1.*dN1d2+x2.*dN2d2+x3.*dN3d2+x4.*dN4d2;

  dydpsi = y1.*dN1d1+y2.*dN2d1+y3.*dN3d1+y4.*dN4d1;
  dydeta = y1.*dN1d2+y2.*dN2d2+y3.*dN3d2+y4.*dN4d2;

  Jaco = dxdpsi.*dydeta-dxdeta.*dydpsi;

  dpsidx = dydeta  ./ Jaco ;
  detady = dxdpsi  ./ Jaco ;
  dpsidy = -dxdeta ./ Jaco ;
  detadx = -dydpsi ./ Jaco ;

  X2S = [dpsidx dpsidy detadx detady];
  S2X = [dxdpsi dxdeta dydpsi dydeta];

  elseif nen==3,

  % Calculo jacobiano transformacion al elemento master
  %--------------------------------------------------------

  xs = v2m(xnod(icone,1),nele);
  x1 = xs(1,:)';
  x2 = xs(2,:)';
  x3 = xs(3,:)';
  ys = v2m(xnod(icone,2),nele);
  y1 = ys(1,:)';
  y2 = ys(2,:)';
  y3 = ys(3,:)';

  % Calculo de las derivadas de las funciones de forma
  % respecto a cada direccion del elemento master
  %                dN_j/dpsi_k

  dN1d1 = -1;
  dN1d2 = -1;

  dN2d1 = +1;
  dN2d2 =  0;

  dN3d1 =  0;
  dN3d2 = +1;

  % Calculo de las componentes del tensor metrico
  %
  %        dx/dpsi        dx/deta
  %        dy/dpsi        dy/deta
  %

  dxdpsi = x1*dN1d1+x2*dN2d1+x3*dN3d1;
  dxdeta = x1*dN1d2+x2*dN2d2+x3*dN3d2;

  dydpsi = y1*dN1d1+y2*dN2d1+y3*dN3d1;
  dydeta = y1*dN1d2+y2*dN2d2+y3*dN3d2;

  Jaco = dxdpsi.*dydeta-dxdeta.*dydpsi;

  dpsidx = dydeta  ./ Jaco ;
  detady = dxdpsi  ./ Jaco ;
  dpsidy = -dxdeta ./ Jaco ;
  detadx = -dydpsi ./ Jaco ;

  X2S = [dpsidx dpsidy detadx detady];
  S2X = [dxdpsi dxdeta dydpsi dydeta];

  else
    error(' ** ERROR ** , Routine XY2ST , Bad type of element')
  end

end % if ndm
