function out=SampleBasedResynthesis(audio,lib)
% out = SampleBasedResynthesis(audio)
% Author: Nuno Fonseca (nuno.fonseca@ipleiria.pt)
%
% Resynthesizes the input audio, but using frames from an internal 
% sound library.
%
% input:      audio signal
%
% output:     resynthesized audio signal
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Variables
    sr=44100;           % sample rate
    wsize=1024;         % window size
    hop=512;            % hop size
    window=hann(wsize); % main window function
    nFrames=GetNumberOfFrames(audio,wsize,hop); % number of frames
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Feature extraction (Energy, Pitch, Phonetic)
    disp('Feature extraction');   
    % Get Features from input audio
    % Get Energy
    disp('- Energy (input)');
    energy=zeros(1,nFrames);
    for frame=1:nFrames
        energy(frame)=sumsqr(GetFrame(audio,frame,wsize,hop).*window);
    end
    % Get Pitch
    disp('- Pitch (input)');
    pitch=yinDAFX(audio,sr,160,hop);
    notesSource = round(note(pitch));
    notesSource = smooth(notesSource);
    %pitch=Pitch_Tracker_FFT_Main(audio,sr);
    nFrames=min(nFrames,length(pitch));
    % Get LPC Freq Response
    disp('- Phonetic info (input)');
    LpcFreqRes=zeros(128,nFrames);
    window2=hann(wsize/4);
    audio2=resample(audio,sr/4,sr);
    for frame=1:nFrames
        temp=lpc(GetFrame(audio2,frame,wsize/4,hop/4).*window2,12);
        temp(find(isnan(temp)))=0;
        LpcFreqRes(:,frame)=20*log10(eps+abs(freqz(1,temp,128)));
    end

    % Load lib and extract information
    disp('- Loading sound library');
    %lib=wavread('trumpt44.wav');
    disp('- Pitch (lib)');
    pitchLib=yinDAFX(lib,sr,160,hop);
    notesLib=round(note(pitchLib));    
    disp('- Phonetic info (lib)');
    libLpcFreqRes=zeros(128,GetNumberOfFrames(lib,wsize,hop));
    audio2=resample(lib,sr/4,sr);
    for frame=1:GetNumberOfFrames(lib,wsize,hop)
        temp=lpc(GetFrame(audio2,frame,wsize/4,hop/4).*window2,12);
        temp(find(isnan(temp)))=0;
        libLpcFreqRes(:,frame)=20*log10(eps+abs(freqz(1,temp,128)));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Unit Selection
    disp('Unit Selection');
    chosenFrames=zeros(1,nFrames);
    for frame=1:nFrames
        % From all frames with the same musical note
        % the system chooses the more similar one        
        temp=LpcFreqRes(:,frame);
        n=notesSource(frame);
        indexes=find(notesLib==n);
        if(length(indexes)==0)
            n=round(note(0));
           indexes=find(notesLib==n);
        end
        [distance,index]=min(dist(temp',libLpcFreqRes(:,indexes)));
        chosenFrames(frame)=indexes(index);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Synthesis
    disp('Synthesis');
    out=zeros(length(audio),1);
    for frame=1:nFrames        
        % Gets the frame from the sound lib., change its gain to have a
        % similar energy, and adds it to the output buffer.
        buffer=lib((chosenFrames(frame)-1)*hop+1:(chosenFrames(frame)-1)...
            *hop+wsize).*window;
        gain=sqrt(energy(frame)/sumsqr(buffer));
        out((frame-1)*hop+1:(frame-1)*hop+wsize)=out((frame-1)...
            *hop+1:(frame-1)*hop+wsize)+ buffer*gain;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Auxiliary functions
 
% Get number of frames
function out=GetNumberOfFrames(data,size,hop)
    out=max(0,1+floor((length(data)-size)/hop));
end
 
% Get Frame, starting at frame 1
function out=GetFrame(data,index,size,hop)
    if(index<=GetNumberOfFrames(data,size,hop))
        out=data((index-1)*hop+1:(index-1)*hop+size);
    else
        out=[];
    end
end
 
% Convert frequency to note (MIDI value)
function out=note(freq)
    out=12*log(abs(freq)/440)/log(2)+69;
end