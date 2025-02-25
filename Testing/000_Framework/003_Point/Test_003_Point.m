clc
clear
close all
% Test Object Point
% 1 AddPoint
% 2 Calculate normal
flag=2;
testPoint(flag);

function testPoint(flag)
switch flag
    case 1
        data=load('lion.xyz');
        a=Point('Point Ass1');
        a=AddPoint(a,data(:,1),data(:,2),data(:,3));
        a=AddPointData(a,data(:,4));
        Plot(a);
        Plot2(a);
    case 2
        data=load('lion.xyz');
        a=Point('Point Ass1');
        a=AddPoint(a,data(:,1),data(:,2),data(:,3));
        a=AddPointData(a,data(:,4));
        a=CalNormals(a,2);
        Plot(a,'Normal',1,'VectorScale',5);
        Plot2(a,'Normal',1);
end
end
