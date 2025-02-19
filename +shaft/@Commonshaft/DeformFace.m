function obj=DeformFace(obj,Faceno,fun,varargin)
% Deform face node
% Update solid mesh and assembly, not update beam mesh
% Author : Xie Yu
p=inputParser;
addParameter(p,'direction','axial');% 'axial' 'radial'
addParameter(p,'Plot',1);
parse(p,varargin{:});
opt=p.Results;
%% Select Vert
[VV,pos] = SelectFaceNode(obj,Faceno);

if opt.direction=="axial"
    r=sqrt(VV(:,2).^2+VV(:,3).^2);
    VV(:,1)=fun(r);
elseif opt.direction=="radial"
    x=VV(:,1);
    r=sqrt(VV(:,2).^2+VV(:,3).^2);
    rr=fun(x);
    ratio=rr./r;
    VV(:,2)=VV(:,2).*ratio;
    VV(:,3)=VV(:,3).*ratio;
end

%% Regenerate mesh
V=obj.output.SolidMesh.Vert;
V(pos,:)=VV;

%% Parser
obj.output.SolidMesh.Vert=V;
obj.output.SolidMesh.Meshoutput.nodes=V;
obj.output.SolidMesh=Mesh3D(obj.output.SolidMesh);

%% Update
if ~isempty(obj.output.Assembly)
    obj=OutputAss(obj);
end

%% Plot
if opt.Plot
    Plot3D(obj,'faceno',Faceno);
end

%% Print
if obj.params.Echo
    fprintf('Successfully deform face .\n');
end
end

