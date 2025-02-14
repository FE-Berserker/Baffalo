function obj = MaxInscribedCircle(obj,LineNum,varargin)
% Get the maximum inscribed circle that fits inside

x=obj.Point.PP{LineNum,1}(:,1);
y=obj.Point.PP{LineNum,1}(:,2);
% Compute convex hull
k = convhull(x,y);
% Maximum inscribed circle
conv_boundary = [x(k,:),y(k,:)];
% Make data into a 1000x1000 image.
xyMin = min(conv_boundary,[],1);
xyMax = max(conv_boundary,[],1);
scalingFactor = 1000 / min([xyMax(:,1)-xyMin(:,1), xyMax(:,2)-xyMin(:,2)]);
x2 = (conv_boundary(:,1)-xyMin(:,1))*scalingFactor + 1;
y2 = (conv_boundary(:,2)-xyMin(:,2))*scalingFactor + 1;
mask = poly2mask(x2,y2,ceil(max(y2)),ceil(max(x2)));
% Compute the Euclidean Distance Transform
edtImage = bwdist(~mask);
% Find the max
r = max(edtImage(:));
% Find the center
[yCenter, xCenter] = find(edtImage == r);
xc = (xCenter(1) - 1)/ scalingFactor + xyMin(1);
yc = (yCenter(1) - 1)/ scalingFactor + xyMin(2);
% Find the r
r = double(r / scalingFactor);

a=Point2D('Temp','Echo',0);
a=AddPoint(a,xc,yc);
obj=AddCircle(obj,r,a,1);

%% Print
if obj.Echo
    fprintf('Successfully calculate MaxInscribedCircle .\n');
end
end