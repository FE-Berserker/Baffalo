function obj = CreateRadius(obj,l1,Radius)
% Create radius of curves
% Author : Xie Yu
% Check the end point and start point

if l1==size(obj.Point.PP,1)
    l2=1;
else
    l2=l1+1;
end
p1=obj.Point.PP{l1,1};
p2=obj.Point.PP{l2,1};
EP=p1(end,:);
SP=p2(1,:);
dis=sqrt((SP(1,1)-EP(1,1))^2+(SP(1,2)-EP(1,2))^2);
if dis>obj.Dtol
    error('Lines have no common point!')
end

% Judge direction
v1=([0,-1;1,0]*(EP-p1(end-1,:))')';
v2=p2(2,:)-SP;
ang=acos(dot(v1,v2)/(norm(v1)*norm(v2)))/pi*180;
if ang>90
    output1 = AddLineThickness(obj,l1,repmat(Radius,size(p1,1)-1,1),-90,'add',0);
    output2 = AddLineThickness(obj,l2,repmat(Radius,size(p2,1)-1,1),-90,'add',0);
else
    output1 = AddLineThickness(obj,l1,repmat(Radius,size(p1,1)-1,1),90,'add',0);
    output2 = AddLineThickness(obj,l2,repmat(Radius,size(p2,1)-1,1),90,'add',0);
end
[x0,y0,iout,jout] = intersections(output1(:,1),output1(:,2),output2(:,1),output2(:,2));

p11=p1(floor(iout),:);
p12=p1(floor(iout)+1,:);
dx1=p12(1,1)-p11(1,1);
dy1=p12(1,2)-p11(1,2);
Radius_p1=[p11(1,1)+(iout-floor(iout))*dx1,p11(1,2)+(iout-floor(iout))*dy1];


p21=p2(floor(jout),:);
if floor(jout)==size(p2,1)
    p22=(p2(end,:)-p2(end-1,:))+p2(end,:);
else
    p22=p2(floor(jout)+1,:);
end

dx2=p22(1,1)-p21(1,1);
dy2=p22(1,2)-p21(1,2);
Radius_p2=[p21(1,1)+(jout-floor(jout))*dx2,p21(1,2)+(jout-floor(jout))*dy2];
% calculate angle
v1=Radius_p1-[x0,y0];
v2=Radius_p2-[x0,y0];
ang=acos(dot(v1,v2)/(norm(v1)*norm(v2)))/pi*180;
sang=acos(dot(v1,[1,0])/(norm(v1)*norm([1,0])))/pi*180;

if v1(1,2)<=0
    sang=-sang;
end

if v2(1,2)*v1(1,1)-v2(1,1)*v1(1,2)<0
    ang=-ang;
end
% calculate arc
a=Point2D('Temp point','Echo',0);
a=AddPoint(a,x0,y0);
b=Line2D(obj.Name,'Echo',obj.Echo,'Gtol',obj.Gtol,'Dtol',obj.Dtol,...
    'Atol',obj.Atol,'Rtol',obj.Rtol,'Adfac',obj.Adfac,'Compress',obj.Compress,...
    'Arrow',obj.Arrow,'Form',obj.Form);
% update object
Temp_PP=obj.Point.PP;
for i=1:size(Temp_PP,1)
    if i==l1
        Temp=Temp_PP{i,1};
        Temp=Temp(1:floor(iout),:);
        Temp=[Temp;Radius_p1]; %#ok<AGROW> 
        a=AddPoint(a,Temp(:,1),Temp(:,2));
        b=AddCurve(b,a,i+1);
        b=AddCircle(b,Radius,a,1,'sang',sang,'ang',ang);
    elseif i==l2
        Temp=Temp_PP{i,1};
        Temp=Temp(floor(jout)+1:end,:);
        Temp=[Radius_p2;Temp]; %#ok<AGROW>
        a=AddPoint(a,Temp(:,1),Temp(:,2));
        b=AddCurve(b,a,i+1);
    else
    a=AddPoint(a,Temp_PP{i,1}(:,1),Temp_PP{i,1}(:,2));
    b=AddCurve(b,a,i+1);
    end
end
obj.Point=b.Point;
obj=b;

%% Print
if obj.Echo
    fprintf('Successfully create radius .\n');
end
end

