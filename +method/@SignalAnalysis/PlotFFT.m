function PlotFFT(obj,varargin)
p=inputParser;
addParameter(p,'Freq',[]);
parse(p,varargin{:});
opt=p.Results;

x=obj.input.TimeSeries;
Y=fft(x);
L=obj.output.Length;
P2 = abs(Y/L);
P1 = P2(1:round(L/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f = obj.input.Fs*(0:round((L/2)))/L;

if isempty(opt.Freq)
    T=[min(f) max(f)];
    PP=[min(P1) max(P1)];
else
    T=opt.Freq;
    row=find(and(f>T(1,1),f<T(1,2)));
    PP=[0.95*min(P1(row,:)), 1.05*max(P1(row,:))];
end

figure
g=Rplot('x',f,'y',P1);
g=geom_line(g);
g=set_names(g,'x','Freq [Hz]','y','|P1(f)|');
g=axe_property(g,'XLim',T,'YLim',PP);
g=set_axe_options(g,'grid',1);
g=set_title(g,'Single-Sided Amplitude Spectrum');
draw(g);

end