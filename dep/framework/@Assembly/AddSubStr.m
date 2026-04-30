function obj=AddSubStr(obj,SubAss)
% Add Part to Assembly
% Author : Xie Yu

% Check SubAss is class SubStr
if ~isa(SubAss,"solve.SubStr")
    error('Please input the substru class !')
end

obj.Summary.Total_SubStr=GetNSubStr(obj)+1;
Id=obj.Summary.Total_SubStr;

obj.SubStr{Id,1}.Nodes=SubAss.output.Nodes;
obj.SubStr{Id,1}.Geom=SubAss.output.Geom;
obj.SubStr{Id,1}.Name=SubAss.params.Name;
obj.SubStr{Id,1}.Position=SubAss.output.Position;

CheckSubStr(obj)

%% Print
if obj.Echo
    fprintf('Successfully add Sub Structure. \n');
end
end