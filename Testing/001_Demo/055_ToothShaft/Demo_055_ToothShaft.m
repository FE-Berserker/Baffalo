clc
clear
close all
% Demo Toothshaft
% 1. Create ToothShaft
% 2. Change tooth type

flag=1;
DemoToothShaft(flag);

function DemoToothShaft(flag)
switch flag

    case 1
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

        inputShaft.Outline= b;
        inputShaft.ToothPos= 12;
        inputShaft.ToothNum= 12;
        inputShaft.ToothWidth= 10;

        paramsShaft.ToothSlice= 5;
        paramsShaft.SlotSlice= 5;

        obj1=shaft.ToothShaft(paramsShaft, inputShaft);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
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

        inputShaft.Outline= b;
        inputShaft.ToothPos= 12;
        inputShaft.ToothNum= 12;
        inputShaft.ToothWidth= 10;

        paramsShaft.ToothSlice= 5;
        paramsShaft.SlotSlice= 5;
        paramsShaft.ToothType= 2;

        obj1=shaft.ToothShaft(paramsShaft, inputShaft);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);

end

end