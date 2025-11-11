function obj=AddSolidPreload(obj,Numpart,Preload,NodeA,NodeB,NodeC)
% Add Solid Preload to Assembly
% Author : Xie Yu
acc1=obj.Part{Numpart,1}.acc_el;
NEl=obj.Part{Numpart,1}.NumElements;
num=GetNSolidPreload(obj)+1;
obj.SolidPreload{num,1}.El=[acc1+1,acc1+NEl];
obj.SolidPreload{num,1}.Node=[NodeA;NodeB;NodeC];
obj.SolidPreload{num,1}.Preload=Preload;
%% Parse
obj.Summary.Total_SolidPreload=GetNSolidPreload(obj);

%% Print
if obj.Echo
    fprintf('Successfully add solidpreload . \n');
end
end
