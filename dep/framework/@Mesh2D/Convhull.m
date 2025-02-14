function obj=Convhull(obj,Point,varargin)
% Create Convhull
% Author : Xie Yu
%% Parse input 
p=inputParser;
addParameter(p,'simplity',false);
addParameter(p,'keep',0);
parse(p,varargin{:});
opt=p.Results;
P=Point.P;

if opt.keep==1
    obj.Vert=P;
    obj.Face=delaunay(P(:,1),P(:,2));
    obj.Boundary=FindBoundary(obj);
else
    k=convhull(P(:,1),P(:,2),'Simplify',opt.simplity);
    obj.N=P(k(1:end-1,1),:);
    obj.E=[(1:size(k,1)-1)',[2:size(k,1)-1,1]'];
    obj=Mesh(obj);
end

%% Print
if obj.Echo
    fprintf('Successfully mesh convhull .\n');
end

end





