function OutputCatiaPart(obj)
% OutputCatiaPart - 输出catiaPart模型
% Author: Xie Yu

K=obj.output.K; % Bolt Head height
l=obj.input.l; % Bolt total length
d=obj.input.d; % Bolt diameter
dw=obj.output.dw;
sw=obj.output.sw;

% Bolt
Cap=CatiaPart(strcat(obj.params.Name,'_Bolt'));
switch obj.params.BoltType
    case 0
        a=Point2D('Center');
        a=AddPoint(a,0,0);
        b1=Line2D('HeadCircle');
        b1=AddCircle(b1,dw/2,a,1);
        b2=Line2D('ShankCircle');
        b2=AddCircle(b2,d/2,a,1);
        Cap=AddSketch(Cap,b1,'Plane','YZ');
        Cap=AddSketch(Cap,b2,'Plane','YZ');
        Cap=AddExtrude(Cap,1,-K);
        Cap=AddExtrude(Cap,2,l);
    case 1
        a=Point2D('Center');
        a=AddPoint(a,0,0);
        b1=Line2D('HeadCircle');
        b1=AddCircle(b1,dw/2,a,1);
        b2=Line2D('ShankCircle');
        b2=AddCircle(b2,d/2,a,1);
        Cap=AddSketch(Cap,b1,'Plane','YZ');
        Cap=AddSketch(Cap,b2,'Plane','YZ');
        Cap=AddExtrude(Cap,1,-K);
        Cap=AddExtrude(Cap,2,l);
    case 2
        a=Point2D('Center');
        a=AddPoint(a,0,0);
        b1=Line2D('HeadCircle');
        b1=AddPolygon(b1,sw/sqrt(3),6);
        b2=Line2D('ShankCircle');
        b2=AddCircle(b2,d/2,a,1);
        Cap=AddSketch(Cap,b1,'Plane','YZ');
        Cap=AddSketch(Cap,b2,'Plane','YZ');
        Cap=AddExtrude(Cap,1,-K);
        Cap=AddExtrude(Cap,2,l);

    case 3
        a=Point2D('Center');
        a=AddPoint(a,0,0);
        b1=Line2D('HeadCircle');
        b1=AddPolygon(b1,sw/sqrt(3),6);
        b2=Line2D('ShankCircle');
        b2=AddCircle(b2,d/2,a,1);
        Cap=AddSketch(Cap,b1,'Plane','YZ');
        Cap=AddSketch(Cap,b2,'Plane','YZ');
        Cap=AddExtrude(Cap,1,-K);
        Cap=AddExtrude(Cap,2,l);
end
CatiaOutput(Cap);
% Nut
if obj.params.Nut==1
    s=obj.output.Nut_s;
    m=obj.output.Nut_m;
    Cap1=CatiaPart(strcat(obj.params.Name,'_Nut'));
    b1=Line2D('Circle');
    b1=AddCircle(b1,d/2,a,1);
    b1=AddPolygon(b1,s/sqrt(3),6);
    Cap1=AddSketch(Cap1,b1,'Plane','YZ');
    Cap1=AddExtrude(Cap1,1,m);
    CatiaOutput(Cap1);
end

% Washer
if obj.params.Washer==1
    d1=obj.output.Washer_d1;
    d2=obj.output.Washer_d2;
    h=obj.output.Washer_h;
    Cap2=CatiaPart(strcat(obj.params.Name,'_Washer'));
    b1=Line2D('Circle');
    b1=AddCircle(b1,d1/2,a,1);
    b1=AddCircle(b1,d2/2,a,1);
    Cap2=AddSketch(Cap2,b1,'Plane','YZ');
    Cap2=AddExtrude(Cap2,1,-h);
    CatiaOutput(Cap2);
end

% NutWasher
if obj.params.NutWasher==1
    d1=obj.output.NutWasher_d1;
    d2=obj.output.NutWasher_d2;
    h=obj.output.NutWasher_h;
    Cap3=CatiaPart(strcat(obj.params.Name,'_NutWasher'));
    b1=Line2D('Circle');
    b1=AddCircle(b1,d1/2,a,1);
    b1=AddCircle(b1,d2/2,a,1);
    Cap3=AddSketch(Cap3,b1,'Plane','YZ');
    Cap3=AddExtrude(Cap3,1,h);
    CatiaOutput(Cap3);
end



end
