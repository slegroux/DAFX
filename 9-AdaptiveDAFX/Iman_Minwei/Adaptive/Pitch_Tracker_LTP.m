% Pitch_Tracker_LTP.m    [DAFXbook, 2nd ed., chapter 9]
%===== This function demonstrates a pitch tracker based 
%===== on the Long-Term Prediction 
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------
function [p2]=Pitch_Tracker_LTP(X,Fs)

%----- initializations -----
%fname='trumpt44';
n0=2000; % start index
n1=length(X)-1000;
K=200;   % hop size for time resolution of pitch estimation
N=1024;  % block length
% checked pitch range in Hz:
fmin=50;
fmax=1200;
b0_thres=.2;      % threshold for LTP coeff
p_fac_thres=1.05; % threshold for voiced detection
                  % deviation of pitch from mean value   

%[xin,Fs]=wavread(fname,[n0 n0]); %get Fs
% lag range in samples:
lmin=floor(Fs/fmax);
lmax=ceil(Fs/fmin);
pre=lmax;   % number of pre-samples
if n0-pre<1
  n0=pre+1;
end  
Nx=n1-n0+1; % signal length
blocks=floor(Nx/K);
Nx=(blocks-1)*K+N;
%[X,Fs]=wavread(fname,[n0-pre n0+Nx]);
X=X(:,1)';

pitches=zeros(1,blocks);
for b=1:blocks
  x=X((b-1)*K+(1:N+pre));
  [M, F0]=find_pitch_ltp(x, lmin, lmax, N, Fs, b0_thres);
  if ~isempty(M)
    pitches(b)=Fs/M(1); % take candidate with lowest pitch
  else
    pitches(b)=0;
  end  
end

%----- post-processing -----
L=9;             % number of blocks for mean calculation
if mod(L,2)==0   % L is even
  L=L+1;
end  
D=(L-1)/2;       % delay
h=ones(1,L)./L;  % impulse response for mean calculation
% mirror start and end for "non-causal" filtering:
p=[pitches(D+1:-1:2), pitches, pitches(blocks-1:-1:blocks-D)];
y=conv(p,h);          % length: blocks+2D+2D
pm=y((1:blocks)+2*D); % cut result

Fac=zeros(1,blocks); 
idx=find(pm~=0); % don't divide by zero
Fac(idx)=pitches(idx)./pm(idx);
ii=find(Fac<1 & Fac~=0);
Fac(ii)=1./Fac(ii); % all non-zero element are now > 1
% voiced/unvoiced detection:
voiced=Fac~=0 & Fac<p_fac_thres;

T=40;                 % time in ms for segment lengths
M=round(T/1000*Fs/K); % min. number of blocks in a row
[V,p2]=segmentation(voiced, M, pitches);
p2=V.*p2;  % set pitches to zero for unvoiced 

figure(1),clf;
time=(0:blocks-1)*K+1; % start sample of blocks
time=time/Fs;          % time in seconds
t=(0:length(X)-1)/Fs;  % time in sec for original
subplot(211)
plot(t, X),title('original x(n)');
axis([0 max([t,time]) -1.1*max(abs(X)) 1.1*max(abs(X))])

subplot(212)
idx=find(p2~=0);
plot_split(idx,time, p2),title('pitch in Hz');
xlabel('time/s \rightarrow');
axis([0 max([t,time]) .9*min(p2(idx)) 1.1*max(p2(idx))])

end