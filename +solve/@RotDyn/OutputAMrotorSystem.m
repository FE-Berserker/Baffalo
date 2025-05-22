function obj=OutputAMrotorSystem(obj)
% Output AMrotor system
% Author : Xie YU

%% Assembly the global matrices of rotor
Node=obj.input.Shaft.Meshoutput.nodes;
Element=obj.input.Shaft.Meshoutput.elements;
Section=obj.input.Shaft.Section;
Mat=obj.params.Material;
MatNum=obj.input.MaterialNum;
% Create Beam Mesh
BeamMesh=TimoshenkoLinearElement(Node,Element,Section,Mat,MatNum);
BeamMesh=solve(BeamMesh);
Rotor.Mesh=BeamMesh;
% mass_matrix
n_nodes=size(Node,1);
M=sparse(6*n_nodes,6*n_nodes);
for i=1:size(Element,1)
    L_ele=sparse(12,6*n_nodes);
    L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=BeamMesh.localisation_matrix; %#ok<SPRIX>
    M=M+L_ele'*sparse(BeamMesh.mass_matrix{i})*L_ele;
end
Rotor.mass_matrix=M;
% stiffness_matrix
K=sparse(6*n_nodes,6*n_nodes);
for i=1:size(Element,1)
    L_ele = sparse(12,6*n_nodes);
    L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=BeamMesh.localisation_matrix; %#ok<SPRIX>
    K=K+L_ele'*sparse(BeamMesh.stiffness_matrix{i})*L_ele;
end
Rotor.stiffness_matrix = K;
% gyroscopic_matrix
G=sparse(6*n_nodes,6*n_nodes);
for i=1:size(Element,1)
    L_ele = sparse(12,6*n_nodes);
    L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=BeamMesh.localisation_matrix; %#ok<SPRIX>
    G=G+L_ele'*sparse(BeamMesh.gyroscopic_matrix{i})*L_ele;
end
Rotor.gyroscopic_matrix = G;
% Rayleigh-Damping
alpha1=obj.params.Rayleigh(1);
alpha2=obj.params.Rayleigh(2);
Rotor.damping_matrix = alpha1*K + alpha2*M;
NumNode=0;

%% Assembly the global matrices of Housing
if ~isempty(obj.input.Housing)
    NumNode=n_nodes;
    Node=obj.input.Housing.Meshoutput.nodes;
    Element=obj.input.Housing.Meshoutput.elements;
    Section=obj.input.Housing.Section;
    Mat=obj.params.Material;
    MatNum=obj.input.HousingMaterialNum;
    % Create Beam Mesh
    BeamMesh=TimoshenkoLinearElement(Node,Element,Section,Mat,MatNum);
    BeamMesh=solve(BeamMesh);
    Housing.Mesh=BeamMesh;
    % mass_matrix
    n_nodes=size(Node,1);
    M=sparse(6*n_nodes,6*n_nodes);
    for i=1:size(Element,1)
        L_ele=sparse(12,6*n_nodes);
        L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=BeamMesh.localisation_matrix; %#ok<SPRIX>
        M=M+L_ele'*sparse(BeamMesh.mass_matrix{i})*L_ele;
    end
    Housing.mass_matrix=M;
    % stiffness_matrix
    K=sparse(6*n_nodes,6*n_nodes);
    for i=1:size(Element,1)
        L_ele = sparse(12,6*n_nodes);
        L_ele(1:12,(i-1)*6+1:(i-1)*6+12)=BeamMesh.localisation_matrix; %#ok<SPRIX>
        K=K+L_ele'*sparse(BeamMesh.stiffness_matrix{i})*L_ele;
    end
    Housing.stiffness_matrix = K;
    % gyroscopic_matrix
    G=sparse(6*n_nodes,6*n_nodes);
    Housing.gyroscopic_matrix = G;
    % Rayleigh-Damping
    alpha1=obj.params.Rayleigh(1);
    alpha2=obj.params.Rayleigh(2);
    Housing.damping_matrix = alpha1*K + alpha2*M;
    Rotor=CombineRotorHousing(Rotor,Housing);
end

%% Add Bearing
if ~isempty(obj.input.BCNode)
    Bearing1=ConvertBoundary(obj.input.BCNode);
else
    Bearing1=[];
end

if ~isempty(obj.input.Bearing)
    Bearing2=ConvertBearing(obj.input.Bearing,NumNode);
else
    Bearing2=[];
end

if ~isempty(obj.input.TorBearing)
    Bearing3=ConvertTorBearing(obj.input.TorBearing,NumNode);
else
    Bearing3=[];
end

if ~isempty(obj.input.BendingBearing)
    Bearing4=ConvertBendingBearing(obj.input.BendingBearing,NumNode);
else
    Bearing4=[];
end

Bearing=[Bearing1,Bearing2,Bearing3,Bearing4];
%% Add HousingBearing
if ~isempty(obj.input.HousingBCNode)
    HousingBearing1=ConvertHousingBoundary(obj.input.HousingBCNode,NumNode);
