function obj=AddNurb( obj,coefs,knots, varargin )
% Add Nurb
% Author : Xie Yu
k=inputParser;
addParameter(k,'seg',[]);
parse(k,varargin{:});
opt=k.Results;
 
% Parameter
coefs=coefs';
Num=GetNNurb(obj);
obj.Dim(Num+1,1)=4; 
np = size(coefs);
dim=np(1);
if isempty(opt.seg)
    opt.seg=np(2)*8;
end

% constructing a curve
Coefs = repmat([0.0 0.0 0.0 1.0]',[1 np(2)]);
Coefs(1:dim,:) = coefs;
obj.Coefs{Num+1,1}=Coefs;
obj.Order(Num+1,1) = size(knots,2)-np(2);
knots = sort(knots);
obj.Knots{Num+1,1} = (knots-knots(1))/(knots(end)-knots(1));

p = NrbEval(obj,Num+1,linspace(0.0,1.0,opt.seg));
[obj,~]=addCurve_(obj,obj.NURB,[p(1,:)';p(2,:)']);

%% Print
if obj.Echo
    fprintf('Successfully add Nurb .\n');
    tic
end
end

