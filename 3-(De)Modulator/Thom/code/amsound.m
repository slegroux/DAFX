% AMPLITUDE MODULATION


sf = 22050;                        % sample rate
d = 1.0;                           % duration
n = sf * d;                        % num samples


cf = 1000;                         % carrier freq
c = (1:n) / sf;                    % carrier setup 
c = sin(2 * pi * cf * c);          % sin mod


mf = 5;                            % mod freq
mi = 0.5;                          % mod index
m = (1:n) / sf;                    % mod setup 
m = 1 + mi * sin(2 * pi * mf * m); % sin mod


s = inwave(0) .* c;                % amp mod

sound(s, sf);                     

% adapted from http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html