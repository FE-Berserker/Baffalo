function obj=AddBeamPreload(obj,Numpart,Preload)
% Add Beam Preload to Assembly
% Author : Xie Yu
acc1=obj.Part{Numpart,1}.acc_el;
acc2=obj.Part{Numpart,1}.acc_node;
num=GetNBeamPreload(obj)+1;
obj.BeamPreload{num,1}.El=acc1+ceil(obj.Part{Numpart,1}.NumElements/2);
obj.BeamPreload{num,1}.Node=acc2+obj.Part{Numpart,1}.mesh.elements(ceil(obj.Part{Numpart,1}.NumElements/2),:);
obj.BeamPreload{num,1}.Preload=Preload;
%% Parse
obj.Summary.Total_BeamPreload=GetNBeamPreload(obj);

%% Print
if obj.Echo
    fprintf('Successfully add beampreload . \n');
end
end
