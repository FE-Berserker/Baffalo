function obj=OutputAMrotorSystem(obj)
% Output AMrotor system
% Author : Xie YU

Node=obj.input.Shaft.Meshoutput.nodes;
Element=obj.input.Shaft.Meshoutput.elements;
Section=obj.input.Shaft.Section;
Mat=obj.params.Material{obj.input.MaterialNum,1};
% Create Beam Mesh
BeamMesh=TimoshenkoLinearElement(Node,Element,Section,Mat);
BeamMesh=solve(BeamMesh);
Rotor.Mesh=BeamMesh;

%% Assembly the global matrices of rotor
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

%% Add sensors to System
% Transfer keynode to the sensor

%% Add Load to Rotor

%% Add PID-Controller to System

%% Add Bearing
if ~isempty(obj.input.BCNode)
    Bearing1=ConvertBoundary(obj.input.BCNode);
else
    Bearing1=[];
end

if ~isempty(obj.input.Bearing)
    Bearing2=ConvertBearing(obj.input.Bearing);
else
    Bearing2=[];
end

if ~isempty(obj.input.TorBearing)
    Bearing3=ConvertTorBearing(obj.input.TorBearing);
else
    Bearing3=[];
end

Bearing=[Bearing1,Bearing2,Bearing3];
%% Add Disc

%% Parse
RotorSystem.Rotor=Rotor;
% RotorSystem.Sensor=Sensor;
RotorSystem.Component=Bearing;
obj.output.RotorSystem=RotorSystem;
end
