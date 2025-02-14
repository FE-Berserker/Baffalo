function [Area,Center,Ixx,Iyy,Ixy]= CalculateGeometry(obj)
% Calculate mesh Geometry information
% Author : Xie Yu
Face=obj.Face;
Vert=obj.Vert;
rowdist=ones(1,size(Face,1));
Temp=mat2cell(Face,rowdist);
FacePoint=cellfun(@(x)Vert(x,:),Temp,'UniformOutput',false);
[Area0,Center0,Ixx0,Iyy0,Ixy0]=cellfun(@(x)CalG(x),FacePoint,'UniformOutput',false);
Area=sum(cell2mat(Area0));
Center=sum(cell2mat(Area0).*cell2mat(Center0))/Area;
Ixx=sum(cell2mat(Ixx0));
Iyy=sum(cell2mat(Iyy0));
Ixy=sum(cell2mat(Ixy0));
end

function [Area,Center,Ixx,Iyy,Ixy]=CalG(Point)
x1=Point(1,1);
x2=Point(2,1);
x3=Point(3,1);
y1=Point(1,2);
y2=Point(2,2);
y3=Point(3,2);
Area=abs((x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2))/2);
Center(1,1)=1/3*(x1+x2+x3);
Center(1,2)=1/3*(y1+y2+y3);
a1=x1*y2-x2*y1;
a2=x2*y3-x3*y2;
a3=x3*y1-x1*y3;
Ixx=1/12*(a1*(y1^2+y2^2+y1*y2)+...
    a2*(y2^2+y3^2+y2*y3)+...
    a3*(y3^2+y1^2+y3*y1));
Iyy=1/12*(a1*(x1^2+x2^2+x1*x2)+...
    a2*(x2^2+x3^2+x2*x3)+...
    a3*(x3^2+x1^2+x3*x1));
Ixy=1/24*(a1*(x1*y2+2*x1*y1+2*x2*y2+x2*y1)+...
    a2*(x2*y3+2*x2*y2+2*x3*y3+x3*y2)+...
    a3*(x3*y1+2*x3*y3+2*x1*y1+x1*y3));
end

