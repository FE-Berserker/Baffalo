clc
clear
close all
% Demo PolygonHousing
% 1. Create PolygonHousing

flag=1;
DemoPolygonHousing(flag);

function DemoPolygonHousing(flag)
switch flag

    case 1
        a=Point2D('Point Ass1');
        a=AddPoint(a,[0;4],[110/2;110/2]);
        a=AddPoint(a,[4;4],[110/2;100/2]);
        a=AddPoint(a,[4;30],[100/2;100/2]);
        a=AddPoint(a,[30;30],[100/2;90/2]);
        a=AddPoint(a,[30;1],[90/2;90/2]);
        a=AddPoint(a,[1;0],[90/2;92/2]);
        a=AddPoint(a,[0;0],[92/2;110/2]);

        b=Line2D('Line Ass1');
        for i=1:7
        b=AddCurve(b,a,i);
        end

        inputHousing.Outline= b;
        inputHousing.EdgeNum= 6;
        inputHousing.r= 10;
        inputHousing.Meshsize= 1;

        paramsHousing=struct();

        obj1=housing.PolygonHousing(paramsHousing, inputHousing);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
    
end

end