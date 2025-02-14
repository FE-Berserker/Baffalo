function obj=Convcave(obj,Point,varargin)
% Create Convace
% Author : Xie Yu
%% Parse input 
p=inputParser;
addParameter(p,'logic',[]);
parse(p,varargin{:});
opt=p.Results;
P=Point.P;

obj.Vert=P;
obj.Face=delaunay(P(:,1),P(:,2));
Temp=NaN(size(P,1),2);
obj.Vert(opt.logic,:)=Temp(opt.logic,:);
obj=DelNullElement(obj);
obj.Boundary=FindBoundary(obj);
obj.Cb=ones(size(obj.Face,1),1);
%% Parse
obj.Meshoutput.nodes=[obj.Vert,zeros(size(obj.Vert,1),1)];
obj.Meshoutput.facesBoundary=obj.Boundary;
obj.Meshoutput.boundaryMarker=ones(size(obj.Boundary,1),1);
obj.Meshoutput.faces=[];
obj.Meshoutput.elements=obj.Face;
obj.Meshoutput.elementMaterialID=ones(size(obj.Face,1),1);
obj.Meshoutput.faceMaterialID=[];
obj.Meshoutput.order=1;

%% Print
if obj.Echo
    fprintf('Successfully mesh convace .\n');
end
end





