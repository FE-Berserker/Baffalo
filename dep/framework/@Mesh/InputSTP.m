function obj=InputSTP(obj,filename,varargin)
% Input stp file and generate mesh
% Author : Xie Yu


p=inputParser;
addParameter(p,'MaxRelativeDeviation',0.1);
addParameter(p,'Plot',1);
addParameter(p,'Size',1);
addParameter(p,'Ratio',1);
parse(p,varargin{:});
opt=p.Results;

gm = fegeometry(filename,"MaxRelativeDeviation",opt.MaxRelativeDeviation);

if opt.Plot==1
    pdegplot(gm,"FaceAlpha",0.3);
end

if isempty(opt.Size)
    gm = generateMesh(gm,'GeometricOrder','linear');
else
    gm = generateMesh(gm,'GeometricOrder','linear','Hmax',opt.Size);
end

%Convert elements to faces
[F,~]=element2patch(gm.Mesh.Elements',[],'tet4');

%Find boundary faces
[indFree]=freeBoundaryPatch(F);
Fb=F(indFree,:);

Num=size(unique(Fb),1);
obj.Vert=gm.Mesh.Nodes(:,1:Num)';
obj.Face=Fb;
obj.Cb=ones(size(Fb,1),1);

end