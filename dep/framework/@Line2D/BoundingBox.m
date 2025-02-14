function obj = BoundingBox(obj,PP,varargin)
% Boundary nodes
p=inputParser;
addParameter(p,'group',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.group)
    P=PP.P;
else
    P=cell2mat(PP.PP(opt.group,1));
end

% Find the maximum and minimum coordinates.
maxp=max(P);
minp=min(P);
%%
% Form the extreme points and add them to the point set.
extrp=[maxp;minp];
p1 = reshape(extrp(:,1),[2 1]);
p2 = reshape(extrp(:,2),[1 2]);
p1 = p1(:,ones(2,1));
p2 = p2(ones(2,1),:);
extrp=[p1(:) p2(:)];
% Perform random perturbations to the extreme points to avoid roundoff
% errors in convhull_nd.
extrp=extrp+0.001*rand(size(extrp));
%%
% Find the point identities defining each facet of the bounding box of the
% point set.
chull=convhull_nd(extrp);
% Find the first and the second point identity of each edge of the bounding
% box.
node1=chull(:,1);
node2=chull(:,2);
%%
% Find the x and y coordinates of the first and second point of each edge
% of the bounding box.
Num=size(node1,1);
P=NaN(Num+1,2);
P(1:2,:)=extrp([node1(1,1),node2(1,1)],:);
for i=2:Num-1
    row=find(node1==node2(i-1));
    P(i+1,:)=extrp(node2(row,1),:); %#ok<FNDSB> 
end
P(end,:)=P(1,:);
%% Parse
a=Point2D('Temp Points','Echo',0);
a=AddPoint(a,P(:,1),P(:,2));
obj=AddCurve(obj,a,1);
%% Print
if obj.Echo
    fprintf('Successfully calculate boundary .\n');
end
end

