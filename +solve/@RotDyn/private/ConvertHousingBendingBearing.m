function Bearing = ConvertHousingBendingBearing(BendingBearing,NumNode)
% Convert HousingBendingBearing to AMRotor torsional bearng matrix
% Author : Xie Yu

Num=size(BendingBearing,1);
Bearing=cell(1,Num);
for i=1:Num
    Bearing{1,i}.Name=strcat('HousingBendingBearing',num2str(i));
    Bearing{1,i}.Type='HousingBendingBearing';
    Bearing{1,i}.Node=BendingBearing(i,1)+NumNode;
    Bearing{1,i}.localisation_matrix=create_ele_loc_matrix;
    Stiff=BendingBearing(i,2:3);
    Bearing{1,i}.stiffness_matrix=get_loc_stiffness_matrix(Stiff);
    Damping=BendingBearing(i,4:5);
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
K(4,4)=Stiff(1)/1000;
K(5,5)=Stiff(2)/1000;
stiffness_matrix = K;
end

function damping_matrix = get_loc_damping_matrix(Damping)
% Provides/builds local damping matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Damping component matrix D 

D = sparse(6,6);
D(4,4)=Damping(1)/1000;
D(5,5)=Damping(2)/1000;
damping_matrix = D;
end