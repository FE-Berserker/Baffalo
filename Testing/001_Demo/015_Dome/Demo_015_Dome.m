clc
clear
close all
% Demo Dome
% 1. Create Dome1
% 2. Create Dome2
flag=2;
DemoDome(flag);

function DemoDome(flag)
switch flag
    case 1
        a=Point2D('PointAss');
        b=Line2D('LineAss');
        % a=AddPoint(a,[1376/2;1376/2],[0;-601]);
        % a=AddPoint(a,[1376/2;0],[-601;-601]);
        a=AddPoint(a,[0;1376/2],[-601;-601]);
        a=AddPoint(a,[1376/2;1376/2],[-601;0]);
        
        b=AddLine(b,a,1);
        b=AddLine(b,a,2);
        b=CreateRadius(b,1,300);
        Plot(b);

        inputStruct.Curve=b;
        inputStruct.Thickness=repmat(8,size(b.Point.PP,1),1);
        inputStruct.Meshsize=30;
        paramsStruct.Offset="TOP";
        obj= dome.Dome(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot3D(obj,'face_normal',1);

        ANSYS_Output(obj.output.Assembly);
    case 2
        a=Point2D('PointAss');
        b=Line2D('LineAss');
        a=AddPoint(a,[1376/2;1376/2],[0;-601]);
        a=AddPoint(a,[1376/2;200],[-601;-601]);
        b=AddLine(b,a,1);
        b=AddLine(b,a,2);
        b=CreateRadius(b,1,300);
        Plot(b);

        inputStruct.Curve=b;
        inputStruct.Thickness=repmat(8,size(b.Point.PP,1),1);
        inputStruct.Meshsize=30;
        paramsStruct.Offset="TOP";
        obj= dome.Dome(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot3D(obj,'face_normal',1);

        ANSYS_Output(obj.output.Assembly);

end
end
