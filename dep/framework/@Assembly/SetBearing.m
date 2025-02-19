function obj=SetBearing(obj,masternode1,masternode2,stiffness,damping)
% Set Bearing properties
% Author : Xie Yu
if nargin<5
    damping=[0,0,0,0];
end
num=GetNBearing(obj);
obj.Bearing(num+1,:)=[masternode1,masternode2,stiffness,damping];
end

