function obj = OutputAss(obj)
% Output solidmesh to Assembly
% Author : Xie Yu
if isempty(obj.output.SolidMesh)
    obj=OutputSolidModel(obj);
end

switch obj.params.Type
    case 1
        Thickness=obj.input.GeometryData(1,3);
    case 2
        Thickness=obj.input.GeometryData(1,2);
    case 3
        Thickness=obj.input.GeometryData(1,2);
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
for i=1:size(obj.input.Hole,1)
    Ass=AddCnode(Ass,obj.input.Hole(i,1),obj.input.Hole(i,2),0);
    Ass=AddMaster(Ass,0,i);
    cyl.axial='z';
    cyl.origin=[obj.input.Hole(i,1:2),0];
    cyl.l=Thickness;
    cyl.r=obj.input.Hole(i,3)+1e-5;
    Ass=AddSlaver(Ass,1,'face',1,'cyl',cyl);
    Ass=SetCnode(Ass,i,Acc_ET);
    switch obj.params.ConnectionType
        case 'Rbe3'
            Ass=SetRbe3(Ass,i,i);
        case 'Rbe2'
            Ass=SetRbe2(Ass,i,i);
    end
end

switch obj.params.Type
    case 3
        Ass=AddCnode(Ass,0,0,0);
        Acc_Cnode=GetNCnode(Ass);
        Ass=AddMaster(Ass,0,Acc_Cnode);
        Ass=AddSlaver(Ass,1,'face',1,'y',0);
        Ass=SetCnode(Ass,Acc_Cnode,Acc_ET);
        Acc_Mas=GetNMaster(Ass);
        Acc_Sla=GetNSlaver(Ass);
        switch obj.params.ConnectionType
            case 'Rbe3'
                Ass=SetRbe3(Ass,Acc_Mas,Acc_Sla);
            case 'Rbe2'
                Ass=SetRbe2(Ass,Acc_Mas,Acc_Sla);
        end
end

%% Parse
obj.output.Assembly=Ass;
%% Print
if obj.params.Echo
    fprintf('Successfully output solid mesh assembly .\n');
end
end