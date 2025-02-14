function obj = Boundary(obj,PP,varargin)
% Boundary nodes
p=inputParser;
addParameter(p,'scale',0.5);
addParameter(p,'group',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.group)
    P=PP.P;
else
    P=cell2mat(PP.PP(opt.group,1));
end

k=boundary(P(:,1),P(:,2),opt.scale);

%% Parse
P=P(k(1:end),:);
a=Point2D('Temp Points','Echo',0);
a=AddPoint(a,P(:,1),P(:,2));
obj=AddCurve(obj,a,1);

%% Print
if obj.Echo
    fprintf('Successfully calculate boundary .\n');
end
end

