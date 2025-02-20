function obj=AddSubStructure(obj,SubStr,varargin)
% Add SubStructure to MultiBody
% Author : Xie Yu

% Check input
IsSubStr=isa(SubStr,'MultiBody');

if IsSubStr==0
    error('The input is not MultiBody !')
end

obj.Summary.Total_SubStructure=GetNSubStructure(obj)+1;
Id=obj.Summary.Total_SubStructure;

obj.SubStructure{Id,1}.Multi=copy(SubStr);
obj.SubStructure{Id,1}.Position=[0,0,0,0,0,0];

%% Print
if obj.Echo
    fprintf('Successfully add substructure . \n');
end
end