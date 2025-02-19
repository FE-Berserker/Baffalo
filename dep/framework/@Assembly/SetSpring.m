function obj=SetSpring(obj,masternode1,masternode2,stiffness,damping)
% Set spring type
% Author : Xie Yu
if nargin<5
    damping=[0,0,0,0,0,0];
end
num=GetNSpring(obj);
obj.Spring(num+1,:)=[masternode1,masternode2,stiffness,damping];
end

