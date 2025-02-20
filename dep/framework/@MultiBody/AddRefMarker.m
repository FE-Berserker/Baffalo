function obj=AddRefMarker(obj,varargin)
% Add Reference marker to MultiBody
% Author : Xie Yu
p=inputParser;
addParameter(p,'Type',2);
addParameter(p,'Par',[]);
addParameter(p,'Pos',[]);
addParameter(p,'Ang',[]);
parse(p,varargin{:});
opt=p.Results;

% Check input

obj.Summary.Total_Ref=GetNRef(obj)+1;
Id=obj.Summary.Total_Ref;

obj.Ref{Id,1}.Type=opt.Type;
obj.Ref{Id,1}.Par=opt.Par;
obj.Ref{Id,1}.Pos=opt.Pos;
obj.Ref{Id,1}.Ang=opt.Ang;


%% Print
if obj.Echo
    fprintf('Successfully add reference marker . \n');
end
end