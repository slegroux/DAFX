function sfw=winlagt(s,b,Nw,L)
% Author: G. Evangelista
% Frequency warping via STLT of the signal s with parameter b,
% output window length Nw and time-shift L
w=L*(1-cos(2*pi*(0:Nw-1)/Nw))/Nw; % normalized Hanning window
N=ceil(Nw*(1-b)/(1+b)); % length of unwarped window h
M=round(L*(1-b)/(1+b)); % time-domain window shift
h=lagtun(w,-b); h=h(:); % unwarped window
%zzz=length(h)
Ls=length(s); % pad signal with zeros
K=ceil((Ls-N)/M); % to fit an entire number
s=s(:); %s=[s ; zeros(N+K\ast M-Ls,1)]; % of windows
Ti=1; To=1; % initialize I/O pointers
Q=ceil(N*(1+abs(b))/(1-abs(b))); % length of Laguerre transform
sss=zeros(500000,1); % initialize output signal
for k=1:800
%aaa=length(s(Ti:Ti+1193))
%bbb=length(h)
yy=lagt(s(Ti:Ti+1193).*h,b); % Short-time Laguerre transf
yy=yy(:);
sss(To:To+513)=sss(To:To+513)+yy(1:1+513); % overlap-add STLT
Ti=Ti+M;
To=To+L; % advance I/O signal pointers
%sss=[sss; zeros(L,1)]; % zero pad for overlap-add
end

sfw=sss;