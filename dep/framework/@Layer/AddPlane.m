function  obj=AddPlane(obj,P0,N)
% Add Plane to obj
% Author : Xie Yu
plane = createPlane(P0, N);
Num=GetNPlanes(obj);
obj.Planes(Num+1,:)=plane;

%% Print
if obj.Echo
    fprintf('Successfully add plane . \n');
end
end

