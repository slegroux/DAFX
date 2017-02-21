function plot_split(idx, t, x)
% function plot_split(idx, t, x)  [DAFXbook, 2nd ed., chapter 9]
%===== This function plots the segmented pitch curve
%  Inputs: 
%    idx: vector with positions of vector x to be plotted
%    t: time indexes
%    x is segmented into parts
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

di=diff(idx);
L=length(di);

n0=1;
pos_di=find(di>1);
ii=1; % counter for pos_di

hold off
while ii<=length(pos_di) %n0<=length(x)
  n1=pos_di(ii);
  plot(t(idx(n0:n1)),x(idx(n0:n1)))
  hold on
  n0=n1+1;
  ii=ii+1;
end  

n1=length(idx);
plot(t(idx(n0:n1)),x(idx(n0:n1)))
hold off