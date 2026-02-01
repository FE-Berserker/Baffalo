function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
if isempty(obj.output.SolidMesh)
    obj=OutputSolidModel(obj);
end

Ass=Assembly(obj.params.Name,'Echo',0);
% Create Shaft
position=[0,0,0,0,0,0];
Ass=AddPart(Ass,obj.output.SolidMesh.Meshoutput,'position',position);

% ET
if obj.params.Order==2
    ET1.name='186';ET1.opt=[];ET1.R=[];
else
    ET1.name='185';ET1.opt=[];ET1.R=[];
end

Ass=AddET(Ass,ET1);
Ass=SetET(Ass,1,1);

ET2.name='21';ET2.opt=[3,0];ET2.R=[0,0,0,0,0,0];
Ass=AddET(Ass,ET2);
Acc_ET=GetNET(Ass);
%  Material
mat1.name=obj.params.Material.Name;
mat1.table=["DENS",obj.params.Material.Dens;"EX",obj.params.Material.E;...
    "NUXY",obj.params.Material.v;"ALPX",obj.params.Material.a];
Ass=AddMaterial(Ass,mat1);
Ass=SetMaterial(Ass,1,1);

% Connection
Ass=AddCnode(Ass,0,0,0);
Ass=AddMaster(Ass,0,1);
dis.origin=[0,0,0];
dis.distance=obj.input.Meshsize*2;
Ass=AddSlaver(Ass,1,'body',1,'dis',dis);
Ass=SetCnode(Ass,1,Acc_ET);
switch obj.params.ConnectionType
    case 'Rbe3'
        Ass=SetRbe3(Ass,1,1);
    case 'Rbe2'
        Ass=SetRbe2(Ass,1,1);
end

if ~isempty(obj.input.Marker)
    for i=1:size(obj.input.Marker,1)
        Ass=AddCnode(Ass,obj.input.Marker(i,1),obj.input.Marker(i,2),obj.input.Marker(i,3));
        Ass=AddMaster(Ass,0,i+1);
        dis.origin=obj.input.Marker(i,:);
        dis.distance=obj.input.Meshsize*2;
        Ass=AddSlaver(Ass,1,'body',1,'dis',dis);
        Ass=SetCnode(Ass,i+1,Acc_ET);
        switch obj.params.ConnectionType
            case 'Rbe3'
                Ass=SetRbe3(Ass,i+1,i+1);
            case 'Rbe2'
                Ass=SetRbe2(Ass,i+1,i+1);
        end
    end
end

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end