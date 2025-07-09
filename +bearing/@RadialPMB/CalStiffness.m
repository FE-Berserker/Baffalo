function obj = CalStiffness(obj)
% Calculate Radial PMB stiffness
% Author : Xie Yu

% Load geometry information
StatorR=obj.input.StatorR;
RotorR=obj.input.RotorR;
Height=obj.input.Height;
StatorDir=obj.input.StatorDir;
RotorDir=obj.input.RotorDir;
MaxR=max([StatorR,RotorR]);
k=size(Height,2);
esize=min(StatorR(2)-StatorR(1),RotorR(2)-RotorR(1))/10;
Material=obj.params.Material;
SecNum=obj.params.SecNum;

if mean(StatorR)>mean(RotorR)
    State=0;
    Reqv=(min(StatorR)+max(RotorR))/2;
    dis=min(StatorR)-max(RotorR);
else
    State=1;
    Reqv=(max(StatorR)+min(RotorR))/2;
    dis=min(RotorR)-max(StatorR);
end

depth=2*pi/SecNum*Reqv;

e=(dis-dis/2:dis/10:dis+dis/2)';
Fx=NaN(11,1);


for ii=1:11
% Open femm
openfemm;
newdocument(0);
mi_probdef(0,'millimeters','planar',1e-8,depth,30);
ee=e(ii,1)-dis;

if State==0
    RotorR=RotorR-ee;
else
    RotorR=RotorR+ee;
end

% Create Points
for i=1:k
    for j=1:2
        mi_addnode(StatorR(j),Height(i));
    end
end


for i=1:k
    for j=1:2
        mi_addnode(RotorR(j),Height(i));
    end
end


mi_addnode(0,Height(1)-Height(end)/2);
mi_addnode(1.5*MaxR,Height(1)-Height(end)/2);
mi_addnode(0,Height(end)+Height(end)/2);
mi_addnode(1.5*MaxR,Height(end)+Height(end)/2);

% Create Lines
for i=1:k
    mi_addsegment(StatorR(1),Height(i),StatorR(2),Height(i));
end

for i=1:k-1
    mi_addsegment(StatorR(1),Height(i),StatorR(1),Height(i+1));
    mi_addsegment(StatorR(2),Height(i),StatorR(2),Height(i+1));
end

for i=1:k
    mi_addsegment(RotorR(1),Height(i),RotorR(2),Height(i));
end

for i=1:k-1
    mi_addsegment(RotorR(1),Height(i),RotorR(1),Height(i+1));
    mi_addsegment(RotorR(2),Height(i),RotorR(2),Height(i+1));
end

mi_addsegment(0,Height(1)-Height(end)/2,1.5*MaxR,Height(1)-Height(end)/2);
mi_addsegment(1.5*MaxR,Height(1)-Height(end)/2,1.5*MaxR,Height(end)+Height(end)/2);
mi_addsegment(1.5*MaxR,Height(end)+Height(end)/2,0,Height(end)+Height(end)/2);
mi_addsegment(0,Height(end)+Height(end)/2,0,Height(1)-Height(end)/2);

% Add Block label
for i=1:k-1
    mi_addblocklabel(mean(StatorR),(Height(i)+Height(i+1))/2);
    mi_addblocklabel(mean(RotorR),(Height(i)+Height(i+1))/2);
end

mi_addblocklabel(0.1,Height(1)-Height(end)/2+0.1);

% Add Material
mi_addmaterial(Material.Name,Material.Mux,Material.Muy,Material.Hc,...
    0,Material.Sigma,0,0,1,0,0,0,0,0)
mi_getmaterial('Air');

% Set properties
for i=1:k-1
    mi_selectlabel(mean(StatorR),(Height(i)+Height(i+1))/2);
    mi_setblockprop(Material.Name,0,esize,'<None>',StatorDir(i),0,1);
    mi_clearselected

    mi_selectlabel(mean(RotorR),(Height(i)+Height(i+1))/2);
    mi_setblockprop(Material.Name,0,esize,'<None>',RotorDir(i),0,1);
    mi_clearselected
end

mi_selectlabel(0.1,Height(1)-Height(end)/2+0.1);
mi_setblockprop('Air',0,esize,'<None>',0,0,1);
mi_clearselected

mi_saveas(strcat(obj.params.Name,'.FEM'))
mi_createmesh;
mi_analyze(0)

% Load the solution
mi_loadsolution

for i=1:k-1
    mo_selectblock(mean(StatorR),(Height(i)+Height(i+1))/2)
end


Fx(ii,1)=mo_blockintegral(18);
closefemm

if State==0
    RotorR=RotorR+ee;
else
    RotorR=RotorR-ee;
end

end


x=0:dis/20:dis/2;
angle=0:2*pi/SecNum:2*pi-2*pi/SecNum;
FFx=NaN(1,11);

for i=1:11
    dd=x(i)*cos(angle);
    Force=-interp1(e,Fx',dd+dis).*cos(angle);
    FFx(i)=sum(Force);
end

% Parse
obj.output.Stiffness=[x',FFx'];
% Print
if obj.params.Echo
    fprintf('Successfully calculate stiffness ! .\n');
end
end

