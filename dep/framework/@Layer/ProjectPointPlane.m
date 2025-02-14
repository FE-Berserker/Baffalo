function obj=ProjectPointPlane(obj,pointno,planeno)
% Project Points to plane
% Author : Xie Yu
%% Parse input
P=[];
for i=1:size(pointno,1)
    P=[P;obj.Points{pointno,1}.P]; %#ok<AGROW> 
end
Plane=obj.Planes(planeno,:);
P_proj=[];
for i=1:size(Plane,1)
    P_proj=[P_proj;projectpointplane(P,Plane(i,:))]; %#ok<AGROW> 
end
obj=AddPoint(obj,P_proj);

%% Print
if obj.Echo
    fprintf('Successfully project point to plane . \n');
end

end

