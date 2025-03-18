function obj=SetBearing(obj,masternode1,masternode2,stiffness,damping,varargin)
% Set Bearing properties
% Author : Xie Yu

k=inputParser;
addParameter(k,'Plane','yz');% 'xy' 'yz' 'xz'
parse(k,varargin{:});
opt=k.Results;

if nargin<5
    damping=[0,0,0,0];
end

switch opt.Plane
    case 'xy'
        Type=0;
    case 'yz'
        Type=1;
    case 'xz'
        Type=2;
end

num=GetNBearing(obj);
obj.Bearing(num+1,:)=[masternode1,masternode2,stiffness,damping,Type];
end

