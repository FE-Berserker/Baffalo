function PlotSST(obj)

Time=obj.output.SST.t;
f=obj.output.SST.f;
Y=obj.output.SST.Y;

figure
imagesc(Time,f,abs(Y));
axis xy
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colormap jet

end