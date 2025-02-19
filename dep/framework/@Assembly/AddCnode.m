function obj=AddCnode(obj,x,y,z)
% Define cnode coordinate
% Author : Xie Yu
obj.Summary.Total_Cnode=GetNCnode(obj)+1;
Temp=[x,y,z];
obj.Cnode=[obj.Cnode;Temp];

%% Print
if obj.Echo
    fprintf('Successfully add cnode . \n');
end
end