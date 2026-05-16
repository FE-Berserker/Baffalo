clc
clear
close all
% Test CatiaPart
% case=1 Create caitapart
% case=2 Add Sketches points
% case=3 Add Sketches line
% case=4 Add Sketches Surface2D
% case=5 Rotate about axial

flag=5;

switch flag
    case 1
        Cap=CatiaPart('Part1');
        CatiaOutput(Cap);
    case 2
        Cap=CatiaPart('Part2');
        a=Point2D('Point Ass1');
        x1=-5 + (5+5)*rand(10,1);
        y1=-5 + (5+5)*rand(10,1);
        x2=-5 + (5+5)*rand(10,1);
        y2=-5 + (5+5)*rand(10,1);
        a=AddPoint(a,x1,y1);
        a=AddPoint(a,x2,y2);
        Cap=AddSketch(Cap,a);
        CatiaOutput(Cap);
    case 3
        %% AddLine
        x1=[-1;1];
        y1=[-3;-3];
        a=Point2D('Point Ass1');
        a=AddPoint(a,x1,y1);
        b=Line2D('Line Ass1');
        b=AddLine(b,a,1);
        %% AddCurve
        x2=[0;0.3;-0.3;0];
        y2=[0;-1;-1;0];
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

        Cap=CatiaPart('Part3');
        Cap=AddSketch(Cap,b);
        Cap=AddSketch(Cap,b1);
        Cap=AddSketch(Cap,b2);
        CatiaOutput(Cap);
    case 4
        Cap=CatiaPart('Part4');
        % Semi circle
        a=Point2D('Circle center');
        a=AddPoint(a,0,0);
        a=AddPoint(a,[-5;5],[0;0]);
        b=Line2D('Semi circle');
        b=AddCircle(b,5,a,1,'ang',180);
        b=AddLine(b,a,2);
        S=Surface2D(b);
        Plot(S);
        S=CreateCircleHole(S,1,'scale',0.4);
        Plot(S);

        Cap=AddSketch(Cap,S);
        CatiaOutput(Cap);
    case 5
        Cap=CatiaPart('Part4');
        % Semi circle
        a=Point2D('Circle center');
        a=AddPoint(a,0,0);
        a=AddPoint(a,[-5;5],[0;0]);
        b=Line2D('Semi circle');
        b=AddCircle(b,5,a,1,'ang',180);
        b=AddLine(b,a,2);
        S=Surface2D(b);
        Plot(S);
        S=CreateCircleHole(S,1,'scale',0.4);
        Plot(S);

        Cap=AddSketch(Cap,S);
        Cap=AddNewPad(Cap,1,5);
        CatiaOutput(Cap);


end