function obj=SetMaterial(obj,Numpart,Nummat)
% Set Material of part
% Author : Xie Yu
obj.Part{Numpart,1}.mesh.elementMaterialID=...
    ones(size(obj.Part{Numpart,1}.mesh.elementMaterialID,1),1)*Nummat;
%% Print
if obj.Echo
    fprintf('Successfully set material . \n');
end
end