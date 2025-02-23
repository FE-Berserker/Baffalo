function obj=PlotSpeedup(obj,varargin)
% Plot Speedup curve of RotDyn
% Author : XieYu
p=inputParser;
addParameter(p,'KeyNode','All');
parse(p,varargin{:});
opt=p.Results;

if isempty(obj.output.SpeedUp)
    obj = ImportSpeedupFile(obj);
end

% Plot Figure1
X1=cellfun(@(x)x.Freq,obj.output.SpeedUp.Uy,'UniformOutput',false);
Y1=cellfun(@(x)x.Real,obj.output.SpeedUp.Uy,'UniformOutput',false);
Z1=cellfun(@(x)x.Imaginary,obj.output.SpeedUp.Uy,'UniformOutput',false);
Cb=obj.input.KeyNode;
Cb=repmat(Cb,1,size(X1{1,1},1));
Cb=reshape(Cb',[],1);
Cb=mat2cell(Cb,repmat(size(X1{1,1},1),size(X1,1),1));
if opt.KeyNode~="All"
    X1=X1{opt.KeyNode,1};
    Y1=Y1{opt.KeyNode,1};
    Z1=Z1{opt.KeyNode,1};
    Cb=Cb{opt.KeyNode,1};
end

g=Rplot('x',cell2mat(X1),'y',cell2mat(Y1),'color',cell2mat(Cb));
g=geom_line(g);
g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','UY (mm)','color','KeyNode');
figure('Position',[100 100 800 600]);
draw(g);

g=Rplot('x',cell2mat(X1),'y',cell2mat(Z1),'color',cell2mat(Cb));
g=geom_line(g);
g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','UY Imaginary','color','KeyNode');
figure('Position',[100 100 800 600]);
draw(g);
% Plot Figure2
X1=cellfun(@(x)x.Freq,obj.output.SpeedUp.Uz,'UniformOutput',false);
Y1=cellfun(@(x)x.Real,obj.output.SpeedUp.Uz,'UniformOutput',false);
Z1=cellfun(@(x)x.Imaginary,obj.output.SpeedUp.Uz,'UniformOutput',false);
Cb=obj.input.KeyNode;
Cb=repmat(Cb,1,size(X1{1,1},1));
Cb=reshape(Cb',[],1);
Cb=mat2cell(Cb,repmat(size(X1{1,1},1),size(X1,1),1));
if opt.KeyNode~="All"
    X1=X1{opt.KeyNode,1};
    Y1=Y1{opt.KeyNode,1};
    Z1=Z1{opt.KeyNode,1};
    Cb=Cb{opt.KeyNode,1};
end

g=Rplot('x',cell2mat(X1),'y',cell2mat(Y1),'color',cell2mat(Cb));
g=geom_line(g);
g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','UZ (mm)','color','KeyNode');
figure('Position',[100 100 800 600]);
draw(g);

g=Rplot('x',cell2mat(X1),'y',cell2mat(Z1),'color',cell2mat(Cb));
g=geom_line(g);
g=set_names(g,'column','Origin','x',"Frequency (Hz)",'y','UZ Imaginary','color','KeyNode');
figure('Position',[100 100 800 600]);
draw(g);

end