function obj=AddAssembly(obj,Ass,varargin)
% Ass sub Assenbly to Assembly
% Author : Xie Yu
% Note : SubStrM, Solu, Load, SF, Boundary will not add to new Assembly
% Note : Bearing and LUTBearing property will not change, so keep the same 
% direction of rotating axis
p=inputParser;
addParameter(p,'position',[0,0,0,0,0,0]);
addParameter(p,'Seq','ZYX');%'XYZ'
parse(p,varargin{:});
opt=p.Results;

position=opt.position;

if size(position,2)~=6
    error('Wrong position input !')
end

% Add Part
PP=TransformPart(Ass.Part,position,...
    obj.Summary.Total_Node,...
    obj.Summary.Total_El,...
    GetNET(obj),...
    GetNCS(obj),...
    obj.Summary.Total_Section,...
    GetNMaterial(obj),...
    opt.Seq);
Temp_Id=obj.Id+Ass.Id;
Temp_Part=[obj.Part;PP];
Temp_Cnode=[obj.Cnode;Ass.Cnode];

% Add Cnode
if ~isempty(Ass.Cnode_Mat)
    CCnode_Mat=TransformCnode_mat(Ass.Cnode_Mat,GetNET(obj));
else
    CCnode_Mat=[];
end
Temp_Cnode_Mat=[obj.Cnode_Mat;CCnode_Mat];

% Add Connection
if ~isempty(Ass.Connection)
    CConection=TransformConnection(Ass.Connection,obj.Summary.Total_Master,obj.Summary.Total_Slaver);
else
    CConection=[];
end
Temp_Connection=[obj.Connection;CConection];

% Add Master
if ~isempty(Ass.Master)
    MM=TransformMaster(Ass.Master,obj.Summary.Total_Cnode,obj.Summary.Total_Node,GetNPart(obj));
else
    MM=[];
end
Temp_Master=[obj.Master;MM];

% Add Slaver
if ~isempty(Ass.Slaver)
    SS=TransformSlaver(Ass.Slaver,obj.Summary.Total_Node);
else
    SS=[];
end
Temp_Slaver=[obj.Slaver;SS];

% Add Spring
if ~isempty(Ass.Spring)
    SSpring=TransformSpring(Ass.Spring,obj.Summary.Total_Cnode);
else
    SSpring=[];
end
Temp_Spring=[obj.Spring;SSpring];

% Add Bearing
if ~isempty(Ass.Bearing)
    SBearing=TransformBearing(Ass.Bearing,obj.Summary.Total_Cnode);
else
    SBearing=[];
end
Temp_Bearing=[obj.Bearing;SBearing];

% Add LUTBearing
if ~isempty(Ass.LUTBearing)
    LUTBearing=TransformLUTBearing(Ass.LUTBearing,obj.Summary.Total_Cnode);
else
    LUTBearing=[];
end
Temp_LUTBearing=[obj.LUTBearing;LUTBearing];

% Add Section
if ~isempty(Ass.Section)
    Section=TransformSection(Ass.Section,GetNMaterial(obj));
else
    Section=[];
end

Temp_Section=[obj.Section;Section];

% Add Material
Temp_Material=[obj.Material;Ass.Material];

% Add Node
VV=TransformV(Ass.V,position,opt.Seq);
Temp_V=[obj.V;VV];

Temp_BeamDirectionNode=[obj.BeamDirectionNode;...
    Ass.BeamDirectionNode+obj.Summary.Total_Node];
% Add ET
Temp_ET=[obj.ET;Ass.ET];
% Add Group
if ~isempty(Ass.Group)
    GG=TransformGroup(Ass.Group,obj.Summary.Total_Node,size(obj.Part,1));
else
    GG=[];
end
Temp_Group=[obj.Group;GG];
% Add CS
if ~isempty(Ass.CS)
    CCS=TransformCS(Ass.CS,position,opt.Seq);
else
    CCS=[];
end
Temp_CS=[obj.CS;CCS];

if ~isempty(Ass.ContactPair)
    CContact=TransformContactPair(Ass.ContactPair,obj.Summary.Total_Node,size(obj.Part,1),size(obj.ET,1),size(obj.Material,1));
else
    CContact=[];