else
    HousingBearing1=[];
end

if ~isempty(obj.input.HousingBearing)
    HousingBearing2=ConvertHousingBearing(obj.input.HousingBearing,NumNode);
else
    HousingBearing2=[];
end

if ~isempty(obj.input.HousingTorBearing)
    HousingBearing3=ConvertHousingTorBearing(obj.input.HousingTorBearing,NumNode);
else
    HousingBearing3=[];
end

if ~isempty(obj.input.HousingBendingBearing)
    HousingBearing4=ConvertHousingBendingBearing(obj.input.HousingBendingBearing,NumNode);
else
    HousingBearing4=[];
end

HousingBearing=[HousingBearing1,HousingBearing2,HousingBearing3,HousingBearing4];
%% Add Disc
if ~isempty(obj.input.PointMass)
    Disc=ConvertDisc(obj.input.PointMass);
else
    Disc=[];
end
%% Add LUTBearing
if ~isempty(obj.input.LUTBearing)
    LUTBearing=ConvertLUTBearing(obj.input.LUTBearing,obj.input.Table,NumNode);
else
    LUTBearing=[];
end
%% PIDController
if ~isempty(obj.input.PIDController)
    row=size(obj.input.PIDController,1);
    PIDController=cell(1,row);
    for i=1:row
        PIDController{i}=control.RotDynPIDController(obj.input.PIDController{i,1});
        if ~isempty(PIDController{i}.Node1)
            PIDController{i}.Node1=PIDController{i}.Node1+NumNode;
        end
    end
else
    PIDController=[];
end

%% Parse
RotorSystem.Rotor=Rotor;
RotorSystem.Component=[Bearing,Disc,LUTBearing,HousingBearing];
RotorSystem.PIDController=PIDController;
RotorSystem.UnBalance=obj.input.UnBalanceForce;
obj.output.RotorSystem=RotorSystem;
end

function Rotor=CombineRotorHousing(Part1,Part2)
NumNode1=size(Part1.Mesh.Node,1);
NumNode2=size(Part2.Mesh.Node,1);
n_nodes=NumNode1+NumNode2;
Mesh=Part1.Mesh;
Mesh.E=[Mesh.E,Part2.Mesh.E];
Mesh.G=[Mesh.G,Part2.Mesh.G];
Mesh.v=[Mesh.v,Part2.Mesh.v];
Mesh.Dens=[Mesh.Dens,Part2.Mesh.Dens];
Mesh.Node=[Mesh.Node;Part2.Mesh.Node];
Mesh.Element=[Mesh.Element;Part2.Mesh.Element+NumNode1];
Mesh.radius_outer=[Mesh.radius_outer;Part2.Mesh.radius_outer];
Mesh.radius_inner=[Mesh.radius_inner;Part2.Mesh.radius_inner];
Mesh.Area=[Mesh.Area,Part2.Mesh.Area];
Mesh.Length=[Mesh.Length,Part2.Mesh.Length];
Mesh.Volume=[Mesh.Volume,Part2.Mesh.Volume];
Mesh.I_p=[Mesh.I_p,Part2.Mesh.I_p];
Mesh.I_y=[Mesh.I_y,Part2.Mesh.I_y];
Mesh.stiffness_matrix=[Mesh.stiffness_matrix,Part2.Mesh.stiffness_matrix];
Mesh.mass_matrix=[Mesh.mass_matrix,Part2.Mesh.mass_matrix];
Mesh.gyroscopic_matrix=[Mesh.gyroscopic_matrix,Part2.Mesh.gyroscopic_matrix];

M=sparse(6*n_nodes,6*n_nodes);
K=sparse(6*n_nodes,6*n_nodes);
G=sparse(6*n_nodes,6*n_nodes);
D=sparse(6*n_nodes,6*n_nodes);

M(1:6*NumNode1,1:6*NumNode1)=Part1.mass_matrix;
M(6*NumNode1+1:end,6*NumNode1+1:end)=Part2.mass_matrix;

K(1:6*NumNode1,1:6*NumNode1)=Part1.stiffness_matrix;
K(6*NumNode1+1:end,6*NumNode1+1:end)=Part2.stiffness_matrix;

G(1:6*NumNode1,1:6*NumNode1)=Part1.gyroscopic_matrix;
G(6*NumNode1+1:end,6*NumNode1+1:end)=Part2.gyroscopic_matrix;

D(1:6*NumNode1,1:6*NumNode1)=Part1.damping_matrix;
D(6*NumNode1+1:end,6*NumNode1+1:end)=Part2.damping_matrix;

Rotor.mass_matrix=M;
Rotor.stiffness_matrix=K;
Rotor.gyroscopic_matrix=G;
Rotor.damping_matrix=D;
Rotor.Mesh=Mesh;
end
