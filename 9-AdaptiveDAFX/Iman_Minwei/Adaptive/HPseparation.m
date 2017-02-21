% Author: Derry FitzGerald
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

%----- user data -----
WLen            =4096;
hopsize         =1024;
lh              =17; % length of the harmonic median filter
lp              =17; % length of the percussive median filter
p               =2;
w1              =hanning(WLen,'periodic');
w2              =w1;
hlh             =floor(lh/2)+1;
th              =2500;
[DAFx_in, FS]   =wavread('filename');

L               = length(DAFx_in);
DAFx_in         = [zeros(WLen, 1); DAFx_in; ...
   zeros(WLen-mod(L,hopsize),1)] / max(abs(DAFx_in));
DAFx_out1 = zeros(length(DAFx_in),1);
DAFx_out2 = zeros(length(DAFx_in),1);
 
%----- initialisations -----
grain           = zeros(WLen,1);
buffer          = zeros(WLen,lh);
buffercomplex   = zeros(WLen,lh);
oldperframe     = zeros(WLen,1);
onall         = [];
onperc        = [];
 
tic
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
pin  = 0;
pout = 0;
pend = length(DAFx_in)-WLen;
 
while pin<pend
    grain = DAFx_in(pin+1:pin+WLen).* w1;
%===========================================
    fc  = fft(fftshift(grain));
    fa  = abs(fc);
    % remove oldest frame from buffers and add
    % current frame to buffers
    buffercomplex(:,1:lh-1)=buffercomplex(:,2:end);
    buffercomplex(:,lh)=fc;
    buffer(:,1:lh-1)=buffer(:,2:end);
    buffer(:,lh)=fa;
    % do median filtering within frame to suppress harmonic instruments
    Per = medfilt1(buffer(:,hlh),lp);
    % do median filtering on buffer to suppress percussion instruments
    Har = median(buffer,2);
    % use these Percussion and Harmonic enhanced frames to generate masks
    maskHar = (Har.^p)./(Har.^p + Per.^p);
    maskPer = (Per.^p)./(Har.^p + Per.^p);
    % apply masks to middle frame in buffer
    % Note: this is the "current" frame from the point of view of the median
    % filtering
    curframe=buffercomplex(:,hlh);
    perframe=curframe.*maskPer;
    harframe=curframe.*maskHar;
    grain1 = fftshift(real(ifft(perframe))).*w2;
    grain2 = fftshift(real(ifft(harframe))).*w2;
    % onset detection functions
    % difference of frames
    dall=buffer(:,hlh)-buffer(:,hlh-1);
    dperc=abs(perframe)-oldperframe;
    oall=sum(dall>0);
    operc=sum(dperc>0);
    onall = [onall oall];
    onperc = [onperc operc];
    oldperframe=abs(perframe);
%===========================================
    DAFx_out1(pout+1:pout+WLen) = ...
       DAFx_out1(pout+1:pout+WLen) + grain1;
   DAFx_out2(pout+1:pout+WLen) = ...
       DAFx_out2(pout+1:pout+WLen) + grain2;
    pin  = pin + hopsize;
    pout = pout + hopsize;
end
%UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
toc
% process onset detection function to get beats
[or,oc]=size(onall);
omin=min(onall);
% get peaks 
v1 = (onall > [omin, onall(1:(oc-1))]);
% allow for greater-than-or-equal 
v2 = (onall >= [onall(2:oc), omin]);
% simple Beat tracking function
omax = onall .* (onall > th).* v1 .* v2;
% now do the same for the percussion onset detection function
% process onset detection function to get beats
[opr,opc]=size(onperc);
opmin=min(onperc);
% get peaks 
p1 = (onperc > [opmin, onperc(1:(opc-1))]);
% allow for greater-than-or-equal 
p2 = (onperc >= [onperc(2:opc), opmin]);
% simple Beat tracking function
opmax = onperc .* (onperc > th).* p1 .* p2;
%----- listening and saving the output -----
DAFx_out1 = DAFx_out1((WLen + hopsize*(hlh-1)) ...
		:length(DAFx_out1))/max(abs(DAFx_out1));
DAFx_out2 = DAFx_out2(WLen + (hopsize*(hlh-1)) ...
		:length(DAFx_out2))/max(abs(DAFx_out2));
% soundsc(DAFx_out1, FS);
% soundsc(DAFx_out2, FS);
wavwrite(DAFx_out1, FS, 'ex-percussion.wav');
wavwrite(DAFx_out2, FS, 'ex-harmonic.wav');