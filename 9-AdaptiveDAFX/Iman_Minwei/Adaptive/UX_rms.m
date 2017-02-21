% Author: Verfaille, Arfib, Keiler, Zölzer
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

clear; clf
%----- USER DATA -----
[DAFx_in, FS]  = wavread('x1.wav');
hop            = 256;  % hop size between two FFTs
WLen           = 1024; % length of the windows
w              = hanningz(WLen);
%----- some initializations -----
WLen2          = WLen/2;
normW          = norm(w,2);
pft            = 1;
lf             = floor((length(DAFx_in) - WLen)/hop);
feature_rms    = zeros(lf,1);
tic
%===========================================
pin  = 0;
pend = length(DAFx_in) - WLen;

while pin<pend
   grain = DAFx_in(pin+1:pin+WLen).* w;
   feature_rms(pft) = norm(grain,2) / normW;
   pft   = pft + 1;
   pin   = pin + hop;
end
% ===========================================
toc
subplot(2,2,1); plot(DAFx_in); axis([1 pend -1 1])
subplot(2,2,2); plot(feature_rms); axis([1 lf -1 1])