function obj = MeshSphere(obj,n,r,varargin)
% Mesh sphere
% Author : Xie Yu
if nargin<4
    [F,V,~]=geoSphere(n,r);
else
    solidType=varargin{1};
    [F,V,~]=geoSphere(n,r,solidType);
end

obj.Face=F;
obj.Vert=V;
obj.Cb=ones(size(F,1),1);

inputStruct1.stringOpt='-pq2AaY';
obj=Mesh3D(obj,inputStruct1);

%% Print
if obj.Echo
    fprintf('Successfully mesh sphere . \n');
end

end

