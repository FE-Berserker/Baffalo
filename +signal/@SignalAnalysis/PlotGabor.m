function PlotGabor(obj)

Time=obj.output.Gabor.t;
f=obj.output.Gabor.f;
Y=obj.output.Gabor.Y;

figure
imagesc(Time,f,abs(Y));
axis xy
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colormap jet
end