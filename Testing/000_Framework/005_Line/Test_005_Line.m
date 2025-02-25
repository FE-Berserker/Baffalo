clc
clear
close all
% Test object Line
% 1 Add different curves
% 2 Insert new knots
% 3 Move curve
% 4 Rotate curve
% 5 Scale curve
flag=1;
testLine(flag);
function testLine(flag)
switch flag
    case 1
        %% AddLine
        a=Point('Point Ass1');
        a=AddPoint(a,[0;5],[0;4],[0;2]);
        b=Line('Line Ass1');
        b=AddLine(b,a,1);
        Plot(b,'clabel',1,'styles',{'-'});
        %% AddCurve
        P = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
            3.0 5.5 5.5 1.5 1.5 4.0 4.5;
            0.0 0.0 0.0 0.0 0.0 0.0 0.0];
        a=AddPoint(a,P(1,:)',P(2,:)',P(3,:)');
        b=AddCurve(b,a,2);
        Plot(b,'clabel',1,'styles',{'-'});
        %% AddCircle
        a=AddPoint(a,0,0,5);
        b=AddCircle(b,2.5,a,3);
        b=AddCircle(b,3,a,3,'rot',[45,45,45]);
        Plot(b,'clabel',1,'styles',{'-'});
        %% AddEllipse
        b=AddEllipse(b,6,3,a,3,'rot',[0,-90,0],'sang',-90,'ang',180);
        Plot(b,'clabel',1,'styles',{'-'});
        %% AddNurb
        coefs = [0.0 7.5 15.0 25.0 35.0 30.0 27.5 30.0;
            0.0 2.5  0.0 -5.0  5.0 15.0 22.5 30.0;
            0 0 0 0 0 0 0 0]';
        knots = [0.0 0.0 0.0 1/6 1/3 1/2 2/3 5/6 1.0 1.0 1.0];
        b=AddNurb(b,coefs,knots);
        Plot(b,'clabel',1,'styles',{'-'});
    case 2
        coefs = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
            3.0 5.5 5.5 1.5 1.5 4.0 4.5;
            0.0 0.0 0.0 0.0 0.0 0.0 0.0]';
        knots=[0 0 0 1/10 2/5 3/5 4/5 1 1 1];
        b=Line('Line Ass1');
        b=AddNurb(b,coefs,knots);
        Plot(b,'coefs',1);
        b=InsertKnots(b,1,[0.125 0.375 0.625 0.875]);
        Plot(b,'coefs',1);
    case 3
        coefs = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
            3.0 5.5 5.5 1.5 1.5 4.0 4.5;
            0.0 0.0 0.0 0.0 0.0 0.0 0.0]';
        knots=[0 0 0 1/10 2/5 3/5 4/5 1 1 1];
        b=Line('Line Ass1');
        b=AddNurb(b,coefs,knots);
        b=Move(b,1,[0,0,5],'new',1);
        Plot(b);
    case 4
        coefs = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
            3.0 5.5 5.5 1.5 1.5 4.0 4.5;
            0.0 0.0 0.0 0.0 0.0 0.0 0.0]';
        knots=[0 0 0 1/10 2/5 3/5 4/5 1 1 1];
        b=Line('Line Ass1');
        b=AddNurb(b,coefs,knots);
        b=Move(b,1,[0,0,5],'new',1);
        b=Rotate(b,2,[0,0,90]);
        Plot(b);
    case 5
        coefs = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
            3.0 5.5 5.5 1.5 1.5 4.0 4.5;
            0.0 0.0 0.0 0.0 0.0 0.0 0.0]';
        knots=[0 0 0 1/10 2/5 3/5 4/5 1 1 1];
        b=Line('Line Ass1');
        b=AddNurb(b,coefs,knots);
        b=Move(b,1,[0,0,5],'new',1);
        b=Scale(b,2,[0.5,0.5,1]);
        Plot(b);

end
end