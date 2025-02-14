function obj=AddHeight(obj,Num,Height,varargin)
% Add Mesh Height
% Author : Xie Yu
p=inputParser;
addParameter(p,'coor','z');
addParameter(p,'fun',[]);
addParameter(p,'new',0);
parse(p,varargin{:});
opt=p.Results;
%% Select Vert
V=obj.Meshes{Num,1}.Vert;
if ~isempty(opt.fun)
    Temp=opt.fun(V(:,1),V(:,2),V(:,3));
else
    Temp=true(size(V,1),1);
end
%% Add Height
switch opt.coor
    case 'x'
        V(Temp,1)=V(Temp,1)+Height;
    case 'y'
        V(Temp,2)=V(Temp,2)+Height;
    case 'z'
        V(Temp,3)=V(Temp,3)+Height;
end
%% Parser vert
if opt.new==0
    obj.Meshes{Num,1}.Vert=V;
else
    NN=GetNMeshes(obj);
    obj.Meshes{NN+1,1}=obj.Mesh{Num,1};
    obj.Mesh.Vert=V;
end

%% Print
if obj.Echo
    fprintf('Successfully add height to mesh.\n');
end

end

