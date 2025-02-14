function obj=DeletePoint(obj,ip,varargin)
% Delete Points
% Author : Xie Yu

p=inputParser;
addParameter(p,'fun',[]);
parse(p,varargin{:});
opt=p.Results;

Temp_PP=obj.PP;
if ~isempty(opt.fun)
    Temp=opt.fun(Temp_PP{ip,1}(:,1),Temp_PP{ip,1}(:,2));
    Temp_PP{ip,1}=Temp_PP{ip,1}(~Temp,:);
else
    Temp_PP{ip,1}=[];
end

Temp_PP= Temp_PP(cellfun(@(x) ~isempty(x), Temp_PP));

a=Point2D('Temp_Point','Dtol',obj.Dtol);
for i=1:size(Temp_PP,1)
    AddPoint(a,Temp_PP{i,1}(:,1),Temp_PP{i,1}(:,2));
end

%% Parse
obj.P=a.P;
obj.PP=a.PP;
obj.NG=a.NG;
obj.NP=a.NP;
%% Print
if obj.Echo
    fprintf('Successfully delete points. \n');
    tic
end

end