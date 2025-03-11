function Bearing = ConvertTorBearing(TorBearing)
% Convert TorBearing to AMRotor torsional bearng matrix
% Author : Xie Yu

Num=size(TorBearing,1);
Bearing=cell(1,Num);
for i=1:Num
    Bearing{1,i}.Name=strcat('TorBearing',num2str(i));
    Bearing{1,i}.Node=TorBearing(i,1);
    Bearing{1,i}.localisation_matrix=create_ele_loc_matrix;
    Stiff=TorBearing(i,2);
    Bearing{1,i}.stiffness_matrix=get_loc_stiffness_matrix(Stiff);
    Damping=TorBearing(i,3);
    Bearing{1,i}.damping_matrix=get_loc_damping_matrix(Damping);
    Bearing{1,i}.mass_matrix=sparse(6,6);
    Bearing{1,i}.gyroscopic_matrix=sparse(6,6);
end

end

function localisation_matrix=create_ele_loc_matrix
% Builds a simple local localisation matrix in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Localisation matrix

%Vector version of the  localisation matrix:
Lv0_ele = [1,2,3,4,5,6];

%Matrix version:
L_ele = sparse(6,6);
for k = 1:6
    L_ele(k,Lv0_ele(k)) = 1; %#ok<SPRIX>
end

localisation_matrix = L_ele;
end

function stiffness_matrix = get_loc_stiffness_matrix(Stiff)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Stiffness component matrix K

K=sparse(6,6);
K(6,6)=Stiff*1000;
stiffness_matrix = K;
end

function damping_matrix = get_loc_damping_matrix(Damping)
% Provides/builds local damping matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Damping component matrix D 

D = sparse(6,6);
D(6,6)=Damping*1000;
damping_matrix = D;
end