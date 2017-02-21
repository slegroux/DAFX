
function output_signal = ringmod(input_signal, carrier_freq, fs)

    len = 1:length(input_signal);

    carrier= sin(2*pi*len*(carrier_freq/fs))';

    output_signal = input_signal.*carrier;

end
