function [FFTidx, Fp_est, Fp_corr] = ...
find_pitch_fft(x, win, Nfft, Fs, R, fmin, fmax, thres)
% [DAFXbook, 2nd ed., chapter 9]
%===== This function finds pitch candidates
%
% Inputs:
%   x: input signal of length Nfft+R
%   win: window for the FFT
%   Nfft: FFT length
%   Fs: sampling frequency
%   R: FFT hop size
%   fmin, fmax: minumum/ maximum pitch freqs to be detected
%   thres: %omit maxima more than thres dB below the main peak
% Outputs:
%   FFTidx: FFT indices
%   Fp_est: FFT bin frequencies
%   Fp_corr: corrected frequencies
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

FFTidx  = [];
Fp_est  = [];
Fp_corr = [];
dt      = R/Fs;          % time diff between FFTs
df      = Fs/Nfft;       % freq resolution
kp_min  = round(fmin/df);
kp_max  = round(fmax/df);
x1      = x(1:Nfft);     % 1st block
x2      = x((1:Nfft)+R); % 2nd block with hop size R
[X1, Phi1] = fftdb(x1.*win,Nfft);
[X2, Phi2] = fftdb(x2.*win,Nfft);
X1      = X1(1:kp_max+1); 
Phi1    = Phi1(1:kp_max+1);
X2      = X2(1:kp_max+1); 
Phi2    = Phi2(1:kp_max+1);
idx     = find_loc_max(X1);
Max     = max(X1(idx));
ii      = find(X1(idx)-Max>-thres);

%----- omit maxima more than thres dB below the main peak -----
idx     = idx(ii);
Nidx    = length(idx);   % number of detected maxima
maxerr  = R/Nfft;        % max phase diff error/pi 
                         % (pitch max. 0.5 bins wrong)
maxerr  = maxerr*1.2;    % some tolerance
for ii=1:Nidx
   k        = idx(ii) - 1;          % FFT bin with maximum
   phi1     = Phi1(k+1);            % phase of x1 in [-pi,pi]
   phi2_t   = phi1 + 2*pi/Nfft*k*R; % expected target phase 
                                    % after hop size R
   phi2     = Phi2(k+1);            % phase of x2 in [-pi,pi]
   phi2_err = princarg(phi2-phi2_t);
   phi2_unwrap = phi2_t+phi2_err;
   dphi     = phi2_unwrap - phi1;   % phase diff
   if (k>kp_min) & (abs(phi2_err)/pi<maxerr)
      Fp_corr = [Fp_corr; dphi/(2*pi*dt)];
      FFTidx  = [FFTidx; k];
      Fp_est  = [Fp_est; k*df];
   end
end