end
Temp_ContactPair=[obj.ContactPair;CContact];

if ~isempty(Ass.Temperature)
    TTemperature=TransformTemperature(Ass.Temperature,size(obj.Part,1));
else
    TTemperature=[];
end
Temp_Temperature=[obj.Temperature;TTemperature];

if ~isempty(Ass.NodeMass)
    NNodeMass=TransformNodeMass(Ass.NodeMass,size(obj.Part,1));
else
    NNodeMass=[];
end
Temp_NodeMass=[obj.NodeMass;NNodeMass];


% Add EndRelease
if ~isempty(Ass.EndRelease)
    EEndRelease=TransformEndRelease(Ass.BeamPreload,obj.Summary.Total_Node,obj.Summary.Total_El);
else
    EEndRelease=[];
end
Temp_EndRelease=[obj.EndRelease;EEndRelease];

% Add EndReleaseList
if ~isempty(Ass.EndReleaseList)
    EEndReleaseList=TransformEndReleaseList(Ass.EndReleaseList,obj.Summary.Total_Node);
else
    EEndReleaseList=[];
end
Temp_EndReleaseList=[obj.EndReleaseList;EEndReleaseList];

% Add BeamPreload
if ~isempty(Ass.BeamPreload)
    BBeamPreload=TransformBeamPreload(Ass.BeamPreload,obj.Summary.Total_Node,obj.Summary.Total_El);
else
     BBeamPreload=[];
end
Temp_BeamPreload=[obj.BeamPreload; BBeamPreload];

% Add SolidPreload
if ~isempty(Ass.SolidPreload)
    SSolidPreload=TransformSolidPreload(Ass.SolidPreload,position,obj.Summary.Total_El,opt.Seq);
else
    SSolidPreload=[];
end
Temp_SolidPreload=[obj.SolidPreload; SSolidPreload];

obj.Id=Temp_Id;
obj.Part=Temp_Part;
obj.Cnode=Temp_Cnode;
obj.Cnode_Mat=Temp_Cnode_Mat;
obj.Connection=Temp_Connection;
obj.Master=Temp_Master;
obj.Slaver=Temp_Slaver;
obj.Spring=Temp_Spring;
obj.Bearing=Temp_Bearing;
obj.LUTBearing=Temp_LUTBearing;
obj.Section=Temp_Section;
obj.Material=Temp_Material;
obj.V=Temp_V;
obj.BeamDirectionNode=Temp_BeamDirectionNode;
obj.ET=Temp_ET;
obj.Group=Temp_Group;
obj.CS=Temp_CS;
obj.Temperature=Temp_Temperature;
obj.NodeMass=Temp_NodeMass;
obj.EndRelease=Temp_EndRelease;
obj.EndReleaseList=Temp_EndReleaseList;
obj.BeamPreload=Temp_BeamPreload;
obj.SolidPreload=Temp_SolidPreload;
obj.ContactPair=Temp_ContactPair;

%% Update summary
obj.Summary.Total_El=GetNEl(obj); % Total number of elements
obj.Summary.Total_Node=GetNNode(obj); % Total number of nodes
obj.Summary. Total_Cnode=GetNCnode(obj); % Total number of cnodes
obj.Summary.Total_Master=GetNMaster(obj); % Total number of master
obj.Summary.Total_Slaver=GetNSlaver(obj); % Total number of slave
obj.Summary.Total_Connection=GetNConnection(obj); % Total number of connections
obj.Summary.Total_Section=GetNSection(obj); % Total number of section
obj.Summary.Total_Part=GetNPart(obj); % Total number of part
obj.Summary.Total_Load=GetNLoad(obj); % Total number of load
obj.Summary.Total_Boundary=GetNBoundary(obj); % Total number of boundary
obj.Summary.Total_ET=GetNET(obj); % Total number of element type
obj.Summary.Total_Sensor=GetNSensor(obj); % Total number of sensor
obj.Summary.Total_IStress=GetNIStress(obj); % Total number of intial stress
obj.Summary.Total_SF=GetNSF(obj); % Total number of SF
obj.Summary.Total_Contact=GetNContactPair(obj); % Total number of contact pair
obj.Summary.Total_CS=GetNCS(obj); % Total number of coordinate system
obj.Summary.Total_NodeMass=GetNNodeMass(obj); % Total number of NodeMass
obj.Summary.Total_EndReleease=GetNEndRelease(obj);% Total endrelease of Assembly
obj.Summary.Total_BeamPreload=GetNBeamPreload(obj); % Total number of Beampreload
%% Print
if obj.Echo
    fprintf('Successfully add Assembly .\n');
