
function y=lagtbvar(x,b,M)
% computes coefficients y of biorthogonal Laguerre expansion of x
% using variable parameters b(k) where b is a length M array N=length(x);
yy=x(N:-1:1);
y=zeros(1,M);
yy=filter(1,[1, b(1)],yy);
y(1)=yy(N);
% filter by H_1(z)(unscaled, b to -b)
yy=filter([0,1],[1, b(2)],yy);
y(2)=yy(N)*(1-b(1)*b(2));

% filter by H_(k-1)(z)(unscaled, b to -b)
yy=filter([b(k-2),1],[1, b(k)],yy);
y(k)=yy(N)*(1-b(k-1)*b(k)); 
end
