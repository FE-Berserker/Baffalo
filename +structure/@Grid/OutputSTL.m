function OutputSTL(obj)
% Output STL file
% Author : Xie Yu

% p=inputParser;
% addParameter(p,'faceno',[]);
% addParameter(p,'face_normal',0);
% parse(p,varargin{:});
% opt=p.Results;

m=ExtractBeamFace(obj.output.Assembly);
m.Name=obj.params.Name;
% PlotFace(m)
STLWrite(m);
end