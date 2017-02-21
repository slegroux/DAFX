function w = hanningz(n)
%HANNINGZ(N) returns the N-point Hanning window in a column vector.

w = .5*(1 - cos(2*pi*(0:n-1)'/(n)));

