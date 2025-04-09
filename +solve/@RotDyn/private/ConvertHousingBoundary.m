function BC = ConvertHousingBoundary(BCNode,NumNode)
% Convert HousingBCNode to AMRotor bearng matrix
% Author : Xie Yu

Num=size(BCNode,1);
BC=cell(1,Num);
for i=1:Num
    BC{1,i}.Name=strcat('HousingBC',num2str(i));
    BC{1,i}.Type='HousingBoundary';
    BC{1,i}.Node=BCNode(i,1)+NumNode;
    BC{1,i}.localisation_matrix=create_ele_loc_matrix;
    Bound=BCNode(i,2:7);
    BC{1,i}.stiffness_matrix=get_loc_stiffness_matrix(Bound);
    BC{1,i}.damping_matrix=sparse(6,6);
    BC{1,i}.mass_matrix=sparse(6,6);
    BC{1,i}.gyroscopic_matrix=sparse(6,6);
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

function stiffness_matrix = get_loc_stiffness_matrix(Bound)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Stiffness component matrix K
            
    K=sparse(6,6);

    K(3,3)=Bound(1)*1e8;
    K(1,1)=Bound(2)*1e8;
    K(2,2)=Bound(3)*1e8;
    K(6,6)=Bound(4)*1e8;
    K(4,4)=Bound(5)*1e8;
    K(5,5)=Bound(6)*1e8;
   
    stiffness_matrix = K;
end