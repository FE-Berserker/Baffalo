function [Area,Center,Ixx,Iyy,Ixy]=CalculateGeometry(obj)
% Calculate geometry informarion of surface
% Author : Xie Yu
m=Mesh2D('Mesh1','Echo',0);
m=AddSurface(m,obj);
m=Mesh(m);
[Area,Center,Ixx,Iyy,Ixy]= CalculateGeometry(m);
end