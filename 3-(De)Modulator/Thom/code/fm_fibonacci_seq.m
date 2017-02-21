% FREQUENCY MODULATION (Fibonacci-valued modulation frequencies)
     

modfreqs = [2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946];



sf = 22050;                    % sample rate
d = 0.8;                       % duration
n = sf * d;                    % num samples

cf = 1000;                     % carrier freq
c_ = (1:n) / sf;               % carrier setup

mi = 0.5;                      % mod index


for k=1:length(modfreqs)
   
    m = (1:n) / sf;                % mod setup
    mf = modfreqs(k);              % mod freq
    
    
    % FM
    c = 2 * pi * cf * c_;          % sin mod 
    m = mi * cos(2 * pi * mf * m); % sin mod 
    s = sin(c + m);                % freq mod 
    
    sound(s, sf);                 
    
end

% adapted from http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html