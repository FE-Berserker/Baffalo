function obj=BoundingBox(obj,pointsNum,varargin)
%BoundingBox
points=obj.Points{pointsNum,1}.P;
%% Processing
% Find the maximum and minimum coordinates.
maxp=max(points);
minp=min(points);
%%
% Form the extreme points and add them to the point set.
extrp=[maxp;minp];
p1 = reshape(extrp(:,1),[2 1 1]);
p2 = reshape(extrp(:,2),[1 2 1]);
p3 = reshape(extrp(:,3),[1 1 2]);
p1 = p1(:,ones(2,1),ones(2,1));
p2 = p2(ones(2,1),:,ones(2,1));
p3 = p3(ones(2,1),ones(2,1),:);
extrp=[p1(:) p2(:) p3(:)];
%%
% Perform random perturbations to the extreme points to avoid roundoff
% errors in convhull_nd.
extrp=extrp+0.001*rand(size(extrp));
%%
% Find the point identities defining each facet of the bounding box of the
% point set.
chull=convhull_nd(extrp);
Num=GetNMeshes(obj);
obj.Meshes{Num+1,1}.Vert=extrp;
obj.Meshes{Num+1,1}.Face=chull;
obj.Meshes{Num+1,1}.Cb=(Num+1)*ones(size(chull,1),1);
end

