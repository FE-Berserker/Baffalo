function OutputSTL(obj)
% Output STL file
% p=inputParser;
% addParameter(p,'faceno',[]);
% addParameter(p,'face_normal',0);
% parse(p,varargin{:});
% opt=p.Results;
m=obj.output.SolidMesh;
m.Name=obj.params.Name;
STLWrite(m);
end