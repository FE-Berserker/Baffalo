function obj=SetConMaterial(obj,Numpair,Matno)
% Set Contact pair material
% Author : Xie Yu
obj.ContactPair{Numpair,1}.mat=Matno;
%% Print
if obj.Echo
    fprintf('Successfully set contact material .\n');
end
end

