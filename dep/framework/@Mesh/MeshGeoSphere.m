function obj = MeshGeoSphere(obj,n,r,varargin)
% Mesh Geosphere
% Author : Xie Yu
% n sphere radius
% r Refinements
p=inputParser;
addParameter(p,'Type',4);
parse(p,varargin{:});
opt=p.Results;

[F,V,~]=geoSphere(n,r,opt.Type);

obj.Face=F;
obj.Vert=V;
obj.Cb=ones(size(obj.Face,1),1);

%% Print
if obj.Echo
    fprintf('Successfully mesh geosphere . \n');
end

end

