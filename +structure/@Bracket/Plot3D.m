function Plot3D(obj,varargin)
% Plot Bracket
% Author : Xie Yu
p=inputParser;
addParameter(p,'BeamGeom',0);
parse(p,varargin{:});
opt=p.Results;

Plot(obj.output.Assembly,'BeamGeom',opt.BeamGeom)

end