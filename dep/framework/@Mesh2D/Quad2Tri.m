function obj = Quad2Tri(obj,varargin)
% Covert quad mesh to tri mesh
% Type=b backward slash
% Type=f Forward slash
% Author : Xie Yu
p=inputParser;
addParameter(p,'type','a');

parse(p,varargin{:});
opt=p.Results;

Fq=obj.Face;
Vq=obj.Vert;
[Ft,Vt,~]=quad2tri(Fq,Vq,opt.type);
obj.Face=Ft;
obj.Vert=Vt;
obj.Cb=[obj.Cb;obj.Cb];

if ~isempty(obj.Meshoutput)
    obj.Meshoutput.nodes=[obj.Vert,zeros(size(obj.Vert,1),1)];
    obj.Meshoutput.facesBoundary=obj.Boundary;
    obj.Meshoutput.boundaryMarker=ones(size(obj.Boundary,1),1);
    obj.Meshoutput.faces=[];
    obj.Meshoutput.elements=obj.Face;
    obj.Meshoutput.elementMaterialID=ones(size(obj.Face,1),1);
    obj.Meshoutput.faceMaterialID=[];
    obj.Meshoutput.order=1;
end

%% Print
if obj.Echo
    fprintf('Successfully convert quad mesh .\n');
end

end

