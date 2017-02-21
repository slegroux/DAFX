function y = cryBaby(x,Fs,pedalVal,gainDM)

PI = 3.14159;

g = 0.1*(gainDM^pedalVal); % overall gain for second-order s-plane transfer funct.
fr = 450*2^(2.3*pedalVal); % resonance frequency (Hz) for the same transfer funct.
Q = 2^(2*(1-pedalVal)+1); % resonance quality factor for the same transfer funct.

frn = fr/Fs;
R = 1 - PI*frn/Q; % pole radius
theta = 2*PI*frn; % pole angle
a(1) = 1;
a(2) = -2.0*R*cos(theta); % biquad coeff
a(3) = R*R; % biquad coeff
y = g*filter(1,a,x);