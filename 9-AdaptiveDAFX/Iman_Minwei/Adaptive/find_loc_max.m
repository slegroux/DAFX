function [idx, idx0] = find_loc_max(x)
% [DAFXbook, 2nd ed., chapter 9]
%=====  This function finds local maxima in vector x
%  Inputs:
%    x: any vector
%  Outputs:
%    idx : positions of local max.
%    idx0: positions of local max. with 2 identical values
%    if only 1 return value: positions of all maxima
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

N    = length(x);
dx   = diff(x);            % derivation
                           % to find sign changes from + to -
dx1  = dx(2:N-1);
dx2  = dx(1:N-2);
prod = dx1.*dx2;
idx1 = find(prod<0);       % sign change in dx1
idx2 = find(dx1(idx1)<0);  % only change from + to -
idx  = idx1(idx2)+1;       % positions of single maxima
%----- zeros in dx? => maxima with 2 identical values -----
idx3 = find(dx==0);
idx4 = find(x(idx3)>0);    % only maxima
idx0 = idx3(idx4);
%----- positions of double maxima, same values at idx3(idx4)+1 -----
if nargout==1              % output 1 vector 
                           % with positions of all maxima
   idx = sort([idx,idx0]); % (for double max. only 1st position)
end