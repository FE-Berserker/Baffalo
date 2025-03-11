function PlotBode(obj,varargin)
% Plot Bode of RotDyn
% Author : XieYu
p=inputParser;
addParameter(p,'phase','deg');% 'rad'
addParameter(p,'yaxis','log');% 'linear'
addParameter(p,'amp','amp');% 'dB'
parse(p,varargin{:});
opt=p.Results;

x=obj.output.FRFResult.f;
H=obj.output.FRFResult.H;

InPos = GetNodePos(obj,obj.input.InNode);
OutPos = GetNodePos(obj,obj.input.OutNode);

x=repmat(x,size(H,3)*size(H,2),1);
x=mat2cell(x,ones(1,size(H,3)*size(H,2)))';

y=cell(1,size(H,3)*size(H,2));
Cb=cell(size(H,3)*size(H,2),1);
phaseFRF=cell(1,size(H,3)*size(H,2));
if opt.amp=="dB"
    for i=1:size(H,3)
        for j=1:size(H,2)
            y{1,i*(j-1)+1}=ab20(abs(H(:,j,i)));
            Cb{i*(j-1)+1,1}=strcat('In:',num2str(InPos(i)),'Out:',num2str(OutPos(j)));
            phaseFRF{1,i*(j-1)+1}=angle(H(:,j,i));
        end
    end
else
    for i=1:size(H,3)
        for j=1:size(H,2)
            y{1,i*(j-1)+1}=abs(H(:,j,i));
            Cb{i*(j-1)+1,1}=strcat('In:',num2str(InPos(i)),' Out:',num2str(OutPos(j)));
            phaseFRF{1,i*(j-1)+1}=angle(H(:,j,i));
        end
    end
end

if opt.phase=="deg"
    phaseFRF=cellfun(@(x)x/pi*180,phaseFRF,'UniformOutput',false);
end

figure('Position',[100 100 1000 800]);
g(1,1)=Rplot('x',x,'y',y,'color',Cb);
g(1,1)=set_line_options(g(1,1),'base_size',1,'step_size',0);
g(1,1)=set_text_options(g(1,1),'interpreter','latex');

switch opt.yaxis
    case 'linear'
        g(1,1)=axe_property(g(1,1),'XLim',obj.params.Freq);
    case 'log'
        g(1,1)=axe_property(g(1,1),'XLim',obj.params.Freq,'YScale','log');
end

g(1,1)=set_axe_options(g(1,1),'grid',1);

switch obj.params.FRFType
    case 'd'
        Unit='\frac{mm}{N}';
    case 'v'
        Unit='\frac{mm/s}{N}';
    case 'a'
        Unit='\frac{mm/s^2}{N}';
end

switch opt.amp
    case 'amp'
        ylabel=strcat('$|G_{',obj.params.FRFType,'}|',Unit,'$');
    case 'dB'
        ylabel=strcat('$|G_{',obj.params.FRFType,'}|',Unit,'dB$');
end

g(1,1)=set_names(g(1,1),'column','Origin','x','f (Hz)','y',ylabel,'color','Position');
g(1,1)=geom_line(g(1,1));

g(2,1)=Rplot('x',x,'y',phaseFRF,'color',Cb);
g(2,1)=set_line_options(g(2,1),'base_size',1,'step_size',0);
g(2,1)=set_text_options(g(2,1),'interpreter','latex');
g(2,1)=axe_property(g(2,1),'XLim',obj.params.Freq);
g(2,1)=set_axe_options(g(2,1),'grid',1);
g(2,1)=set_names(g(2,1),'column','Origin','x','f (Hz)','y','rad','color','Position');
g(2,1)=geom_line(g(2,1));
draw(g);


end