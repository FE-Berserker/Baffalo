% 创建一个长500，宽400，中心随机布置10个圆孔的板件
clc
clear
close all
plotFlag = true;
% setBaffaloPath
% 1. Plate
% 2. Plate Outline subdivision，with order 2 element
% 3. Output Shell mesh
% 4. Oupput STL file
% 5. Deform face
flag=5;
obj1=DemoCommmonplate(flag);

function obj1=DemoCommmonplate(flag)
switch flag
    case 1
        % Plate 1
        IR=640/2;
        OR=768/2;
        par=442;
        radius=70;
        R=116/2;
        num=6;
        Rp=460;
        t=30;
        hd=17.5;

        sang=asin(R/OR)/pi*180;
        ang=360/num-2*sang;
        a=Point2D('Point Ass1');
        b=Line2D('Line Ass1','Dtol',1);
        a=AddPoint(a,0,0);

        for i=1:num
            b=AddCircle(b,OR,a,1,'sang',sang+ang-360/num*(i-1),'ang',-ang);
            theta=-360/num/180*pi*(i-1);
            mat=[cos(theta),-sin(theta);sin(theta),cos(theta)];
            p1=mat*[sqrt(OR^2-R^2),par;R,R];
            p1=p1';
            a=AddPoint(a,p1(:,1),p1(:,2));
            b=AddLine(b,a,2+3*(i-1));
            p2=mat*[par;0];
            p2=p2';
            a=AddPoint(a,p2(1,1),p2(1,2));
            b=AddCircle(b,R,a,3+3*(i-1),'sang',90+theta/pi*180,'ang',-180);
            p3=mat*[par,sqrt(OR^2-R^2);-R,-R];
            p3=p3';
            a=AddPoint(a,p3(:,1),p3(:,2));
            b=AddLine(b,a,4+3*(i-1));
        end
        for i=1:num
            b=CreateRadius(b,1+6*(i-1),radius);
            b=CreateRadius(b,5+6*(i-1),radius);
        end
        h1=Line2D('Hole Group1');
        h1=AddCircle(h1,IR,a,1);

        a1=Point2D('Point Ass2');
        a1=AddPoint(a1,Rp,0);
        h2=Line2D('Hole Group2');
        h2=AddCircle(h2,hd/2,a1,1);

        inputplate1.Outline= b;
        inputplate1.Hole = [h1;h2];
        inputplate1.Thickness = t;
        paramsplate1 = struct();
        obj1=plate.Commonplate(paramsplate1, inputplate1);
        obj1 = obj1.solve();
        obj1=MoveFace(obj1,3,[0,0,60],'num',6);
        Plot2D(obj1);
        Plot3D(obj1);
    case 2
        % Plate 1
        IR=640/2;
        OR=768/2;
        par=442;
        radius=70;
        R=116/2;
        num=6;
        Rp=460;
        t=30;
        hd=17.5;

        sang=asin(R/OR)/pi*180;
        ang=360/num-2*sang;
        a=Point2D('Point Ass1');
        b=Line2D('Line Ass1','Dtol',1);
        a=AddPoint(a,0,0);

        for i=1:num
            b=AddCircle(b,OR,a,1,'sang',sang+ang-360/num*(i-1),'ang',-ang);
            theta=-360/num/180*pi*(i-1);
            mat=[cos(theta),-sin(theta);sin(theta),cos(theta)];
            p1=mat*[sqrt(OR^2-R^2),par;R,R];
            p1=p1';
            a=AddPoint(a,p1(:,1),p1(:,2));
            b=AddLine(b,a,2+3*(i-1));
            p2=mat*[par;0];
            p2=p2';
            a=AddPoint(a,p2(1,1),p2(1,2));
            b=AddCircle(b,R,a,3+3*(i-1),'sang',90+theta/pi*180,'ang',-180);
            p3=mat*[par,sqrt(OR^2-R^2);-R,-R];
            p3=p3';
            a=AddPoint(a,p3(:,1),p3(:,2));
            b=AddLine(b,a,4+3*(i-1));
        end
        for i=1:num
            b=CreateRadius(b,1+6*(i-1),radius);
            b=CreateRadius(b,5+6*(i-1),radius);
        end
        h1=Line2D('Hole Group1');
        h1=AddCircle(h1,IR,a,1);

        a1=Point2D('Point Ass2');
        a1=AddPoint(a1,Rp,0);
        h2=Line2D('Hole Group2');
        h2=AddCircle(h2,hd/2,a1,1);

        inputplate1.Outline= b;
        inputplate1.Hole = [h1;h2];
        inputplate1.Thickness = t;
        paramsplate1.Order = 2;
        obj1=plate.Commonplate(paramsplate1, inputplate1);
        obj1 = obj1.solve();
        obj1=MoveFace(obj1,3,[0,0,60],'num',6);
        Plot2D(obj1);
        obj1=OutputSolidModel(obj1,'SubOutline',1);
        obj1=OutputSolidModel(obj1,'SubOutline',1);
        Plot3D(obj1,'faceno',201);
        Plot3D(obj1)
    case 3
        b=Line2D('Round Polygon');
        b=AddRoundPolygon(b,10*sqrt(2),4,2,'sang',45);
        inputplate1.Outline= b;
        inputplate1.Thickness = 2;
        paramsplate1= struct();
        obj1=plate.Commonplate(paramsplate1, inputplate1);
        obj1 = obj1.solve();
        Ass=obj1.output.Assembly1;
        Plot(Ass);
    case 4
        b=Line2D('Round Polygon');
        b=AddRoundPolygon(b,10*sqrt(2),6,2);
        inputplate1.Outline= b;
        inputplate1.Thickness = 2;
        paramsplate1= struct();
        obj1=plate.Commonplate(paramsplate1, inputplate1);
        obj1 = obj1.solve();
        OutputSTL(obj1)
        % Load stl file
        L=Layer('test');
        Name=strcat(obj1.params.Name,'.stl');
        L=STLRead(L,Name);
        Plot(L);
    case 5
        a=Point2D('Points assembly');
        a=AddPoint(a,0,0);
        R1=180;
        r=30;
        a=AddPoint(a,R1,0,'polar','deg');

        Angle1=acos(r/2/R1)*2/pi*180;
        Angle2=(180-Angle1)*2;
        b1=Line2D('OutLine');

        Sang1=180-Angle1/2;
        b1=AddCircle(b1,r,a,2,'sang',Sang1,'ang',Angle1);
        Sang2=-180+Angle1;
        b1=AddCircle(b1,R1,a,1,'Sang',Sang2,'ang',Angle2);

        inputplate1.Outline= b1;
        inputplate1.Thickness = 10;
        inputplate1.Meshsize=5;
        paramsplate1= struct();
        obj1=plate.Commonplate(paramsplate1, inputplate1);
        obj1 = obj1.solve();
        Plot3D(obj1)
        f1=@(r)(sqrt(360^2-r.^2)-360);
        obj1=DeformFace(obj1,f1,1);
        f2=@(r)(sqrt(360^2-r.^2)-360+10);
        obj1=DeformFace(obj1,f2,2);
        Plot3D(obj1);

end
end
