clc
clear
close all
% Test object Line2D
%% 1 Add different curves
%% 2 Calculate the boundary of points
%% 3 Draw arrow
%% 4 Polygon
%% 5 AddStar
%% 6 DeleteCurve
%% 7 Bounding box
%% 8 Create radius
%% 9 Circle fit
%% 10 Curve Intersection
%% 11 Add Round Polygon
%% 12 Plot Line2D in ParaView
%% 13 Add Nurb curve
%% 14 Convert to nurbs 
%% 15 Add Cell data
%% 16 Max Inscribed Circle
%% 17 ArchFit

flag=17;
testLine2D(flag);
function testLine2D(flag)
switch flag
    case 1
        %% AddLine
        x1=[-1;1];
        y1=[-3;-3];
        a=Point2D('Point Ass1');
        a=AddPoint(a,x1,y1);
        b=Line2D('Line Ass1');
        b=AddLine(b,a,1);
        Plot(b,'clabel',1,'styles',{'-'});
        %% AddCurve
        x2=[0;0.3;-0.3;0];
        y2=[0;-1;-1;0];
        a=AddPoint(a,x2,y2);
        b=AddCurve(b,a,2);
        Plot(b,'clabel',1,'styles',{'-'},'equal',0);
        %% AddCircle
        x3=-3;y3=2;
        x4=3;y4=2;
        x5=0;y5=0;
        a=AddPoint(a,x3,y3);
        a=AddPoint(a,x4,y4);
        a=AddPoint(a,x5,y5);
        b=AddCircle(b,0.5,a,3);
        b=AddCircle(b,0.5,a,4);
        b=AddCircle(b,5,a,5);
        Plot(b,'clabel',1,'styles',{'-'},'equal',1);
        %% AddEllipse
        x6=0;y6=-3;
        a=AddPoint(a,x6,y6);
        b=AddEllipse(b,1,0.5,a,6,'rot',-90,'sang',-90,'ang',180);
        Plot(b,'clabel',1,'styles',{'-'},'equal',1);
        %% AddSpline
        x7=[-4;-3;-2];y7=[2.5;3;2.5];
        a=AddPoint(a,x7,y7);
        b=AddSpline(b,1,a,7);
        Plot(b,'clabel',1,'styles',{'-'},'equal',1);
        %% AddBezier
        x8=[4;3;2];y8=[2.5;3;2.5];
        a=AddPoint(a,x8,y8);
        b=AddBezier(b,a,8);
        Plot(b,'clabel',1,'styles',{'-'},'equal',1);
        %% AddBspline
        x9=[-1.5;0;1.5];y9=[3;3.5;3];
        a=AddPoint(a,x9,y9);
        b=AddBspline(b,3,a,9);
        Plot(b,'clabel',1,'styles',{'-'},'equal',1);
        %% AddHyperbola
        b1=Line2D('Line Ass2');
        b1=AddHyperbola(b1, 2, 1,a,5,'t1',-1,'t2',3);
        b1=AddHyperbola(b1, 1, 1,a,5,'t1',-3,'t2',3);
        b1=AddHyperbola(b1, 2, 1,a,5,'rot',90,'t1',-3,'t2',3);
        Plot(b1,'clabel',1,'styles',{'--'},'equal',1);
        %% AddParabola
        b2=Line2D('Line Ass3');
        b2=AddParabola(b2, 2,a,5,'t1',-1,'t2',3);
        b2=AddParabola(b2, 1,a,5,'t1',-3,'t2',3);
        b2=AddParabola(b2, 2,a,5,'rot',90,'t1',-3,'t2',3);
        Plot(b2,'clabel',1,'styles',{':'},'equal',1);

    case 2
        x1=-5 + (5+5)*rand(20,1);
        y1=-5 + (5+5)*rand(20,1);
        x2=-5 + (5+5)*rand(20,1);
        y2=-5 + (5+5)*rand(20,1);
        a=Point2D('Point Ass1');
        a1=Point2D('Point Ass2');
        a=AddPoint(a,x1,y1);
        a1=AddPoint(a1,x2,y2);
        Plot(a);
        b=Line2D('Line Ass1','Compress',0);
        b1=Line2D('Line Ass1','Compress',0);
        b=Boundary(b,a);
        b=Boundary(b,a,'scale',1);
        b1=Boundary(b1,a1);
        b1=Boundary(b1,a1,'scale',1);
        Plot(b,'map','lch','color',1);
        Plot(b1,'map','lch','color',1);
        L=Layer('Layer 1');
        L=AddElement(L,a,'Transform',[0,0,0,0,0,0]);
        L=AddElement(L,a1,'Transform',[0,0,1,0,0,0]);
        L=AddElement(L,b,'Transform',[0,0,0,0,0,0]);
        L=AddElement(L,b1,'Transform',[0,0,1,0,0,0]);
        Plot(L,'linesmerge',1,'equal',2);
    case 3
        a=Point2D('Point Ass1');
        for i=1:4
            x=[i-1;i-0.5];
            for j=1:3
                y=[j-1;j-0.5];
                a=AddPoint(a,x,y);
            end
        end
        b=Line2D('Line Ass1','Arrow',1,'Form',(1:12)');
        for i=1:12
            b=AddLine(b,a,i);
        end
        Plot(b,'equal',1)
    case 4
        b=Line2D('Line Ass1','Arrow',1,'Adfac',0.01);
        b=AddPolygon(b,1,10,'sang',90,'close',0);
        b=Shift(b,1,2);
        Plot(b,'equal',1,'crv',1);
        Plot(b,'equal',1,'crv',2);
    case 5
        b=Line2D('Line Ass1');
        b=AddStar(b,51,1,'sang',90,'close',1,'anglelimit',0);
        Plot(b,'equal',1,'base_size',0.1);
    case 6
        b=Line2D('Line Ass1');
        b=AddStar(b,11,1,'sang',90,'close',1);
        Plot(b,'equal',1,'base_size',0.1);
        b=DeleteCurve(b,1);
        Plot(b,'equal',1,'base_size',0.1);
    case 7
        points=rand(100,2);
        a=Point2D('Point Ass1');
        a=AddPoint(a,points(:,1),points(:,2));
        b=Line2D('Line Ass1');
        b=BoundingBox(b,a);
        L=Layer('Layer 1');
        L=AddElement(L,a,'Transform',[0,0,0,0,0,0]);
        L=AddElement(L,b,'Transform',[0,0,0,0,0,0]);
        Plot(L,'linesmerge',1);
    case 8
        %% AddLine
        x1=[0;5];y1=[0;5];
        x2=[5;10];y2=[5;0];
        a=Point2D('Point Ass1');
        a=AddPoint(a,x1,y1);
        a=AddPoint(a,x2,y2);
        b=Line2D('Line Ass1');
        b=AddLine(b,a,1);
        b=AddLine(b,a,2);
        Plot(b,'clabel',1);
        b = CreateRadius(b,1,4);
        Plot(b)
    case 9
        % Create data for a circle + noise
        th = linspace(0,2*pi,20)';
        R=1.1111111;
        sigma = R/10;
        x = R*cos(th)+randn(size(th))*sigma;
        y = R*sin(th)+randn(size(th))*sigma;
        a=Point2D('Point Ass1');
        a=AddPoint(a,x,y);
        Plot(a);
        b=Line2D('Line Ass1');
        [b,~,~,~]=CircleFit(b,a,1);
        [b,~,~,~]=CircleFit(b,a,1,'method','Taubin');
        Plot(b);
    case 10
        x=linspace(0,2*pi,100);
        y1=sin(x);
        y2=cos(x);
        plot(x,y1);hold on
        plot(x,y2);hold on
        a=Point2D('Point Ass1');
        a=AddPoint(a,x',y1');
        a=AddPoint(a,x',y2');
        b=Line2D('Line Ass1');
        b=AddCurve(b,a,1);
        b=AddCurve(b,a,2);
        [x0,y0]=CurveIntersection(b,1,2);
        plot(x0,y0,'k*')
    case 11
        b=Line2D('Round Polygon');
        b=AddRoundPolygon(b,5*sqrt(2),4,2,'sang',45);
        Plot(b)
    case 12
        b=Line2D('Round Polygon');
        b=AddRoundPolygon(b,5*sqrt(2),6,2);
        Plot2(b)
    case 13
        Points = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
            3.0 5.5 5.5 1.5 1.5 4.0 4.5]';
        Knots=[0 0 0 1/10 2/5 3/5 4/5 1 1 1];
        b=Line2D('Nurb Test');
        b=AddNurb(b,Points,Knots);
        Plot(b);
        PlotNurbs(b,'coefs',1);
    case 14
        %% AddLine
        x1=[-1;1];
        y1=[-3;-3];
        a=Point2D('Point Ass1');
        a=AddPoint(a,x1,y1);
        b=Line2D('Line Ass1');
        b=AddLine(b,a,1);
        %% AddCurve
        x2=[0;0.15;0.3;-0.3;0];
        y2=[0;-0.5;-1;-1;0];
        a=AddPoint(a,x2,y2);
        b=AddCurve(b,a,2);
        %% AddCircle
        x3=-3;y3=2;
        x4=3;y4=2;
        x5=0;y5=0;
        a=AddPoint(a,x3,y3);
        a=AddPoint(a,x4,y4);
        a=AddPoint(a,x5,y5);
        b=AddCircle(b,0.5,a,3);
        b=AddCircle(b,0.5,a,4);
        b=AddCircle(b,5,a,5);
        %% AddEllipse
        x6=0;y6=-3;
        a=AddPoint(a,x6,y6);
        b=AddEllipse(b,1,0.5,a,6,'rot',-90,'sang',-90,'ang',180);
        %% AddSpline
        x7=[-4;-3;-2];y7=[2.5;3;2.5];
        a=AddPoint(a,x7,y7);
        b=AddSpline(b,1,a,7);
        %% AddBezier
        x8=[4;3;2];y8=[2.5;3;2.5];
        a=AddPoint(a,x8,y8);
        b=AddBezier(b,a,8);
        %% AddBspline
        x9=[-1.5;0;1.5];y9=[3;3.5;3];
        a=AddPoint(a,x9,y9);
        b=AddBspline(b,3,a,9);
        Plot(b,'equal',1);
        for i=1:9
            b=Convert2Nurb(b,i);
        end
        PlotNurbs(b,'equal',1,'coefs',0);
    case 15
        %% AddLine
        x1=[-1;1];
        y1=[-3;-3];
        a=Point2D('Point Ass1');
        a=AddPoint(a,x1,y1);
        b=Line2D('Line Ass1');
        b=AddLine(b,a,1);
        %% AddCurve
        x2=[0;0.15;0.3;-0.3;0];
        y2=[0;-0.5;-1;-1;0];
        a=AddPoint(a,x2,y2);
        b=AddCurve(b,a,2);
        %% AddCircle
        x3=-3;y3=2;
        x4=3;y4=2;
        x5=0;y5=0;
        a=AddPoint(a,x3,y3);
        a=AddPoint(a,x4,y4);
        a=AddPoint(a,x5,y5);
        b=AddCircle(b,0.5,a,3);
        b=AddCircle(b,0.5,a,4);
        b=AddCircle(b,5,a,5);
        %% AddEllipse
        x6=0;y6=-3;
        a=AddPoint(a,x6,y6);
        b=AddEllipse(b,1,0.5,a,6,'rot',-90,'sang',-90,'ang',180);
        %% AddSpline
        x7=[-4;-3;-2];y7=[2.5;3;2.5];
        a=AddPoint(a,x7,y7);
        b=AddSpline(b,1,a,7);
        %% AddBezier
        x8=[4;3;2];y8=[2.5;3;2.5];
        a=AddPoint(a,x8,y8);
        b=AddBezier(b,a,8);
        %% AddBspline
        x9=[-1.5;0;1.5];y9=[3;3.5;3];
        a=AddPoint(a,x9,y9);
        b=AddBspline(b,3,a,9);
        b=AddCellData(b,(1:9)');
        Plot(b,'equal',1);
        Plot2(b)  
    case 16
        b=Line2D('Round Polygon');
        b=AddRoundPolygon(b,5*sqrt(2),4,2);
        b=MaxInscribedCircle(b,1);
        Plot(b)
    case 17
        load N_5 N_5
        a=Point2D('Point Ass');
        a=AddPoint(a,N_5(:,1),N_5(:,2));
        b=Line2D('Line Ass');
        b=AddCurve(b,a,1);
        Plot(b);
        bFit=ArchFit(b,1,0.1,4,1.7);
        Plot(bFit)

end
end