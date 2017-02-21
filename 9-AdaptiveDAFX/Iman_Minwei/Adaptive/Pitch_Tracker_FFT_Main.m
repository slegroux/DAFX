% Pitch_Tracker_FFT_Main.m    [DAFXbook, 2nd ed., chapter 9]
%===== This function demonstrates a pitch tracking algorithm 
%===== in a block-based implementation
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

function p2 = Pitch_Tracker_FFT_Main(X,Fs)
%----- initializations -----
n0=1; %start index
n1=length(X)-1000;

Nfft=1024;
R=1;      % FFT hop size for pitch estimation
K=200;    % hop size for time resolution of pitch estimation
thres=50; % threshold for FFT maxima
% checked pitch range in Hz:
fmin=50;
fmax=1200;
p_fac_thres=1.05;  % threshold for voiced detection
                   % deviation of pitch from mean value   
win=hanning(Nfft)';% window for FFT
Nx=n1-n0+1+R;      % signal length
blocks=floor(Nx/K);
Nx=(blocks-1)*K+Nfft+R;
n1=n0+Nx;          % new end index
X=X(n0:n1);
X=X(:,1)';

%----- pitch extraction per block -----
pitches=zeros(1,blocks);
for b=1:blocks
  x=X((b-1)*K+1+(1:Nfft+R));
  [FFTidx, F0_est, F0_corr]= ...
     find_pitch_fft(x,win,Nfft,Fs,R,fmin,fmax,thres);  
  if ~isempty(F0_corr)
    pitches(b)=F0_corr(1); % take candidate with lowest pitch
  else
    pitches(b)=0;
  end  
end
%----- post-processing -----
L=9;             % odd number of blocks for mean calculation
D=(L-1)/2;       % delay
h=ones(1,L)./L;  % impulse response for mean calculation
%----- mirror beginning and end for "non-causal" filtering -----
p=[pitches(D+1:-1:2),pitches,pitches(blocks-1:-1:blocks-D)]; 
y=conv(p,h);          % length: blocks+2D+2D
pm=y((1:blocks)+2*D); % cut result

Fac=zeros(1,blocks); 
idx=find(pm~=0);      % don't divide by zero
Fac(idx)=pitches(idx)./pm(idx);
ii=find(Fac<1 & Fac~=0);
Fac(ii)=1./Fac(ii);   % all non-zero elements are now > 1
%----- voiced/unvoiced detection -----
voiced=Fac~=0 & Fac<p_fac_thres;

T=40;                 % time in ms for segment lengths
M=round(T/1000*Fs/K); % min. number of consecutive blocks 
[V,p2]=segmentation(voiced, M, pitches);
p2=V.*p2;             % set pitches to zero for unvoiced 

%----- plotting and drawing figure -----
% figure(1),clf,
% time=(0:blocks-1)*K+1; % start sample of blocks
% time=time/Fs;          % time in seconds
% t=(0:length(X)-1)/Fs;  % time in sec for original
% subplot(211)
% plot(t,X),title('original x(n)')
% axis([0 max([t,time]) -1.1*max(abs(X)) 1.1*max(abs(X))])
% subplot(212)
% idx=find(p2~=0);
% plot_split(idx,time, p2),title('pitch in Hz');
% xlabel('time/s \rightarrow');
% axis([0 max([t,time]) .9*min(p2(idx)) 1.1*max(p2(idx))])
