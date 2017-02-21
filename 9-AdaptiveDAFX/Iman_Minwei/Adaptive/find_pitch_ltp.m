function [M,Fp] = find_pitch_ltp(xp, lmin, lmax, Nblock, Fs, b0_thres)
% function [M,Fp] = find_pitch_ltp(xp, lmin, lmax, Nblock, Fs, b0_thres)
%    [DAFXbook, 2nd ed., chapter 9]
%===== This function computes the pitch lag candidates from a signal block
%
%  Inputs:
%      xp      : input block including lmax pre-samples 
%                for correct autocorrelation
%      lmin    : min. checked pitch lag
%      lmax    : max. checked pitch lag
%      Nblock  : block length without pre-samples
%      Fs      : sampling freq.
%      b0_thres: max b0 deviation from 1
%
%  Outputs:
%    M: pitch lags
%    Fp: pitch frequencies
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

lags  = lmin:lmax;        % tested lag range
Nlag  = length(lags);     % no. of lags
[rxx_norm, rxx, rxx0] = xcorr_norm(xp, lmin, lmax, Nblock);

%----- calc. autocorr sequences -----
B0    = rxx./rxx0;        % LTP coeffs for all lags
idx   = find_loc_max(rxx_norm);
i     = find(rxx(idx)>0); % only max. where r_xx>0
idx   = idx(i);           % indices of maxima candidates
i     = find(abs(B0(idx)-1)<b0_thres);

%----- only max. where LTP coeff is close to 1 -----
idx   = idx(i);           % indices of maxima candidates

%----- vectors for all pitch candidates: -----
M     = lags(idx);
M     = M(:);             % pitch lags
Fp    = Fs./M;
Fp    = Fp(:);            % pitch freqs
