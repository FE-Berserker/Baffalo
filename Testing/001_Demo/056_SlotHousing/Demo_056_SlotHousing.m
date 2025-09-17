clc
clear
close all
% Demo SlotHousing
% 1. Create SlotHousing
% 2. Change tooth type
% 3. Circle groove slot type

flag=3;
DemoSlotHousing(flag);

function DemoSlotHousing(flag)
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
        inputHousing.SlotPos= [12,20];
        inputHousing.SlotNum= 12;
        inputHousing.SlotWidth= 10;
        % inputHOusing.SlotWidth= 16;
        % inputHousing.SlotWidth= 22;
        inputHousing.Meshsize= 1;

        paramsHousing.SlotSlice= 15;
        paramsHousing.ToothSlice= 8;

        obj1=housing.SlotHousing(paramsHousing, inputHousing);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
    case 2
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
        inputHousing.SlotPos= [12,20];
        inputHousing.SlotNum= 12;
        inputHousing.SlotWidth= 10;
        % inputHOusing.SlotWidth= 16;
        % inputHousing.SlotWidth= 22;
        inputHousing.Meshsize= 1;

        paramsHousing.SlotSlice= 15;
        paramsHousing.ToothSlice= 8;
        paramsHousing.ToothType= 2;

        obj1=housing.SlotHousing(paramsHousing, inputHousing);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);

    case 3
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
        inputHousing.SlotPos= [12,20];
        inputHousing.SlotNum= 12;
        inputHousing.SlotWidth= 5;
        inputHousing.Meshsize= 1;

        paramsHousing.LeftLimit=4;
        paramsHousing.SlotSlice= 15;
        paramsHousing.ToothSlice= 8;
        % paramsHousing.ToothType= 1;
        paramsHousing.ToothType= 2;
        paramsHousing.SlotType= 2;
        

        obj1=housing.SlotHousing(paramsHousing, inputHousing);
        obj1=obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);


end

end