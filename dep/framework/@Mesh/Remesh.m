function obj = Remesh(obj,length,varargin)
% Remesh the mesh object
p=inputParser;
addParameter(p,'anisotropy',0);
addParameter(p,'pre_max_hole_area',100);
addParameter(p,'pre_max_hole_edges',0);
addParameter(p,'post_max_hole_area',100);
addParameter(p,'post_max_hole_edges',0);
parse(p,varargin{:});
opt=p.Results;

if nargin>1
    OptionStruct.pointSpacing=length;
end
OptionStruct.anisotropy=opt.anisotropy; %Use anisotropy (~=0) to capture geometry or favour isotropic triangles (=0)
OptionStruct.pre.max_hole_area=opt.pre_max_hole_area; %Max hole area for pre-processing step
OptionStruct.pre.max_hole_edges=opt.pre_max_hole_edges; %Max number of hole edges for pre-processing step
OptionStruct.post.max_hole_area=opt.post_max_hole_area; %Max hole area for post-processing step
OptionStruct.post.max_hole_edges=opt.post_max_hole_edges; %Max number of hole edges for post-processing step
OptionStruct.disp_on=0; %Turn on/off displaying of Geogram text

[F,V]=ggremesh(obj.Face,obj.Vert,OptionStruct);
C=ones(size(F,1),1);
obj.Face=F;
obj.Vert=V;
obj.Cb=C;
end

