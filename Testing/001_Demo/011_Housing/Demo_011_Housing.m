clc
clear
close all
% Demo Housing
% 1. Create Housing
% 2. Thin wall bushing

flag=2;
DemoHousing(flag);

function DemoHousing(flag)
switch flag
    case 1
        a=Point2D('Point Ass1');
        a=AddPoint(a,[-5;-5],[100;110]);
        a=AddPoint(a,[-5;5],[110;110]);
        a=AddPoint(a,[5;5],[110;100]);
        a=AddPoint(a,[5;-5],[100;100]);
        a=AddPoint(a,0,105);
        b=Line2D('Line Ass1');
        b=AddCurve(b,a,1);
        b=AddCurve(b,a,2);
        b=AddCurve(b,a,3);
        b=AddCurve(b,a,4);

        h1=Line2D('Hole Ass1');
        h1=AddCircle(h1,1,a,5);

        inputHousing.Outline= b;
        inputHousing.Hole = h1;
        paramsHousing.Degree = 360;
        
        obj1=housing.Housing(paramsHousing, inputHousing);
        obj1=obj1.solve();
        Plot2D(obj1);
%         obj1=OutputSolidModel(obj1,'SubOutline',0);
        obj1=OutputSolidModel(obj1,'SubOutline',1);
        Plot3D(obj1,'faceno',101);
    case 2
        a=Point2D('Point Ass1');
        a=AddPoint(a,[0;4],[110/2;110/2]);
        a=AddPoint(a,[4;4],[110/2;100/2]);
        a=AddPoint(a,[4;18],[100/2;100/2]);
        a=AddPoint(a,[18;18],[100/2;90/2]);
        a=AddPoint(a,[18;1],[90/2;90/2]);
        a=AddPoint(a,[1;0],[90/2;92/2]);
        a=AddPoint(a,[0;0],[92/2;110/2]);

        b=Line2D('Line Ass1');
        for i=1:7
        b=AddCurve(b,a,i);
        end

        inputHousing.Outline= b;
        inputHousing.Meshsize= 2;
        paramsHousing.Degree = 360;
        paramsHousing.N_Slice=72;

        obj1=housing.Housing(paramsHousing, inputHousing);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);

end

end