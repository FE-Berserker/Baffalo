function LUTBearing = ConvertLUTBearing(inputBearing,Table,NumNode)
% Convert LUTBearing to AMRotor bearng matrix
% Author : Xie Yu

Num=size(inputBearing,1);
LUTBearing=cell(1,Num);
for i=1:Num
    LUTBearing{1,i}.Name=strcat('LUTBearing',num2str(i));
    LUTBearing{1,i}.Type='LUTBearing';
    LUTBearing{1,i}.Node=inputBearing(i,1);
    LUTBearing{1,i}.localisation_matrix=create_ele_loc_matrix;
    LUTBearing{1,i}.Table=Table{inputBearing(i,2),1};
    LUTBearing{1,i}.stiffness_matrix=[];
    LUTBearing{1,i}.damping_matrix=[];
    LUTBearing{1,i}.mass_matrix=sparse(6,6);
    LUTBearing{1,i}.gyroscopic_matrix=sparse(6,6);
    LUTBearing{1,i}.IsCon=inputBearing(i,4)+NumNode;
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

