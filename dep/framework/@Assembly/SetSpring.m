function obj=SetSpring(obj,masternode1,masternode2,stiffness,damping,varargin)
% Set spring type
% Author : Xie Yu
p=inputParser;
addParameter(p,'Gap',0);
addParameter(p,'Fslide',0);
parse(p,varargin{:});
opt=p.Results;

if nargin<5
    damping=[0,0,0,0,0,0];
end

num=GetNSpring(obj);
obj.Spring(num+1,:)=[masternode1,masternode2,stiffness,damping,opt.Gap,opt.Fslide];
end

