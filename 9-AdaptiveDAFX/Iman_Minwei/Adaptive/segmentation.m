function [V,pitches2] = segmentation(voiced, M, pitches)    
% function [V,pitches2] = segmentation(voiced, M, pitches)
%    [DAFXbook, 2nd ed., chapter 9]
%===== This function implements the pitch segmentation
% 
%  Inputs:
%    voiced:   original voiced/unvoiced detection
%    M:        min. number of consecutive blocks with same voiced flag
%    pitches:  original pitches
%  Outputs:
%    V:        changed voiced flag
%    pitches2: changed pitches
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

blocks=length(voiced); % get number of blocks
pitches2=pitches;
V=voiced;
Nv=length(V);

%%%%%%%%%%% step1: eliminate too short voiced segments:
V(Nv+1)=~V(Nv);  % change at end to get length of last segment
dv=[0, diff(V)]; % derivative
idx=find(dv~=0); % changes in voiced
di=[idx(1)-1,diff(idx)];  % segment lengths
v0=V(1);         % status of 1st segment
k0=1;   
ii=1; % counter for segments, idx(ii)-1 is end of segment
if v0==0
  k0=idx(1); % start of voiced
  ii=ii+1;   % first change voiced to unvoiced
end  
while ii<=length(idx);
  L=di(ii);
  k1=idx(ii)-1;   % end of voiced segment
  if L<M
     V(k0:k1)=zeros(1,k1-k0+1);
  end
  if ii<length(idx)
    k0=idx(ii+1); % start of next voiced segment
  end
  ii=ii+2;
end

%%%%%%%%%%% step2: eliminate too short unvoiced segments:
V(Nv+1)=~V(Nv);           % one more change at end
dv=[0, diff(V)];
idx=find(dv~=0);          % changes in voiced
di=[idx(1)-1,diff(idx)];  % segment lengths
if length(idx)>1          % changes in V
  v0=V(1);                % status of 1st segment
  k0=1;   
  ii=1;    % counter for segments, idx(ii)-1 is end of segment
  if v0==0
    k0=idx(2); % start of unvoiced
    ii=ii+2;   % first change unvoiced to voiced
  end  
  while ii<=length(idx);
    L=di(ii);
    k1=idx(ii)-1;   % end of unvoiced segment
    if L<M
       if k1<blocks % NOT last unvoiced segment
         V(k0:k1)=ones(1,k1-k0+1);
         % linear pitch interpolation:
         p0=pitches(k0-1);
         p1=pitches(k1+1);
         N=k1-k0+1;
         pitches2(k0:k1)=(1:N)*(p1-p0)/(N+1)+p0;
      end   
    end
    if ii<length(idx)
      k0=idx(ii+1); % start of next unvoiced segment 
    end
    ii=ii+2;
  end
end  

V=V(1:Nv); % cut last element
