% Demo Body
clc
clear
close all
plotFlag = true;
% setBaffaloPath
% 1. Create Body

flag=1;
DemoBody(flag);

function DemoBody(flag)
switch flag
    case 1
        %% WindTurbine Gearbox Torquearm
        lx=400;
        ly=3200;
        lz=2100;
        inputStruct.Space=[lx,ly,lz];% 设计空间长、宽、高
        inputStruct.Meshsize=15; %网格大小 [mm];
        paramsStruct.Name='Torque arm build';
        TorqueArm= body.Body(paramsStruct, inputStruct);
        TorqueArm = TorqueArm.solve();
        Plot3D(TorqueArm)
        %% Basic Circle
        a=Point2D('Point Ass1');
        a=AddPoint(a,[0;0;185;185;210;210;270;160;160;0],...
            [1750/2;1890/2;1890/2;1750/2;1500/2;1200/2;1000/2;1000/2;1500/2;1750/2]);
        b=Line2D('Line Ass1');
        b=AddCurve(b,a,1);
        inputHousing.Outline= b;
        paramsHousing.Degree = 360;
        obj1=housing.Housing(paramsHousing, inputHousing);
        obj1=obj1.solve();
        obj1=OutputSolidModel(obj1);
        Plot3D(obj1);
        %% Support
        a=Point2D('Point Ass1');
        a=AddPoint(a,0,0);
        b=Line2D('Line Ass1');
        b=AddCircle(b,450/2,a,1);

        inputplate1.Outline= b;
        inputplate1.Thickness = 280;
        paramsplate1 = struct();
        obj2=plate.Commonplate(paramsplate1, inputplate1);
        obj2 = obj2.solve();
         obj2=OutputSolidModel(obj2);
        Plot3D(obj2);
        %% Connection
        a=Point2D('Point Ass1');
        a=AddPoint(a,[-145;145;330;330;145;-145;-145],...
            [300;300;380;-380;-300;-300;300]);
        b=Line2D('Line Ass1');
        b=AddCurve(b,a,1);

        inputplate1.Outline= b;
        inputplate1.Thickness = 185;
        paramsplate1 = struct();
        obj3=plate.Commonplate(paramsplate1, inputplate1);
        obj3 = obj3.solve();
        obj3=OutputSolidModel(obj3);
        Plot3D(obj3);
        %% Shaft
        a=Point2D('Point Ass1');
        a=AddPoint(a,0,0);
        b=Line2D('Line Ass1');
        b=AddCircle(b,330/2,a,1);

        inputplate1.Outline= b;
        inputplate1.Thickness = 280;
        paramsplate1 = struct();
        obj4=plate.Commonplate(paramsplate1, inputplate1);
        obj4 = obj4.solve();
        obj4=OutputSolidModel(obj4);
        Plot3D(obj4);
        %% Stiffness
        Stiffness_Num=16;
        a=Point2D('Point Ass1');
        a=AddPoint(a,[185;273;273;210;210;185;185],...
            [1890/2;1750/2;1000/2;1000/2;1200/2;1750/2;1890/2]);
        b=Line2D('Line Ass1');
        b=AddCurve(b,a,1);

        inputplate1.Outline= b;
        inputplate1.Thickness = 80;
        paramsplate1 = struct();
        obj5=plate.Commonplate(paramsplate1, inputplate1);
        obj5 = obj5.solve();
        obj5=OutputSolidModel(obj5);
        Plot3D(obj5);
        %% Lifting hole
        a=Point2D('Point Ass1');
        a=AddPoint(a,[-80;200;200;80;-80;-80],...
            [80;80;-100;-100;-250;80]);
        a=AddPoint(a,0,0);
        b=Line2D('Line Ass1');
        b=AddCurve(b,a,1);
        h=Line2D('hole Ass1');
        h=AddCircle(h,40,a,2);

        inputplate1.Outline= b;
        inputplate1.Hole= h;
        inputplate1.Thickness = 80;
        paramsplate1 = struct();
        obj6=plate.Commonplate(paramsplate1, inputplate1);
        obj6 = obj6.solve();
        obj6=OutputSolidModel(obj6);
        Plot3D(obj6);



        %% Sculpture model
        pos1=[-185/2,0,0,0,0,0];
        TorqueArm=BodyAdd(TorqueArm,obj1.output.SolidMesh,'position',pos1);
        Plot3D(TorqueArm);

        mm1 = obj2.output.SolidMesh;
        pos2=[-280/2,2390/2,0,0,-90,0];  
        TorqueArm=BodyAdd(TorqueArm,mm1,'position',pos2);
        Plot3D(TorqueArm);
        pos3=[-281/2,-2390/2,0,0,-90,0];
        TorqueArm=BodyAdd(TorqueArm,mm1,'position',pos3);
        Plot3D(TorqueArm);

        mm2 = obj3.output.SolidMesh;
        pos4=[-185/2,2390/2,0,90,0,90];
        TorqueArm=BodyAdd(TorqueArm,mm2,'position',pos4);
        Plot3D(TorqueArm);
        pos5=[185/2,-2390/2,0,90,0,-90];
        TorqueArm=BodyAdd(TorqueArm,mm2,'position',pos5);
        Plot3D(TorqueArm);

        mm3 = obj4.output.SolidMesh;
        pos6=[-280/2,2390/2,0,0,-90,0];
        TorqueArm=BodyRemove(TorqueArm,mm3,'position',pos6);
        Plot3D(TorqueArm);
        pos7=[-280/2,-2390/2,0,0,-90,0];
        TorqueArm=BodyRemove(TorqueArm,mm3,'position',pos7);
        Plot3D(TorqueArm);

        mm4 = obj5.output.SolidMesh;
        for i=1:Stiffness_Num
            pos8=[-185/2,0,0,360/Stiffness_Num*(i-1),0,0];
            TorqueArm=BodyAdd(TorqueArm,mm4,'position',pos8);
        end
        Plot3D(TorqueArm);

        mm5 = obj6.output.SolidMesh;
        pos9=[80/2,1580/2,660,-90,0,90];
        TorqueArm=BodyAdd(TorqueArm,mm5,'position',pos9);
        Plot3D(TorqueArm);
        pos10=[-80/2,-1580/2,660,-90,0,-90];
        TorqueArm=BodyAdd(TorqueArm,mm5,'position',pos10);
        Plot3D(TorqueArm);

        TorqueArm=SmoothFace(TorqueArm);
        Plot3D(TorqueArm);
        TorqueArm=SmoothFace(TorqueArm,20);
        Plot3D(TorqueArm);
end
end