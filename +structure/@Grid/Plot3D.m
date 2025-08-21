function Plot3D(obj,varargin)
% Plot Bracket
% Author : Xie Yu
p=inputParser;
addParameter(p,'BeamGeom',0);
addParameter(p,'load',0);
addParameter(p,'load_scale',0.9);
addParameter(p,'boundary',0);
addParameter(p,'endrelease',1);
parse(p,varargin{:});
opt=p.Results;

Plot(obj.output.Assembly,'BeamGeom',opt.BeamGeom,'load',opt.load,...
    'boundary',opt.boundary,'load_scale',opt.load_scale,...
    'endrelease',opt.endrelease)

end