end
end

function PP=TransformPart(Part,position,acc_node,acc_el,acc_ET,acc_cs,acc_sec,acc_mat,Seq)
% Update part
% R_xyz=(rotz(position(6))*roty(position(5))*rotx(position(4)))';
PP=Part;
nodes=cellfun(@(x)x.mesh.nodes,PP,'UniformOutput',false);
T=Transform(nodes);
T=Rotate(T,position(4),position(5),position(6),'Seq',Seq);
T=Translate(T,position(1),position(2),position(3));
Temp1=Solve(T);
% Temp1=cellfun(@(x)x.mesh.nodes*R_xyz+repmat(position(:,1:3),size(x,1),1),PP,'UniformOutput',false);
Temp2=cellfun(@(x)x.acc_node+acc_node,PP,'UniformOutput',false);
Temp3=cellfun(@(x)x.acc_el+acc_el,PP,'UniformOutput',false);
Temp4=cellfun(@(x)x.position+position,PP,'UniformOutput',false);
Temp5=cellfun(@(x)x.ET+acc_ET,PP,'UniformOutput',false);
Temp6=cellfun(@(x)(x.ESYS+acc_cs).*(x.ESYS>10),PP,'UniformOutput',false);
Temp7=cellfun(@(x)x.Sec+acc_sec,PP,'UniformOutput',false);
Temp8=cellfun(@(x)x.RealConstants++acc_ET,PP,'UniformOutput',false);
Temp9=cellfun(@(x)x.mesh.elementMaterialID+acc_mat,PP,'UniformOutput',false);
Temp10=cellfun(@(x)x.mesh.faceMaterialID+acc_mat,PP,'UniformOutput',false);
for i=1:size(PP,1)
    PP{i,1}.mesh.nodes=Temp1{i,1};
    PP{i,1}.acc_node=Temp2{i,1};
    PP{i,1}.acc_el=Temp3{i,1};
    PP{i,1}.position=Temp4{i,1};
    PP{i,1}.ET=Temp5{i,1};
    PP{i,1}.ESYS=Temp6{i,1};
    PP{i,1}.Sec=Temp7{i,1};
    PP{i,1}.RealConstants=Temp8{i,1};
    PP{i,1}.mesh.elementMaterialID=Temp9{i,1};
    PP{i,1}.mesh.faceMaterialID=Temp10{i,1};
end
end

function CCnode_mat=TransformCnode_mat(Cnode_mat,acc_ET)
CCnode_mat=Cnode_mat+repmat(acc_ET,size(Cnode_mat,1),1);
end

function CConection=TransformConnection(Connection,acc_mas,acc_slaver)
Temp1=Connection(:,1)+acc_mas;
Temp2=Connection(:,2)+acc_slaver;
CConection=[Temp1,Temp2,Connection(:,3)];
end

function MM=TransformMaster(Master,acc1,acc2,acc3)
Temp1=(Master(:,1)+acc3).*(Master(:,1)~=0)...
    +0.*(Master(:,1)==0);
Temp2=(Master(:,2)+acc2).*(Master(:,1)~=0)...
    +(Master(:,2)+acc1).*(Master(:,1)==0);
MM=[Temp1,Temp2];
end

function SS=TransformSlaver(Slaver,acc_node)
SS=Slaver;
Temp1=cellfun(@(x)x+acc_node,SS,'UniformOutput',false);
for i=1:size(SS,1)
    SS=Temp1;
end
end

function SSpring=TransformSpring(Spring,acc_Cnode)
Temp1=Spring(:,1:2)+acc_Cnode;
SSpring=[Temp1,Spring(:,3:end)];
end

function SBearing=TransformBearing(Bearing,acc_Cnode)
Temp1=Bearing(:,1:2)+acc_Cnode;
SBearing=[Temp1,Bearing(:,3:end)];
end

