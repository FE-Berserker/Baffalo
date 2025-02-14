function obj=CreateCircleHole(obj,Length,varargin)
% Add Cirle Hole
% Author : Xie Yu

p=inputParser;
addParameter(p,'scale',1);
addParameter(p,'seg',8);
parse(p,varargin{:});
opt=p.Results;

m=Mesh2D('Temp','Echo',0);
m=AddSurface(m,obj);
m=SetSize(m,Length);
m=Mesh(m);
Cell=ScaleMesh(m,opt.scale);

Cir=cellfun(@(x)MaxInscribedCircle(x(:,1),x(:,2)),Cell,'UniformOutput',false);
CellNum=size(Cell,1);

for i=1:CellNum
    a=Point2D('Temp Point','Echo',0);
    a=AddPoint(a,Cir{i,1}(:,1),Cir{i,1}(:,2));
    b=Line2D('Temp Line','Echo',0);
    b=AddCircle(b,Cir{i,1}(:,3),a,1,'seg',opt.seg);
    obj=AddHole(obj,b);
end

%% Print
if obj.Echo
    fprintf('Successfully Create Circle Hole.\n');
end
end

function res = MaxInscribedCircle(x,y,varargin)
% MAX_INSCRIBED_CIRCLE    Get the maximum inscribed circle that fits inside
% the convex hull of a given set of 2D coordinates
%
% res = MAX_INSCRIBED_CIRCLE(X,Y)    Get the center C and radius R of the
% largest circle that can be inscribed inside the convex hull of the given
% set of coordinates (X,Y). X and Y are each of size Nx1, where Nx1 is the
% number of coordinates, while res is a structure with elements {XC,YC,R}
% where (XC,YC) are the coordinates of the center of the circle and R is
% the radius each of size 1x1.
%
% res = MAX_INSCRIBED_CIRCLE(X,Y,OPTIONS)    Same as above with options to
% plot the convex hull and the maximum inscribed circle.
% OPTIONS.plotresults [0] : If set to 1 will plot the results in a separate
% figure.
%
% Author: Rahul B. Warrier, Created: June 30, 2019
%
% Copyright 2019 Rahul B. Warrier
%
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
%
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.
%

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
res=[xc,yc,r];

end