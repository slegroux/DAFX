function y=lagtun(x,b)

N=length(x);
M=N*(1+abs(b))/(1-abs(b));
x=x(N:-1:1); % time reverse input
% filter by normalizing filter lambda_0
yy=x;
y(1)=yy(N); % retain the last sample only
for k=2:M
% filter the previous output by allpass
yy=filter([b,1],[1,b],yy);
y(k)=yy(N); % retain the last sample only
end

