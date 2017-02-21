% UX_voiced.m
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------


% feature_voice is a measure of the maximum of the second peak
% of the acf
function [feature_voiced]=UX_voiced(DAFx_in,Fs)
%----- USER DATA -----
% [DAFx_in, FS]  = wavread('trumpt44.wav');
hop            = 256;  % hop size between two FFTs
WLen           = 1024; % length of the windows
w              = hanningz(WLen);
%----- some initializations -----
WLen2          = WLen/2;
tx             = (1:WLen2+1)';
normW          = norm(w,2);
coef           = (WLen/(2*pi));
pft            = 1;
lf             = floor((length(DAFx_in) - WLen)/hop);
feature_voiced = zeros(lf,1);
tic
%===========================================
pin  = 0;
pend = length(DAFx_in) - WLen;

while pin<pend
   grain    = DAFx_in(pin+1:pin+WLen).* w;
   f        = fft(grain)/WLen2;
   f2       = real(ifft(abs(f)));
   f2       = f2/f2(1);
   [v,i1]   = min(f2(1:WLen2)>0.);
   f2(1:i1) = zeros(i1,1);
   [v,imax] = max(f2(1:WLen2));
   feature_voiced(pft) = v;
   pft      = pft + 1;
   pin      = pin + hop;
end
% ===========================================
% toc
% subplot(2,1,1)
% plot(feature_voiced)
end