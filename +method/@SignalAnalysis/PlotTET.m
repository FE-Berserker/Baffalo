function PlotTET(obj,window,varargin)
p=inputParser;
addParameter(p,'Time',[]);
parse(p,varargin{:});
opt=p.Results;

Time=obj.output.T;
if isempty(opt.Time)
    x=obj.input.TimeSeries;
else
    x=obj.input.TimeSeries;
    T=opt.Time;
    x=x(and(Time>T(1,1),Time<T(1,2)),:);
    Time=Time(and(Time>T(1,1),Time<T(1,2)),:);
end

Y=TET(x,window);
L=obj.output.Length;
f = obj.input.Fs*(0:round((L/2)))/L;
% f2=fliplr(f);

figure
imagesc(Time,f,abs(Y));
axis xy
xlabel('Time [s]');
ylabel('Frequency [Hz]');
colormap jet

end