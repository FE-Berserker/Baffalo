clc
clear
close all
% Test Object Point2D
% 1 AddPoint
% 2 calculate the distance
% 3 Delete Point
% 4 Plot Point2D in paraview
% 5 Add PointData
% 6 Add PointVector
flag=3;
testPoint(flag);

function testPoint(flag)
switch flag
    case 1
        x=[1;2];
        y=[1;5];

        a=Point2D('Point Ass1');
        a=AddPoint(a,x,y);
        Plot(a,'grid',1,'plabel',1);

        x1=-5 + (5+5)*rand(10,1);
        y1=-5 + (5+5)*rand(10,1);
        a=AddPoint(a,x1,y1);
        Plot(a,'grid',1,'plabel',1,'group',[1;2]);

        x2=[1;2;3;4;2];
        y2=[2;5;3;4;5];
        a=AddPoint(a,x2,y2);
        Plot(a,'grid',1,'plabel',1);
        a=CompressNpts(a,'all',1);
        Plot(a,'grid',1,'plabel',1);

        x1=ones(10,1);
        y1=[0;10;20;30;40;50;60;70;80;90];
        a1=Point2D('Point Ass2');
        a1=AddPoint(a1,x1,y1,'polar','deg');
        Plot(a1,'grid',1,'plabel',1);

        x2=ones(10,1);
        y2=ones(10,1);
        a2=Point2D('Point Ass3');
        a2=AddPoint(a2,x2,y2,'delta',1);
        Plot(a2,'grid',1,'plabel',1);
    case 2
        a=Point2D('Point Ass1');
        x1=-5 + (5+5)*rand(10,1);
        y1=-5 + (5+5)*rand(10,1);
        x2=-5 + (5+5)*rand(10,1);
        y2=-5 + (5+5)*rand(10,1);
        a=AddPoint(a,x1,y1);
        a=AddPoint(a,x2,y2);
        dist=Dist(2,1,a,'group',1); 
        disp(dist)
    case 3
        [X,Y]=meshgrid(0:0.1:1);
        points1=[X(:),Y(:)];
        a=Point2D('Point Ass1');
        a=AddPoint(a, points1(:,1), points1(:,2));
        Plot(a);
        f=@(x,y)(x>0.5 &y>0.2 & y<0.8);
        a=DeletePoint(a,1,'fun',f);
        Plot(a);
    case 4
        [X,Y]=meshgrid(0:0.1:1);
        points1=[X(:),Y(:)];
        a=Point2D('Point Ass1');
        a=AddPoint(a, points1(:,1), points1(:,2));
        f=@(x,y)(x>0.5 &y>0.2 & y<0.8);
        a=DeletePoint(a,1,'fun',f);
        Plot(a);
        Plot2(a);
    case 5
        [X,Y]=meshgrid(0:0.1:1);
        points1=[X(:),Y(:)];
        a=Point2D('Point Ass1');
        a=AddPoint(a, points1(:,1), points1(:,2));
        f=@(x,y)(x>0.5 &y>0.2 & y<0.8);
        a=DeletePoint(a,1,'fun',f);
        a=AddPointData(a,a.P(:,2));
        Plot(a);
    case 6
        a=Point2D('Point Ass1');
        x1=-5 + (5+5)*rand(10,1);
        y1=-5 + (5+5)*rand(10,1);
        u=-1 + 2*rand(10,1);
        v=-1 + 2*rand(10,1);
        a=AddPoint(a,x1,y1);
        a=AddPointVector(a,[u,v]);
        a=AddPointData(a,a.P(:,2));
        Plot(a,'Vector',1,'grid',1,'equal',1)
        Plot2(a)


end
end
