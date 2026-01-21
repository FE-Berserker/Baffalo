function obj=AddGroup(obj,PartNum)
% Add Group to Assembly
% Author : Xie Yu

Id=GetNGroup(obj);
obj.Summary.Total_Group=Id+1;
obj.Group{Id+1,1}=PartNum;

%% Print
if obj.Echo
    fprintf('Successfully add group . \n');
end
end