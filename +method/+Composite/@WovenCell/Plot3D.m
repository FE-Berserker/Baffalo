function Plot3D(obj,varargin)
% Plot element
% Author : Xie Yu
p=inputParser;
addParameter(p,'Yarn',1);
addParameter(p,'Matrix',1);
addParameter(p,'YarnIndex',1);
addParameter(p,'SurfaceDistance',0);

parse(p,varargin{:});
opt=p.Results;

m=obj.output.SolidMesh;
YarnIndex=obj.output.YarnIndex;
if and(opt.Yarn==0,opt.Matrix==0)
    error('Nothing to plot !')
elseif opt.Yarn==0
    m.Meshoutput.elements=m.Meshoutput.elements(obj.output.YarnIndex<0,:);
    YarnIndex=YarnIndex(obj.output.YarnIndex<0,:);
    SurfaceDistance=obj.output.SurfaceDistance(obj.output.YarnIndex<0,:);
elseif opt.Matrix==0
    m.Meshoutput.elements=m.Meshoutput.elements(obj.output.YarnIndex>=0,:);
    YarnIndex=YarnIndex(obj.output.YarnIndex>=0,:);
    SurfaceDistance=obj.output.SurfaceDistance(obj.output.YarnIndex>=0,:);
end

if opt.YarnIndex==1
    m.Cell_Data=YarnIndex;
    PlotElement2(m);
end

if opt.SurfaceDistance==1
    m.Cell_Data=SurfaceDistance;
    PlotElement2(m);   
end
end