
f = @(x, y) x+1+y;
f(1)
z = 1
typeinfo(z) % ans = scalar
class(z) % ans = double

class(f)

x = ones(3);
y = [1 2 3];

y.*x

x = [1 2 3];
y = [1 3 5]';
z = y.*x
z = x.*y

z = x*y'
% s  s s s
f = @(x)[x.*(x-1)*0.5];
f([1 2 3])


S = sparse(zeros(4));
for i = 1:3
  S([i i+1], [i i+1]) += ones(2)
endfor


is_f = sum(class(f) == 'function_handle') > 1;
typeinfo(f)

xn = -1:0.1:1;
f = @(x) [x.*(x-1)*0.5; (1+x).*(1-x); x.*(x+1)*0.5];
hold on;
plot (xn, f(xn)(1, :))
plot (xn, f(xn)(2, :))
plot (xn, f(xn)(3, :))

xn = -1:0.1:1;
f = @(x) [x.*(x-1)*0.5, (1+x).*(1-x), x.*(x+1)*0.5];
hold on;
f(1:3)
plot (xn, f(xn)(1, :))
plot (xn, f(xn)(2, :))
plot (xn, f(xn)(3, :))

M = [1 2 3; 4 5 6; 7 8 9];

sparse(ones(3))
sparse([1 2 2 2], [1 2 2 2], [1 2 3 4])

if 0
   14
endif

