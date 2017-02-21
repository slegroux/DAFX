x=wavread('sound.wav');

xx=[];
yy=[];
start=1;
finish=1024;

for i=(0:1:5)
    xTemp=x(start+i*1024:1024+i*1024);
    y=lagt(xTemp,-.4);
    xx=horzcat(xx,xTemp);
    yy=horzcat(yy,y);
end

 subplot(2,1,1)
 plot(xx)
 subplot(2,1,2)
 plot(yy)

wavwrite(yy,44100,'out.wav')