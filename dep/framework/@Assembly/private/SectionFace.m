function [m,Area]=SectionFace(Section)
% Generate section
% Author : Xie Yu
m=Mesh2D('Mesh1','Echo',0);

switch Section.subtype
    case "I"
        w1=Section.data(1,1);
        w2=Section.data(1,2);
        w3=Section.data(1,3);
        t1=Section.data(1,4);
        t2=Section.data(1,5);
        t3=Section.data(1,6);
        P=[t3/2,w3-t2;w2/2,w3-t2;w2/2,w3;t3/2,w3;-t3/2,w3;-w2/2,w3;...
            -w2/2,w3-t2;-t3/2,w3-t2;...
            -t3/2,t1;-w1/2,t1;-w1/2,0;-t3/2,0;t3/2,0;w1/2,0;w1/2,t1;t3/2,t1];
        Area1=t1*w1;
        Area2=t3*(w3-t1-t2);
        Area3=t2*w2;
        y1=t1/2;
        y2=t1+(w3-t1-t2)/2;
        y3=w3-t2/2;
        y=(Area1*y1+Area2*y2+Area3*y3)/(Area1+Area2+Area3);
        m.Vert=[P(:,1),P(:,2)-y];
        m=AddElements(m,[1,2,3;1,3,4;8,1,4;8,4,5;7,8,5;7,5,6;...
            9,1,8;9,16,1;...
            13,14,15;13,15,16;12,13,16;12,16,9;11,12,9;11,9,10]);
        Area=Area1+Area2+Area3;
    case "HREC"
        w1=Section.data(1,1);
        w2=Section.data(1,2);
        t1=Section.data(1,3);
        t2=Section.data(1,4);
        t3=Section.data(1,5);
        t4=Section.data(1,6);

        P=[w1-t2,w2-t4;w1,w2;0,w2;t1,w2-t4;0,0;t1,t3;...
            w1,0;w1-t2,t3];
        Area1=w1*w2;
        Area2=(w1-t1-t2)*(w2-t3-t4);

        x1=w1/2;
        y1=w2/2;
        x2=t1+(w1-t1-t2)/2;
        y2=t3+(w2-t3-t4)/2;
        x=(Area1*x1-Area2*x2)/(Area1-Area2);
        y=(Area1*y1-Area2*y2)/(Area1-Area2);
        m.Vert=[P(:,1)-x,P(:,2)-y];
        m=AddElements(m,[1,2,3;1,3,4;5,4,3;5,6,4;5,7,6;6,7,8;...
            7,2,8;8,2,1]);
        Area=Area1-Area2;
    case "CSOLID"
        R=Section.data(1,1);
        N=Section.data(1,2);
        Temp=2*pi/N*(0:N-1);

        P=[R*cos(Temp'),R*sin(Temp')];
        P=[P;0,0];
        m.Vert=P;
        m=AddElements(m,[(1:N)',[(2:N)';1],ones(N,1)*(N+1)]);
        Area=pi*R^2;
    case "Z"
        w1=Section.data(1,1);
        w2=Section.data(1,2);
        w3=Section.data(1,3);
        t1=Section.data(1,4);
        t2=Section.data(1,5);
        t3=Section.data(1,6);
        P=[-t3/2,-t1/2;w1-t3/2,-t1/2;w1-t3/2,t1/2;t3/2,t1/2;t3/2,w3-t2/2;-w2+t3/2,w3-t2/2;...
            -w2+t3/2,w3-t2/2*3;-t3/2,w3-t2/2*3];
        Area1=t1*w1;
        Area2=t3*(w3-t1-t2);
        Area3=t2*w2;
        y1=t1/2;
        y2=t1+(w3-t1-t2)/2;
        y3=w3-t2/2;
        x1=(w1-t3/2)/2;
        x2=0;
        x3=-(w2-t3/2)/2;
        y=(Area1*y1+Area2*y2+Area3*y3)/(Area1+Area2+Area3);
        x=(Area1*x1+Area2*x2+Area3*x3)/(Area1+Area2+Area3);
        m.Vert=[P(:,1)-x,P(:,2)-y];
        m=AddElements(m,[1,2,4;2,3,4;4,5,8;1,4,8;8,5,6;7,8,6]);
        Area=Area1+Area2+Area3;
    case "CTUBE"
        Ri=Section.data(1,1);
        Ro=Section.data(1,2);
        if size(Section.data,2)==2
            N=8;
        else
            N=Section.data(1,3);
        end
        Temp=2*pi/N*(0:N-1);

        P=[Ro*cos(Temp'),Ro*sin(Temp');Ri*cos(Temp'),Ri*sin(Temp')];
        m.Vert=P;
        m=AddElements(m,[(1:N)',[(2:N)';1],(N+1:2*N)';(N+1:2*N)',[(2:N)';1],[(N+2:2*N)';N+1]]);
        Area=pi*Ro^2-pi*Ri^2;

end

% Plot(m);

end


