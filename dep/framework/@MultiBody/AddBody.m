function obj=AddBody(obj,SubStr,varargin)
% Add Body to MultiBody
% Author : Xie Yu
p=inputParser;
addParameter(p,'position',[0,0,0,0,0,0]);
parse(p,varargin{:});
opt=p.Results;

% Check input
IsSubStr=isa(SubStr,'solve.SubStr');

if IsSubStr==0
    error('The input is not substr !')
end

Geom=SubStr.output.Geom;

obj.Summary.Total_Body=GetNBody(obj)+1;
Id=obj.Summary.Total_Body;

obj.Body{Id,1}.Geom=Geom;
obj.Body{Id,1}.Marker=SubStr.output.Nodes;
obj.Body{Id,1}.Name=SubStr.params.Name;
obj.Body{Id,1}.Path=SubStr.output.Path;
obj.Body{Id,1}.Position=opt.position;
obj.Body{Id,1}.Freedom=[1,1,1,1,1,1];
obj.Body{Id,1}.Constraint=[0,0,0,0,0,0];
%% Print
if obj.Echo
    fprintf('Successfully add body . \n');
end
end