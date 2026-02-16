function PlotTET(obj)

Time=obj.output.TET.t;
f=obj.output.TET.f;
Y=obj.output.TET.Y;

figure
imagesc(Time,f,abs(Y));
axis xy
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colormap jet

end