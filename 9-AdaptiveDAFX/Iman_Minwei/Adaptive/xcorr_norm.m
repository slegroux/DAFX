function [rxx_norm, rxx, rxx0] = xcorr_norm(xp, lmin, lmax, Nblock)
% function [rxx_norm, rxx, rxx0] = xcorr_norm(xp, lmin, lmax, Nblock)
%    [DAFXbook, 2nd ed., chapter 9]
%===== This function computes the normalized autocorrelation
%  Inputs: 
%    xp: input block
%    lmin: min of tested lag range
%    lmax: max of tested lag range
%    Nblock: block size
%
%  Outputs:
%    rxx_norm: normalized autocorr. sequence
%    rxx: autocorr. sequence
%    rxx0: energy of delayed blocks
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

%----- initializations -----
x        = xp((1:Nblock)+lmax); % input block without pre-samples
lags     = lmin:lmax;           % tested lag range
Nlag     = length(lags);        % no. of lags

%----- empty output variables -----
rxx      = zeros(1,Nlag);
rxx0     = zeros(1,Nlag);
rxx_norm = zeros(1,Nlag);

%----- computes autocorrelation(s) -----
for l=1:Nlag
   ii      = lags(l);           % tested lag
   rxx0(l) = sum(xp((1:Nblock)+lmax-lags(l)).^2);
   %----- energy of delayed block
   rxx(l)  = sum(x.*xp((1:Nblock)+lmax-lags(l)));
end
rxx_norm=rxx.^2./rxx0;          % normalized autocorr. sequence