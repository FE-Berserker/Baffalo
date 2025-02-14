function obj=ProjectCurvePlane(obj,lineno,planeno)
% Project curve to planes
% Author : Xie Yu
%% Parse input
P=[];
for i=1:size(lineno,1)
    P=[P;obj.Lines{lineno,1}.P]; %#ok<AGROW> 
end
Plane=obj.Planes(planeno,:);
P_proj=[];
for i=1:size(Plane,1)
    P_proj=[P_proj;projectpointplane(P,Plane(i,:))]; %#ok<AGROW> 
end
obj=AddCurve(obj,P_proj);

%% Print
if obj.Echo
    fprintf('Successfully project curve to plane . \n');
end
end

