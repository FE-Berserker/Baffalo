function obj=Mesh(obj,varargin)
% Mesh Mesh2D
% Author : Xie Yu
%% Parse input
p=inputParser;
addParameter(p,'kind','delfront');% 'delaunay'
addParameter(p,'ref1','refine');% 'preserve'
addParameter(p,'ref2','refine');% 'preserve'
addParameter(p,'siz1',1.333);
addParameter(p,'siz2',1.3);

parse(p,varargin{:});
opt=p.Results;

OPTS.kind=opt.kind;
OPTS.ref1=opt.ref1;
OPTS.ref2=opt.ref2;
OPTS.siz1=opt.siz1;
OPTS.siz2=opt.siz2;

if isempty(obj.CEdge)
    if isempty(obj.Size)
        [obj.Vert,~,obj.Face,~] = meshtool.refine2(obj.N,obj.E,[],OPTS) ;
    else
        [obj.Vert,~,obj.Face,~] = meshtool.refine2(obj.N,obj.E,[],OPTS,obj.Size) ;
    end
else

    if isempty(obj.CNode)
        error('Please define cnode !')
    end

    cnode=obj.CNode;
    cedge=obj.CEdge;

    part{1} = 1:size(obj.E,1) ;
    E=[obj.E;cedge+size(obj.N,1)];
    N=[obj.N;cnode];

    if isempty(obj.Size)
        [obj.Vert,~,obj.Face,~] = meshtool.refine2(N,E,part,OPTS) ;
    else
        [obj.Vert,~,obj.Face,~] = meshtool.refine2(N,E,part,OPTS,obj.Size) ;
    end

end
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
    fprintf('Successfully mesh object.\n');
end
end