function LUTBearing=TransformLUTBearing(Bearing,acc_Cnode)
Temp1=Bearing(:,1:2)+acc_Cnode;
LUTBearing=[Temp1,Bearing(:,3:end)];
end

function VV=TransformV(V,position,Seq)
T=Transform(V);
T=Rotate(T,position(4),position(5),position(6),'Seq',Seq);
T=Translate(T,position(1),position(2),position(3));
VV=Solve(T);
end

function GG=TransformGroup(Group,acc)
GG=cellfun(@(x)x+acc,Group,'UniformOutput',false);
end

function CContact=TransformContactPair(ContactPair,acc_node,acc_Part,acc_ET,acc_mat)
CContact=ContactPair;
Temp1=cellfun(@(x)x.Con.elements +acc_node,CContact,'UniformOutput',false);
Temp2=cellfun(@(x)x.Con.Part +acc_Part,CContact,'UniformOutput',false);
Temp3=cellfun(@(x)x.Con.ET +acc_ET,CContact,'UniformOutput',false);
Temp4=cellfun(@(x)x.Tar.elements +acc_node,CContact,'UniformOutput',false);
Temp5=cellfun(@(x)x.Tar.Part +acc_Part,CContact,'UniformOutput',false);
Temp6=cellfun(@(x)x.Tar.ET +acc_ET,CContact,'UniformOutput',false);
Temp7=cellfun(@(x)x.mat +acc_mat,CContact,'UniformOutput',false);
for i=1:size(CContact,1)
    CContact{i,1}.Con.elements=Temp1{i,1};
    CContact{i,1}.Con.Part=Temp2{i,1};
    CContact{i,1}.Con.ET=Temp3{i,1};
    CContact{i,1}.Tar.elements=Temp4{i,1};
    CContact{i,1}.Tar.Part =Temp5{i,1};
    CContact{i,1}.Tar.ET=Temp6{i,1};
    CContact{i,1}.mat=Temp7{i,1};
end
end

function TT=TransformTemperature(Temperature,acc_Part)
TT=Temperature;
TT(:,1)=TT(:,1)+acc_Part;
end

function NN=TransformNodeMass(NodeMass,acc_Part)
NN=NodeMass;
NN(:,1)=NN(:,1)+acc_Part;
end

function BB=TransformBeamPreload(BeamPreload,acc_node,acc_El)
BB=BeamPreload;
for i=1:size(BB,1)
    BB{i,1}.El=BB{i,1}.El+acc_El;
    BB{i,1}.Node=BB{i,1}.Node+acc_node;
end
end

% Transform solidpreload
function BB=TransformSolidPreload(SolidPreload,position,acc_El,Seq)
BB=SolidPreload;
for i=1:size(BB,1)
    BB{i,1}.El=BB{i,1}.El+acc_El;

    nodes=BB{i,1}.Node;

    T=Transform(nodes);
    T=Rotate(T,position(4),position(5),position(6),'Seq',Seq);
    T=Translate(T,position(1),position(2),position(3));
    Temp1=Solve(T);

    BB{i,1}.Node=Temp1;
end
end

function EE=TransformEndRelease(EndRelease,acc_El)
EE=EndRelease;
for i=1:size(EE,1)
    EE{i,1}.El=EE{i,1}.elements+acc_El;
end
end

function EE=TransformEndReleaseList(EndReleaseList,acc_node)
EE=EndReleaseList+acc_node;
end

function CCS=TransformCS(CS,position,Seq)
T=Transform(CS(:,2:4));
T=Rotate(T,position(4),position(5),position(6),'Seq',Seq);
T=Translate(T,position(1),position(2),position(3));
CCS=[CS(:,1),Solve(T),CS(:,5)+position(4),CS(:,6)+position(5),CS(:,7)+position(6)];
end


function Sec=TransformSection(Sec,acc_mat)
for i=1:size(Sec,1)
    Type=Sec{i, 1}.type;
    if Type=="shell"
        if size(Sec{i, 1}.data,2)>1
            Sec{i, 1}.data(1,2)=Sec{i, 1}.data(1,2)+acc_mat; 
        end
    end
end
end