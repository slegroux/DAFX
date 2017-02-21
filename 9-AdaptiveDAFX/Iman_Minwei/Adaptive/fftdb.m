function [H, phi]  = fftdb(x, Nfft)
% [DAFXbook, 2nd ed., chapter 9]
%===== This function discards values in FFT bins for which magnitude > thresh
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

if nargin<2
  Nfft = length(x);
end

F      = fft(x,Nfft);
F      = F(1:Nfft/2+1);       % f=0,..,Fs/2
phi    = angle(F);            % phase in [-pi,pi]
F      = abs(F)/Nfft*2;       % normalize to FFT length
%----- return -100 db for F==0 to avoid "log of zero" warnings -----
H      = -100*ones(size(F));
idx    = find(F~=0);
H(idx) = 20*log10(F(idx));    % non-zero values in dB
