function PlotWT(obj)

Time=obj.output.WT.t;
f=obj.output.WT.f;
Y=obj.output.WT.Y;

figure
imagesc(Time,f,abs(Y));
axis xy
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colormap jet
end