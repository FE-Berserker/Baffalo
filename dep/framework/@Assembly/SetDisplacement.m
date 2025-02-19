function obj=SetDisplacement(obj,Lnum,opt)
% Set displacement to Assembly
% Author : Xie Yu
row=size(obj.Displacement{Lnum,1}.nodes,1);
obj.Displacement{Lnum,1}.amp=repmat(opt,row,1);

%% Print
if obj.Echo
    fprintf('Successfully set displacement . \n');
end
end