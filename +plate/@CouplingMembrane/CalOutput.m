function obj=CalOutput(obj,varargin)
% Calculate shape of CouplingMembrane
% Author: Xie Yu

a=Point2D('TempPoint','Echo',0);
b1=Line2D('TempLine','Echo',0);
h1=Line2D('TempHole','Echo',0);
h2=Line2D('TempHole','Echo',0);
GeomData=obj.input.GeomData;


switch obj.params.Type
    case 1
        D1=GeomData(1);
        D2=GeomData(2);
        D3=GeomData(3);
        D4=GeomData(4);

        a=AddPoint(a,0,0);
        a=AddPoint(a,D3/2,0);
        b1=AddCircle(b1,D2/2,a,1);
        h1=AddCircle(h1,D1/2,a,1);
        h2=AddCircle(h2,D4/2,a,2);

    case 2
        D1=GeomData(1);
        D2=GeomData(2);
        D3=GeomData(3);
        D4=GeomData(4);
        r=GeomData(5);
        a=AddPoint(a,0,0);
        a=AddPoint(a,D3/2,0);
        b1=AddRoundPolygon(b1,D2/2+r*(sqrt(2)-1),obj.input.HoleNum,r);
        h1=AddCircle(h1,D1/2,a,1);
        h2=AddCircle(h2,D4/2,a,2);
    case 3
        D1=GeomData(1);
        D2=GeomData(2);
        D3=GeomData(3);
        D4=GeomData(4);
        D5=GeomData(5);
        D6=GeomData(6);
        Num=obj.input.HoleNum;
        a=AddPoint(a,0,0);
        a=AddPoint(a,D3/2,0);

        alpha1=pi/Num;
        alpha2=asin((D5/2*cos(alpha1)-D2/2)/D6*2);
        alpha3=atan((D5/2*sin(alpha1)-D6/2*cos(alpha2))/D2*2);
        alpha4=pi/2-alpha1-alpha2;

        for i=1:Num
            a=AddPoint(a,D5/2*cos(pi/Num-2*pi/Num*i),D5/2*sin(pi/Num-2*pi/Num*i));
            a=AddPoint(a,[D2/2/cos(alpha3)*cos(alpha3-2*alpha1*(i-1));D2/2/cos(alpha3)*cos(-alpha3-2*alpha1*(i-1))],...
                [D2/2/cos(alpha3)*sin(alpha3-2*alpha1*(i-1));D2/2/cos(alpha3)*sin(-alpha3-2*alpha1*(i-1))]);
            b1=AddLine(b1,a,4+2*(i-1));
            b1=AddCircle(b1,D6/2,a,3+2*(i-1),'sang',90+alpha2/pi*180+(2*alpha4+2*alpha2-pi)*(i-1)/pi*180,'ang',alpha4*2/pi*180);
        end
        h1=AddCircle(h1,D1/2,a,1);
        h2=AddCircle(h2,D4/2,a,2);
    case 4
        D1=GeomData(1);
        D2=GeomData(2);
        D3=GeomData(3);
        D4=GeomData(4);
        D5=GeomData(5);
        % D6=GeomData(6);
        Num=obj.input.HoleNum;
        a=AddPoint(a,0,0);
        a=AddPoint(a,D3/2,0);

        alpha1=pi/Num;
        alpha2=atan((D5/2*cos(alpha1)-D3/2)/(D5/2*sin(alpha1)));
        alpha5=pi/2-alpha1-alpha2;
        r6=D5/2*sin(alpha1)/cos(alpha2)-(D2-D3)/2;
        alpha3=pi/2-alpha2;

        for i=1:Num
            a=AddPoint(a,D5/2*cos(pi/Num-2*pi/Num*i),D5/2*sin(pi/Num-2*pi/Num*i));
            a=AddPoint(a,D3/2*cos(-2*pi/Num*(i-1)),D3/2*sin(-2*pi/Num*(i-1)));
            % b1=AddCircle(b1,(D2-D3)/2,a,4+2*(i-1),'sang',alpha2/pi*180-alpha1/pi*180*2*(i-1),'ang',360);
             % b1=AddCircle(b1,D6/2,a,3+2*(i-1),'sang',90+alpha2/pi*180+(2*alpha4+2*alpha2-pi)*(i-1)/pi*180,'ang',360);
            b1=AddCircle(b1,(D2-D3)/2,a,4+2*(i-1),'sang',alpha3/pi*180-alpha1/pi*180*2*(i-1),'ang',-alpha3*2/pi*180);
            b1=AddCircle(b1,r6,a,3+2*(i-1),'sang',90+alpha2/pi*180+(2*alpha5+2*alpha2-pi)*(i-1)/pi*180,'ang',alpha5*2/pi*180);
        end
        h1=AddCircle(h1,D1/2,a,1);
        h2=AddCircle(h2,D4/2,a,2);
end


inputplate.Outline= b1;
inputplate.Hole = [h1;h2];
inputplate.Thickness = obj.input.Thickness;

paramsplate.Order = obj.params.Order;
paramsplate.Echo=0;
paramsplate.Material=obj.params.Material;
paramsplate.Name=obj.params.Name;
paramsplate.Order=obj.params.Order;
paramsplate.N_Slice=obj.params.N_Slice;
paramsplate.Offset=obj.params.Offset;

obj1=plate.Commonplate(paramsplate, inputplate);
obj1=obj1.solve();
obj1=MoveFace(obj1,3,[0,0,360/obj.input.HoleNum],'num',obj.input.HoleNum);

obj.output.Surface=obj1.output.Surface;
obj.output.SolidMesh=obj1.output.SolidMesh;
obj.output.ShellMesh=obj1.output.ShellMesh;
obj.output.Assembly=obj1.output.Assembly;
obj.output.Assembly1=obj1.output.Assembly1;

%% Print
if obj.params.Echo
    fprintf('Successfully calculate output .\n');
end
end