function Plot(obj,varargin)
p=inputParser;
addParameter(p,'faceno',[]);
addParameter(p,'face_normal',0);
parse(p,varargin{:});
opt=p.Results;

obj=CalculateShape(obj);

Plot(obj.output.Shape);
end