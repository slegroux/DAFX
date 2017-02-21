% UX_centroid.m
% [DAFXbook, 2nd ed., chapter 9]
% feature_centroid1 and 2 are centroids
% calculate by two different methods
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

function [feature_rms,feature_centroid, feature_centroid2, feature_deriv] = UX_centroid(DAFx_in,FS)
%----- USER DATA -----
%[DAFx_in, FS]  = wavread('trumpt44.wav');
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
feature_rms    = zeros(lf,1);
feature_centroid  = zeros(lf,1);
feature_centroid2 = zeros(lf,1);
tic
%===========================================
pin  = 0;
pend = length(DAFx_in) - WLen;

while pin<pend
   grain                  = DAFx_in(pin+1:pin+WLen).* w;
   feature_rms(pft)       = norm(grain,2) / normW;
   f                      = fft(grain)/WLen2;
   fx                     = abs(f(tx));
   feature_centroid(pft)  = sum(fx.*(tx-1)) / sum(fx);
   fx2                    = fx.*fx;
   feature_centroid2(pft) = sum(fx2.*(tx-1)) / sum(fx2);
   grain2                 = diff(DAFx_in(pin+1:pin+WLen+1)).* w;
   feature_deriv(pft)     = coef * norm(grain2,2) / norm(grain,2);
   pft                    = pft + 1;
   pin                    = pin + hop;
end
% ===========================================
% toc
% subplot(4,1,1); plot(feature_rms); xlabel('RMS')
% subplot(4,1,2); plot(feature_centroid); xlabel('centroid 1')
% subplot(4,1,3); plot(feature_centroid2); xlabel('centroid 2')
% subplot(4,1,4); plot(feature_deriv); xlabel('centroid 3')
end