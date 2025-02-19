function obj=SetBoundaryType(obj,Bnum,opt)
% Set type for Boundary
% Author : Xie Yu
row=size(obj.Boundary{Bnum,1}.nodes,1);
obj.Boundary{Bnum,1}.type=repmat(opt,row,1);

%% Print
if obj.Echo
    fprintf('Successfully set boundary type . \n');
end
end