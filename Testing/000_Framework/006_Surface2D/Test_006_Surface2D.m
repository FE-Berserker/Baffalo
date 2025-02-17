clc
clear
close all
% Test object Surface2D
%% 1 Create gear obj
%% 2 Create plate obj
%% 3 Calculate geometry
%% 4 Plot Surface2D inParaView
%% 5 Create Mesh Hole
%% 6 Create Circle Hole
flag=6;
testSurface2D(flag);
function testSurface2D(flag)
switch flag
    case 1
        a=Point2D('Point Ass1');
        neg=8;
        OR1=2.5;OR2=2;IR=1;
        D_theta=3/180*pi;
        a=AddPoint(a,0,0);
        for i=1:neg
            x1=OR1*cos(pi/neg/2-D_theta-pi/neg*2*(i-1));
            y1=OR1*sin(pi/neg/2-D_theta-pi/neg*2*(i-1));
            x2=OR1*cos(-pi/neg/2+D_theta-pi/neg*2*(i-1));
            y2=OR1*sin(-pi/neg/2+D_theta-pi/neg*2*(i-1));
            x3=OR2*cos(-pi/neg/2-pi/neg*2*(i-1));
            y3=OR2*sin(-pi/neg/2-pi/neg*2*(i-1));
            x4=OR2*cos(-pi/neg/2*3-pi/neg*2*(i-1));
            y4=OR2*sin(-pi/neg/2*3-pi/neg*2*(i-1));
            x5=OR1*cos(pi/neg/2-D_theta-pi/neg*2*i);
            y5=OR1*sin(pi/neg/2-D_theta-pi/neg*2*i);
            xx=[x1;x2];yy=[y1;y2];
            a=AddPoint(a,xx,yy);
            xx=[x2;x3];yy=[y2;y3];
            a=AddPoint(a,xx,yy);
            xx=[x3;x4];yy=[y3;y4];
            a=AddPoint(a,xx,yy);
            xx=[x4;x5];yy=[y4;y5];
            a=AddPoint(a,xx,yy);
        end
        Plot(a);
        b=Line2D('Line Ass1');
        for i=1:neg
            b=AddLine(b,a,2+(i-1)*4);
            b=AddLine(b,a,3+(i-1)*4);
            b=AddCircle(b,OR2,a,1,'sang',-180/neg/2-180/neg*2*(i-1),'ang',-180/neg);
            b=AddLine(b,a,5+(i-1)*4);
        end

        Plot(b);
        S=Surface2D(b);
        Plot(S);

        a1=Point2D('Point Group2');
        a1=AddPoint(a1,0,0);
        h=Line2D('Hole Group1');
        h=AddCircle(h,IR,a1,1);
        S=AddHole(S,h);
        Plot(S);

    case 2
        IR=211/2;
        OR=801/2;
        radius1=300/2;
        radius2=600/2;
        num=6;
        par1=100;
        ang1=360/num-asin(par1/2/radius1)/pi*180*2;
        ang2=360/num-asin(par1/2/radius2)/pi*180*2;

        a=Point2D('Point Ass1');
        b=Line2D('Line Ass1');
        a=AddPoint(a,0,0);
        a=AddPoint(a,par1,0);
        a=AddPoint(a,[radius1*cos(ang1/2/180*pi);radius2*cos(ang2/2/180*pi)],...
            [radius1*sin(ang1/2/180*pi);radius2*sin(ang2/2/180*pi)]);
        a=AddPoint(a,[radius2*cos(-ang2/2/180*pi);radius1*cos(-ang1/2/180*pi)],...
            [radius2*sin(-ang2/2/180*pi);radius1*sin(-ang1/2/180*pi)]);
        b=AddCircle(b,OR,a,1);
        S=Surface2D(b);
        
        h1=Line2D('Hole Group1');
        h1=AddCircle(h1,IR,a,1);
        S=AddHole(S,h1);

        h2=Line2D('Hole Group2');
        h2=AddCircle(h2,radius1,a,1,'sang',-ang1/2,'ang',ang1);
        h2=AddLine(h2,a,3);
        h2=AddCircle(h2,radius2,a,1,'sang',ang2/2,'ang',-ang2);
        h2=AddLine(h2,a,4);
        h2=CreateRadius(h2,1,10);
        h2=CreateRadius(h2,3,10);
        h2=CreateRadius(h2,5,10);
        h2=CreateRadius(h2,7,10);

        for i=1:num
        S=AddHole(S,h2,'rot',360/num*(i-1));
        end

        Plot(S);
    case 3
        % Semi circle
        a=Point2D('Circle center');
        a=AddPoint(a,0,0);
        a=AddPoint(a,[-5;5],[0;0]);
        b=Line2D('Semi circle');
        b=AddCircle(b,5,a,1,'ang',180);
        b=AddLine(b,a,2);
        S=Surface2D(b);
        Plot(S);
        [Area,Center,Ixx,Iyy,Ixy]= CalculateGeometry(S);
        disp([Area,Center,Ixx,Iyy,Ixy])
    case 4
        IR=211/2;
        OR=801/2;
        radius1=300/2;
        radius2=600/2;
        num=6;
        par1=100;
        ang1=360/num-asin(par1/2/radius1)/pi*180*2;
        ang2=360/num-asin(par1/2/radius2)/pi*180*2;

        a=Point2D('Point Ass1');
        b=Line2D('Line Ass1');
        a=AddPoint(a,0,0);
        a=AddPoint(a,par1,0);
        a=AddPoint(a,[radius1*cos(ang1/2/180*pi);radius2*cos(ang2/2/180*pi)],...
            [radius1*sin(ang1/2/180*pi);radius2*sin(ang2/2/180*pi)]);
        a=AddPoint(a,[radius2*cos(-ang2/2/180*pi);radius1*cos(-ang1/2/180*pi)],...
            [radius2*sin(-ang2/2/180*pi);radius1*sin(-ang1/2/180*pi)]);
        b=AddCircle(b,OR,a,1);
        S=Surface2D(b);

        h1=Line2D('Hole Group1');
        h1=AddCircle(h1,IR,a,1);
        S=AddHole(S,h1);

        h2=Line2D('Hole Group2');
        h2=AddCircle(h2,radius1,a,1,'sang',-ang1/2,'ang',ang1);
        h2=AddLine(h2,a,3);
        h2=AddCircle(h2,radius2,a,1,'sang',ang2/2,'ang',-ang2);
        h2=AddLine(h2,a,4);
        h2=CreateRadius(h2,1,10);
        h2=CreateRadius(h2,3,10);
        h2=CreateRadius(h2,5,10);
        h2=CreateRadius(h2,7,10);

        for i=1:num
            S=AddHole(S,h2,'rot',360/num*(i-1));
        end
        Plot2(S);
    case 5
        % Semi circle
        a=Point2D('Circle center');
        a=AddPoint(a,0,0);
        a=AddPoint(a,[-5;5],[0;0]);
        b=Line2D('Semi circle');
        b=AddCircle(b,5,a,1,'ang',180);
        b=AddLine(b,a,2);
        S=Surface2D(b);
        Plot(S);
        S=CreateMeshHole(S,0.5,'scale',0.4);
        Plot(S);
        S=CreateMeshHole(S,0.1,'scale',0.4);
        Plot(S);
    case 6
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
        S=CreateCircleHole(S,0.3,'scale',0.4);
        Plot(S);

end
end