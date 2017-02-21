% FREQUENCY MODULATION


sf = 22050;                    % sample rate
d = 2.0;                       % duration 
n = sf * d;                    % num samples


cf = 1000;                     % carrier freq
c = (1:n) / sf;                % carrier setup
c = 2 * pi * cf * c;


mf = 325;                      % mod freq
mi = 0.5;                      % mod index
m = (1:n) / sf;                % mod setup
m = mi * cos(2 * pi * mf * m); % sin mod


s = sin(c + m);                % freq mod
 
sound(s, sf);                                

% adapted from http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html