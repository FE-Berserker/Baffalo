function obj=AddSF(obj,Numpart,No,varargin)
% Add SF to Assembly
% Author : Xie Yu
p=inputParser;
addParameter(p,'type','SFBEAM');
parse(p,varargin{:});
opt=p.Results;

num=GetNSF(obj)+1;
obj.SF{num,1}.part=Numpart;
obj.SF{num,1}.elements=No;
obj.SF{num,1}.type=opt.type;

%% Parse
obj.Summary.Total_SF=GetNSF(obj);
%% Print
if obj.Echo
    fprintf('Successfully add SF . \n');
end
end
