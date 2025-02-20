function obj=AddFunction(obj,data,varargin)
% Add Function to MultiBody
% Author : Xie Yu
p=inputParser;
addParameter(p,'IntpolType',2);% Type=2 linear
addParameter(p,'DataType','Stiffness');% Damping Stiffness RotStiffness RotDamping
parse(p,varargin{:}); 
opt=p.Results;

% Check input
obj.Summary.Total_Function=GetNFunction(obj)+1;
Id=obj.Summary.Total_Function;

obj.Function{Id,1}.Data=data;
obj.Function{Id,1}.DataType=opt.DataType;
obj.Function{Id,1}.IntpolType=opt.IntpolType;
%% Print
if obj.Echo
    fprintf('Successfully add data . \n');
end
end