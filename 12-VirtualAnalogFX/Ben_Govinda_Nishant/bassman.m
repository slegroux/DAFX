function [y,B,A] = bassman(low, mid, top, Fs, x)
% function [y,B0,B1,B2,B3,A0,A1,A2,A3] = bassman(low, mid, top, x)
% Authors: V¨alim¨aki, Bilbao, Smith, Abel, Pakarinen, Berners
%
% Parameters:
% low = bass level
% mid = noise level
% top = treble level
% x = input signal

% Component values
C1 = 0.25*10^-9;
C2 = 20*10^-9;
C3 = 20*10^-9; 
R1 = 250000;
R2 = 1000000;
R3 = 25000;
R4 = 56000;

% Analog transfer function coefficients:
b1 = top*C1*R1 + mid*C3*R3 + low*(C1*R2 + C2*R2) + (C1*R3 + C2*R3);
b2 = top*(C1*C2*R1*R4 + C1*C3*R1*R4) - mid^2*(C1*C3*R3^2 + C2*C3*R3^2) + mid*(C1*C3*R1*R3 + C1*C3*R3^2 + C2*C3*R3^2)+ low*(C1*C2*R1*R2 + C1*C2*R2*R4 + C1*C3*R2*R4) + low*mid*(C1*C3*R2*R3 + C2*C3*R2*R3) + (C1*C2*R1*R3 + C1*C2*R3*R4 + C1*C3*R3*R4);
b3 = low*mid*(C1*C2*C3*R1*R2*R3 + C1*C2*C3*R2*R3*R4) - mid^2*(C1*C2*C3*R1*R3^2 + C1*C2*C3*R3^2*R4)+ mid*(C1*C2*C3*R1*R3^2 + C1*C2*C3*R3^2*R4) + top*C1*C2*C3*R1*R3*R4 - top*mid*C1*C2*C3*R1*R3*R4 + top*low*C1*C2*C3*R1*R2*R4;
a0 = 1;
a1 = (C1*R1 + C1*R3 + C2*R3 + C2*R4 + C3*R4) + mid*C3*R3 + low*(C1*R2 + C2*R2);
a2 = mid*(C1*C3*R1*R3 - C2*C3*R3*R4 + C1*C3*R3^2 + C2*C3*R3^2) + low*mid*(C1*C3*R2*R3 + C2*C3*R2*R3) - mid^2*(C1*C3*R3^2 + C2*C3*R3^2) + low*(C1*C2*R2*R4 + C1*C2*R1*R2 + C1*C3*R2*R4 + C2*C3*R2*R4) + (C1*C2*R1*R4 + C1*C3*R1*R4 + C1*C2*R3*R4 + C1*C2*R1*R3 + C1*C3*R3*R4 + C2*C3*R3*R4);
a3 = low*mid*(C1*C2*C3*R1*R2*R3 + C1*C2*C3*R2*R3*R4) - mid^2*(C1*C2*C3*R1*R3^2 + C1*C2*C3*R3^2*R4) + mid*(C1*C2*C3*R3^2*R4 + C1*C2*C3*R1*R3^2 - C1*C2*C3*R1*R3*R4) + low*C1*C2*C3*R1*R2*R4 + C1*C2*C3*R1*R3*R4;

% Digital filter coefficients:
c = 2*Fs;
B(1) = -b1*c - b2*c^2 - b3*c^3; 
B(2) = -b1*c + b2*c^2 + 3*b3*c^3;
B(3) = b1*c + b2*c^2 - 3*b3*c^3; 
B(4) = b1*c - b2*c^2 + b3*c^3;
A(1) = -a0 - a1*c - a2*c^2 - a3*c^3;
A(2) = -3*a0 - a1*c + a2*c^2 + 3*a3*c^3;
A(3) = -3*a0 + a1*c + a2*c^2 - 3*a3*c^3;
A(4) = -a0 + a1*c - a2*c^2 + a3*c^3;

% Output signal
y = filter(B,A,x);