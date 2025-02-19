function obj=SetLoad(obj,Lnum,opt)
% Set load to Assembly
% Author : Xie Yu
row=size(obj.Load{Lnum,1}.nodes,1);
opt=opt/row;
obj.Load{Lnum,1}.amp=repmat(opt,row,1);

%% Print
if obj.Echo
    fprintf('Successfully set load . \n');
end
end