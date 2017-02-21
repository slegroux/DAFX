% a function to combine all the feature extraction and plot them
%----- initializations -----
recObj = audiorecorder(44100,16,1);
disp('Start Recording.')
recordblocking(recObj, 5);
disp('End of Recording.');

% Play back the recording.
%play(recObj);

% Store data in double-precision array.c
myRecording = getaudiodata(recObj);
wavwrite(myRecording,44100,'test.wav');

fname='test.wav';
[x,fs]=wavread(fname);

pitchesLTP = Pitch_Tracker_LTP(x,fs);
pitchesYIN = yinDAFX(x,fs,50,200);
pitchesFFT = Pitch_Tracker_FFT_Main(x,fs); 
timbreVoiced = UX_voiced(x,fs);
[timbreRMS, timbreCentroid, timbreCentroid2, timbreDerive] = UX_centroid(x,fs);

% plot the pitch stuff
figure(1), clf;
t=(0:length(x)-1)/fs;  % time in sec for original
subplot(411)
plot(t,x),title('original x(n)')
axis([0 max(t) -1.1*max(abs(x)) 1.1*max(abs(x))])
subplot(412)
idx=find(pitchesFFT~=0);
plot_split(idx,t*200, pitchesFFT)
title('pitchFFT in Hz');
xlabel('time/s \rightarrow');
axis([0 max(t) .9*min(pitchesFFT(idx)) 1.1*max(pitchesFFT(idx))])
subplot(413)
idx=find(pitchesYIN~=0);
plot_split(idx,t*200, pitchesYIN)
title('pitchYIN in Hz');
xlabel('time/s \rightarrow');
axis([0 max(t) .9*min(pitchesYIN(idx)) 1.1*max(pitchesYIN(idx))])
subplot(414)
idx=find(pitchesLTP~=0);
plot_split(idx,t*200, pitchesLTP)
title('pitchLTP in Hz');
xlabel('time/s \rightarrow');
axis([0 max(t) .9*min(pitchesLTP(idx)) 1.1*max(pitchesLTP(idx))])

% plot the timbre stuff
figure(2)
subplot(311)
plot(timbreVoiced)
title('voiced/unvoiced');
subplot(312)
plot(timbreRMS)
title('RMS');
subplot(313)
plot(timbreCentroid)
title('Centroid');

lib=wavread('trumpt44.wav');
out=SampleBasedResynthesis(x,lib(20000:200000));
shift3 = transpose(pitchShift(x, 512, 200, 3));
shift5 = transpose(pitchShift(x, 512, 200, 5));
shift7 = transpose(pitchShift(x, 512, 200, 7));
playLength = min(min(length(x),length(shift3)),min(length(shift5),length(shift7)));

disp('calculation done.... ready to play')
pause;
sound(x,44100)
pause;
sound(lib,44100)
pause;
sound(out,44100)
pause
sound(x(1:playLength)+shift3(1:playLength)+shift5(1:playLength)+shift7(1:playLength),44100)


