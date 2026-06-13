function Plot2D(obj,varargin)
% Plot section of roller bearing
% Author: Xie Yu

p=inputParser;
addParameter(p,'save',0);
parse(p,varargin{:});
opt=p.Results;

L=obj.output.Surface;

if opt.save
  Plot(L,'edgecolor','none','View',[0,90],'save',strcat(obj.params.Name,'_3D'));
else
  Plot(L,'edgecolor','none','View',[0,90]);
end

end