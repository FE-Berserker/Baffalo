clc
clear
close all
% Demo BossPlate
% 1. Create Boss plate 1
% 2. Deform the plate face
% 3. Extrude outsize surface
% 4. Add outer part holes
flag=4;
DemoBossPlate(flag);

function DemoBossPlate(flag)
switch flag
    case 1
        a=Point2D('Points assembly');
        a=AddPoint(a,0,0);
        Num=8;
        R1=180;
        R2=120;
        R3=30;
        r=30;
        for i=1:Num
            a=AddPoint(a,R1,-360/Num*(i-1),'polar','deg');
        end
        Angle1=acos(r/2/R1)*2/pi*180;
        Angle2=360/Num-(180-Angle1)*2;
        b1=Line2D('OutLine');
        for i=1:Num
            Sang1=180-Angle1/2-(i-1)*360/Num;
            b1=AddCircle(b1,r,a,i+1,'sang',Sang1,'ang',Angle1);
            Sang2=-180+Angle1-(i-1)*360/Num;
            b1=AddCircle(b1,R1,a,1,'Sang',Sang2,'ang',-Angle2);
        end

        b2=Line2D('MidLine');
        b2=AddCircle(b2,R2,a,1);
        b3=Line2D('InnerLine');
        b3=AddCircle(b3,R3,a,1);

        inputStruct.OutLine=b1;
        inputStruct.MidLine=b2;
        inputStruct.InnerLine=b3;
        inputStruct.BossHeight=100;
        inputStruct.PlateThickness=30;
        inputStruct.Meshsize=10;
        paramsStruct=struct();
        obj= plate.BossPlate(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot2D(obj);
        Plot3D(obj);
    case 2
        a=Point2D('Points assembly');
        a=AddPoint(a,0,0);
        Num=8;
        R1=180;
        R2=120;
        R3=30;
        r=30;
        for i=1:Num
            a=AddPoint(a,R1,-360/Num*(i-1),'polar','deg');
        end
        Angle1=acos(r/2/R1)*2/pi*180;
        Angle2=360/Num-(180-Angle1)*2;
        b1=Line2D('OutLine');
        for i=1:Num
            Sang1=180-Angle1/2-(i-1)*360/Num;
            b1=AddCircle(b1,r,a,i+1,'sang',Sang1,'ang',Angle1);
            Sang2=-180+Angle1-(i-1)*360/Num;
            b1=AddCircle(b1,R1,a,1,'Sang',Sang2,'ang',-Angle2);
        end

        b2=Line2D('MidLine');
        b2=AddCircle(b2,R2,a,1);
        b3=Line2D('InnerLine');
        b3=AddCircle(b3,R3,a,1);

        inputStruct.OutLine=b1;
        inputStruct.MidLine=b2;
        inputStruct.InnerLine=b3;
        inputStruct.BossHeight=100;
        inputStruct.PlateThickness=30;
        inputStruct.Meshsize=10;
        paramsStruct=struct();
        obj= plate.BossPlate(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot3D(obj);
        f1=@(r)(sqrt(360^2-r.^2)-360);
        obj=DeformFace(obj,f1,1);
        f2=@(r)(sqrt(360^2-r.^2)-360+30);
        obj=DeformFace(obj,f2,2);
        Plot3D(obj);
    case 3
        a=Point2D('Points assembly');
        a=AddPoint(a,0,0);
        Num=8;
        R1=180;
        R2=120;
        R3=30;
        r=30;
        for i=1:Num
            a=AddPoint(a,R1,-360/Num*(i-1),'polar','deg');
        end
        Angle1=acos(r/2/R1)*2/pi*180;
        Angle2=360/Num-(180-Angle1)*2;
        b1=Line2D('OutLine');
        for i=1:Num
            Sang1=180-Angle1/2-(i-1)*360/Num;
            b1=AddCircle(b1,r,a,i+1,'sang',Sang1,'ang',Angle1);
            Sang2=-180+Angle1-(i-1)*360/Num;
            b1=AddCircle(b1,R1,a,1,'Sang',Sang2,'ang',-Angle2);
        end

        b2=Line2D('MidLine');
        b2=AddCircle(b2,R2,a,1);
        b3=Line2D('InnerLine');
        b3=AddCircle(b3,R3,a,1);

        inputStruct.OutLine=b1;
        inputStruct.MidLine=b2;
        inputStruct.InnerLine=b3;
        inputStruct.BossHeight=100;
        inputStruct.PlateThickness=30;
        inputStruct.Meshsize=10;
        paramsStruct.Type=2;
        obj= plate.BossPlate(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot3D(obj);
        f1=@(r)(sqrt(360^2-r.^2)-360);
        obj=DeformFace(obj,f1,1);
        f2=@(r)((sqrt(360^2-r.^2)-360+30).*(r<=120+0.1));
        obj=DeformFace(obj,f2,2);
        Plot3D(obj);
    case 4
        r1=81/2;
        r2=52/2;
        r3=32/2;
        rp=66/2;
        a=Point2D('Points assembly');
        a=AddPoint(a,0,0);
        b1=Line2D('OutLine');
        b1=AddCircle(b1,r1,a,1);
        b2=Line2D('MidLine');
        b2=AddCircle(b2,r2,a,1);
        b3=Line2D('InnerLine');
        b3=AddCircle(b3,r3,a,1);

        h1=Line2D('Hole');
        h2=Line2D('Hole');
        h3=Line2D('Hole');
        h4=Line2D('Hole');

        a=AddPoint(a,rp,0);
        a=AddPoint(a,0,rp);
        a=AddPoint(a,-rp,0);
        a=AddPoint(a,0,-rp);

        h1=AddCircle(h1,6.1/2,a,2);
        h2=AddCircle(h2,11.5/2,a,3);
        h3=AddCircle(h3,6.1/2,a,4);
        h4=AddCircle(h4,11.5/2,a,5);

        inputStruct.OutLine=b1;
        inputStruct.MidLine=b2;
        inputStruct.InnerLine=b3;
        inputStruct.BossHeight=16;
        inputStruct.PlateThickness=10;
        inputStruct.Meshsize=10;
        inputStruct.OuterHole=[h1;h2;h3;h4];
        paramsStruct.Type=1;
        obj= plate.BossPlate(paramsStruct, inputStruct);
        obj= obj.solve();
        Plot3D(obj);

end
end
