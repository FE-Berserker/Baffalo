function Plot3D(obj,varargin)
% Plot Bracket
% Author : Xie Yu
p=inputParser;
addParameter(p,'BeamGeom',0);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
parse(p,varargin{:});
opt=p.Results;

Plot(obj.output.Assembly,'BeamGeom',opt.BeamGeom,'xlim',opt.xlim,'ylim',opt.ylim,'zlim',opt.zlim)

end