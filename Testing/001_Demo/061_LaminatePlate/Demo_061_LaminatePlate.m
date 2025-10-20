% Demo LaminatePlate
clc
clear
close all
plotFlag = true;
% setBaffaloPath
% 1.Laminate Plate demo

flag=1;
obj1=DemoLaminatePlate(flag);

function obj1=DemoLaminatePlate(flag)
switch flag
    case 1
        % Plate 1
        IR=640/2;
        OR=768/2;
        a=Point2D('Point Ass1');
        a=AddPoint(a,0,0);
        b=Line2D('Line Ass1');
        b=AddCircle(b,OR,a,1);
        
        h1=Line2D('Hole Group1');
        h1=AddCircle(h1,IR,a,1);

        load('Ply.mat'); %#ok<LOAD>
        mat1{1,1}=Ply.output.Plyprops;

        inputplate1.Outline= b;
        inputplate1.Hole = h1;
        inputplate1.Orient=repmat([0,90,45,-45]',3,1);
        inputplate1.Tply=repmat(15,12,1);
        inputplate1.Plymat=ones(12,1);
        paramsplate1.Material = mat1;
        obj1=plate.LaminatePlate(paramsplate1, inputplate1);
        obj1 = obj1.solve();

        Plot2D(obj1);
        Plot3D(obj1);
end
end