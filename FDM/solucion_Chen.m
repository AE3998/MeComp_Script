x = 2.5; y = 4;

xmalla = 0:0.25:5;
pasox = length(xmalla);

pos = (x*pasox*4)+(y*4+1);
PHI(pos, end)

% Binary search manual 
pos = 703;
xnode(pos, :)
PHI(pos, end)

% y = 2.5
trampa = xnode(:, 2) == 2.5;
fy = PHI(trampa, end);
fx = xnode(trampa, 1);
plot(fx, fy);
