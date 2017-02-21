% Author: Verfaille, Arfib, Keiler, Z¨olzer
clear; clf
%----- USER DATA -----
[DAFx_in, FS] = wavread('x1.wav');
hop = 256; % hop size between two FFTs
WLen = 256; % length of the windows
w=hanning(WLen);
%----- some initializations -----
WLen2 = WLen/2;
normW = norm(w,2);
pft = 1;
lf = floor((length(DAFx_in) - WLen)/hop);
feature_rms = zeros(lf,1);
tic
%===========================================
pin = 0;
pend = length(DAFx_in) - WLen;
while pin<pend
grain = DAFx_in(pin+1:pin+WLen).* w;
feature_rms(pft) = norm(grain,2) / normW;
pft = pft + 1;
pin = pin + hop;
end
% ===========================================
toc
subplot(2,1,1); plot(DAFx_in); axis([1 pend -1 1])
subplot(2,1,2); plot(feature_rms); axis([1 lf -1 1])