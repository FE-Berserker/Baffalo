function obj=AddIStress(obj,Numpart,Stress,varargin)
% Add intial stress to part element
% Author : Xie Yu
p=inputParser;
addParameter(p,'element',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.element)
    No=(1:obj.Part{Numpart,1}.NumElements)';
else
    No=opt.element;
end

num=GetNIStress(obj)+1;
acc=obj.Part{Numpart,1}.acc_el;
obj.IStress{num,1}.elements=No+acc;
obj.IStress{num,1}.stress=Stress;

%% Parse
obj.Summary.Total_IStress=GetNIStress(obj);
%% Print
if obj.Echo
    fprintf('Successfully add intial stress . \n');
end
end
