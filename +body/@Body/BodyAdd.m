function obj=BodyAdd(obj,Mesh1,varargin)
% Add Body
% Author: Xie Yu
p=inputParser;
addParameter(p,'position',[0,0,0,0,0,0]);
parse(p,varargin{:});
opt=p.Results;

Temp.Face=obj.output.OriginSolidMesh.Face;
Temp.Vert=obj.output.OriginSolidMesh.Vert;
Temp.Cb=obj.output.OriginSolidMesh.Cb;
Temp.El=obj.output.OriginSolidMesh.El;
Temp.G=obj.output.OriginSolidMesh.G;
Temp.Meshoutput=obj.output.OriginSolidMesh.Meshoutput;

mm=obj.output.OriginSolidMesh;
mm1=Mesh('Temp Mesh','Echo',0);
mm1.Face=Mesh1.Face;
mm1.Vert=Mesh1.Vert;

position=opt.position;
NumNodes=size(mm1.Vert,1);
R_xyz=rotx(position(4))*roty(position(5))*rotz(position(6));
mm1.Vert=mm1.Vert*R_xyz+repmat(position(:,1:3),NumNodes,1);

Num=GetNTimes(obj);
if isempty(obj.output.Times)
    in = IsInMesh(mm,mm1);
    mm = RemoveCells(mm,~in);
else
    logic=obj.output.Times{Num,1}.logic;
    in= IsInMesh(mm,mm1);
    in=in+logic;
    in(in==2,:)=1;
    mm = RemoveCells(mm,~in);

end

obj.output.Times{Num+1,1}.logic=in;
obj.output.SolidMesh.Face=mm.Face;
obj.output.SolidMesh.Vert=mm.Vert;
obj.output.SolidMesh.Cb=mm.Cb;
obj.output.SolidMesh.El=mm.El;
obj.output.SolidMesh.G=mm.G;
obj.output.SolidMesh.Meshoutput=mm.Meshoutput;

obj.output.OriginSolidMesh.Face=Temp.Face;
obj.output.OriginSolidMesh.Vert=Temp.Vert;
obj.output.OriginSolidMesh.Cb=Temp.Cb;
obj.output.OriginSolidMesh.El=Temp.El;
obj.output.OriginSolidMesh.G=Temp.G;
obj.output.OriginSolidMesh.Meshoutput=Temp.Meshoutput;
%% Print
if obj.params.Echo
    fprintf('Successfully add body .\n');
end
end
