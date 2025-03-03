function obj= AddUserdefinedDisc(obj,NodeNum,Surface2D,MatNum)
% Add Userdefined Disc to Shaft
% Author : Xie Yu
Position=obj.params.Position;
m=Mesh2D('Temp Mesh');
m=AddSurface(m,Surface2D);
Deltax=max(Surface2D.N(:,1))-min(Surface2D.N(:,1));
m=SetSize(m,Deltax/20);
m=Mesh(m);
Face=m.Face;
Vert=m.Vert;
rowdist=ones(1,size(Face,1));
Temp=mat2cell(Face,rowdist);
FacePoint=cellfun(@(x)Vert(x,:),Temp,'UniformOutput',false);
Dens=cellfun(@(x)x.Dens,obj.params.Material,'UniformOutput',false);
Dens=cell2mat(Dens);
Gamma=Dens(MatNum,1);
[Mass0,JT,JP,Xc]=cellfun(@(x)CalG(x,Gamma),FacePoint,'UniformOutput',false);
% Mass calculation
Mass=sum(cell2mat(Mass0));
% JT calculation
JT=sum(cell2mat(JT));
% Center calculation
Xc=sum(cell2mat(Mass0).*cell2mat(Xc))./Mass;
% JP calculation
JP=sum(cell2mat(JP))-Mass*Xc^2;

[obj,NodeNum1]=AddCnode(obj,Xc+obj.input.Shaft.Meshoutput.nodes(NodeNum,1));
warning('The nodenum will adjust according to the mass center .')

% Add Point Mass
obj.input.PointMass=[obj.input.PointMass;NodeNum1,Mass,JT,JP];
% Update Shape
mm=Mesh('Disc Mesh');
RotNum=obj.input.Shaft.Section{1,1}.data(1,end);
mm=Revolve2Solid(mm,m,'Slice',RotNum);
L=obj.output.Shape;
Temp_Position=Position;
Temp_Position(1,1)=obj.input.Shaft.Meshoutput.nodes(NodeNum,1);
L=AddElement(L,mm,'Transform',Temp_Position);
obj.output.Shape=L;
end

function [Mass,JT,JP,Xc]=CalG(Point,Gamma)
x1=Point(1,1);
x2=Point(2,1);
x3=Point(3,1);
y1=Point(1,2);
y2=Point(2,2);
y3=Point(3,2);

xc=(x1+x2+x3)/3;


if y1==0
    y1=1e-10;
end

if y2==0
    y2=1e-10;
end

if y3==0
    y3=1e-10;
end

L1=x2-x1;
L2=x3-x2;
L3=x1-x3;

alpha1=y2/y1;
alpha2=y3/y2;
alpha3=y1/y3;

if abs(alpha1-1)<1e-5
        M1=pi*Gamma*L1*y1^2;
    JT1=0.5*pi*Gamma*L1*y1^4;
    JP1=0.25*pi*Gamma*L1*y1^2*(y1^2+L1^2/3);
    JP1=JP1+M1*(x1/2+x2/2-xc)^2;
else
    M1=pi*Gamma*L1*y1^2*(alpha1^2+alpha1+1)/3;
    JT1=pi*Gamma*L1*y1^4*(alpha1^5-1)/(alpha1-1)/10;
    H1=L1/(y2/y1-1);
    h1=L1/4*(alpha1^2+2*alpha1+3)/(alpha1^2+alpha1+1);
    JP1=pi*Gamma*(L1+H1)*y2^2*(y2^2/20+(L1+H1)^2/80+((L1+H1)/4-h1)^2/3)...
        -pi*Gamma*H1*y1^2*(y1^2/20+H1^2/80+(L1+H1/4-h1)^2/3);
    JP1=JP1+M1*(x2-h1-xc)^2;
end

if abs(alpha2-1)<1e-5
    M2=pi*Gamma*L2*y2^2;
    JT2=0.5*pi*Gamma*L2*y2^4;
    JP2=0.25*pi*Gamma*L2*y2^2*(y2^2+L2^2/3);
    JP2=JP2+M2*(x2/2+x3/2-xc)^2;
else
    M2=pi*Gamma*L2*y2^2*(alpha2^2+alpha2+1)/3;
    JT2=pi*Gamma*L2*y2^4*(alpha2^5-1)/(alpha2-1)/10;
    H2=L2/(y3/y2-1);
    h2=L2/4*(alpha2^2+2*alpha2+3)/(alpha2^2+alpha2+1);
    JP2=pi*Gamma*(L2+H2)*y3^2*(y3^2/20+(L2+H2)^2/80+((L2+H2)/4-h2)^2/3)...
        -pi*Gamma*H2*y2^2*(y2^2/20+H2^2/80+(L2+H2/4-h2)^2/3);
    JP2=JP2+M2*(x3-h2-xc)^2;
end

if abs(alpha3-1)<1e-5 
    M3=pi*Gamma*L3*y3^2;
    JT3=0.5*pi*Gamma*L3*y3^4;
    JP3=0.25*pi*Gamma*L3*y3^2*(y3^2+L3^2/3);
    JP3=JP3+M3*(x3/2+x1/2-xc)^2;
else
    M3=pi*Gamma*L3*y3^2*(alpha3^2+alpha3+1)/3;
    JT3=pi*Gamma*L3*y3^4*(alpha3^5-1)/(alpha3-1)/10;
    H3=L3/(y1/y3-1);
    h3=L3/4*(alpha3^2+2*alpha3+3)/(alpha3^2+alpha3+1);
    JP3=pi*Gamma*(L3+H3)*y1^2*(y1^2/20+(L3+H3)^2/80+((L3+H3)/4-h3)^2/3)...
        -pi*Gamma*H3*y3^2*(y3^2/20+H3^2/80+(L3+H3/4-h3)^2/3);
    JP3=JP3+M3*(x1-h3-xc)^2;
end

Mass=abs(M1+M2+M3);
JT=abs(JT1+JT2+JT3);
JP=abs(JP1+JP2+JP3)+Mass*xc^2;
Xc=xc;
end
