function obj=CurveOffset(obj,LinesNum,dis)
V=obj.Lines{LinesNum,1}.P;
p1=mean(V,1); %Curve center

vf=-vecnormalize(V-[V(2:end,:);V(1,:)]); %Allong curve path vectors
vb=vecnormalize(V-[V(end,:);V(1:end-1,:)]); %Allong curve path vectors
v=(vf+vb)/2;

r=vecnormalize(V-p1); %Position vector wrt mean
v1=vecnormalize(cross(v,r)); %perimeter quasi Z-vectors
n=vecnormalize(cross(v1(ones(size(v,1),1),:),v)); %Outward normal vectors
Vn=(V+n*dis); %Offset to create new curve

obj=AddCurve(obj,Vn);
end

