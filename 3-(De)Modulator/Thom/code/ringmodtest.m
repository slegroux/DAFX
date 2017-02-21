[inwave, fs] = wavread('moore_guitar');

sound(ringmod(inwave, 925.0, fs), fs);
