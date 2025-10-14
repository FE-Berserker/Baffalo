function obj = CalStiffnessY(obj,varargin)
% Calculate Taper PMB stiffness
% Author : Xie Yu

k=inputParser;
addParameter(k,'Displacement',[]);
parse(k,varargin{:});
opt=k.Results;

% Load geometry information
StatorR=obj.input.StatorR;
RotorR=obj.input.RotorR;
Height=obj.input.Height;
StatorDir=obj.input.StatorDir;
RotorDir=obj.input.RotorDir;
k=size(Height,2);
esize=min(StatorR(2)-StatorR(1),RotorR(2)-RotorR(1))/10;
Material=obj.params.Material;
SecNum=obj.params.SecNum;
TaperAngle=obj.params.TaperAngle;

TempR1=max(StatorR(1),RotorR(1));
TempR2=min(StatorR(end),RotorR(end));
RotPoint=[(TempR1+TempR2)/2,(Height(1)+Height(end))/2,0];

if mean(StatorR)>mean(RotorR)
    State=0;
    dis=min(StatorR)-max(RotorR);

    if isempty(opt.Displacement)
        disY=sin(TaperAngle/180*pi)*dis;
    else
        disY=2*opt.Displacement;
    end

    if disY<0.1
        error('Please difine displacment !')
    end
else
    State=1;
    dis=min(RotorR)-max(StatorR);

    if isempty(opt.Displacement)
        disY=sin(TaperAngle/180*pi)*dis;
    else
        disY=2*opt.Displacement;
    end

    if disY<0.1
        error('Please difine displacment !')
    end
end


e=(-disY/2:disY/10:disY/2)';
Fy=NaN(11,1);


for ii=1:11
% Open femm
openfemm;
newdocument(0);
mi_probdef(0,'millimeters','axi',1e-8,0,30);
ee=e(ii,1);

if State==0
    ee=-ee;
end

% Create Points
PointVault=[];
for i=1:k
    for j=1:2
        P1=[StatorR(j),Height(i),0];
        T=Transform(P1);
        T=Rotate(T,0,0,TaperAngle,'Ori',RotPoint);
        P2=Solve(T);
        mi_addnode(P2(1,1),P2(1,2));
        PointVault=[PointVault;P2(:,1:2)]; %#ok<AGROW>
    end
end


for i=1:k
    for j=1:2
        P1=[RotorR(j),Height(i),0];
        T=Transform(P1);
        T=Rotate(T,0,0,TaperAngle,'Ori',RotPoint);
        T=Translate(T,0,ee,0);
        P2=Solve(T);
        mi_addnode(P2(1,1),P2(1,2));
        PointVault=[PointVault;P2(:,1:2)]; %#ok<AGROW>
    end
end

MaxR=max(PointVault(:,1));
miny=min(PointVault(:,2));
maxy=max(PointVault(:,2));

mi_addnode(0,miny-maxy/2);
mi_addnode(1.5*MaxR,miny-maxy/2);
mi_addnode(0,maxy+maxy/2);
mi_addnode(1.5*MaxR,maxy+maxy/2);

% Create Lines
for i=1:k
    mi_addsegment(PointVault(1+(i-1)*2,1),PointVault(1+(i-1)*2,2),PointVault(i*2,1),PointVault(i*2,2));
end

for i=1:k-1
    mi_addsegment(PointVault(1+(i-1)*2,1),PointVault(1+(i-1)*2,2),PointVault(1+i*2,1),PointVault(1+i*2,2));
    mi_addsegment(PointVault(i*2,1),PointVault(i*2,2),PointVault(i*2+2,1),PointVault(i*2+2,2));
end

for i=1:k
    mi_addsegment(PointVault(1+(i-1)*2+k*2,1),PointVault(1+(i-1)*2+k*2,2),PointVault(i*2+k*2,1),PointVault(i*2+k*2,2));
end

for i=1:k-1
    mi_addsegment(PointVault(1+(i-1)*2+k*2,1),PointVault(1+(i-1)*2+k*2,2),PointVault(1+i*2+k*2,1),PointVault(1+i*2+k*2,2));
    mi_addsegment(PointVault(i*2+k*2,1),PointVault(i*2+k*2,2),PointVault(i*2+2+k*2,1),PointVault(i*2+2+k*2,2));
end

mi_addsegment(0,miny-maxy/2,1.5*MaxR,miny-maxy/2);
mi_addsegment(1.5*MaxR,miny-maxy/2,1.5*MaxR,maxy+maxy/2);
mi_addsegment(1.5*MaxR,maxy+maxy/2,0,maxy+maxy/2);
mi_addsegment(0,maxy+maxy/2,0,miny-maxy/2);

% Add Block label
for i=1:k-1
    mi_addblocklabel(mean(PointVault(1+(i-1)*2:4+(i-1)*2,1)),mean(PointVault(1+(i-1)*2:4+(i-1)*2,2)));
    mi_addblocklabel(mean(PointVault(1+(i-1)*2+2*k:4+(i-1)*2+2*k,1)),mean(PointVault(1+(i-1)*2+2*k:4+(i-1)*2+2*k,2)));
end

mi_addblocklabel(0.1,miny-maxy/2+0.1);

% Add Material
mi_addmaterial(Material.Name,Material.Mux,Material.Muy,Material.Hc,...
    0,Material.Sigma,0,0,1,0,0,0,0,0)
mi_getmaterial('Air');

% Set properties
for i=1:k-1
    mi_selectlabel(mean(PointVault(1+(i-1)*2:4+(i-1)*2,1)),mean(PointVault(1+(i-1)*2:4+(i-1)*2,2)));
    mi_setblockprop(Material.Name,0,esize,'<None>',StatorDir(i)+TaperAngle,0,1);
    mi_clearselected

    mi_selectlabel(mean(PointVault(1+(i-1)*2+2*k:4+(i-1)*2+2*k,1)),mean(PointVault(1+(i-1)*2+2*k:4+(i-1)*2+2*k,2)));
    mi_setblockprop(Material.Name,0,esize,'<None>',RotorDir(i)+TaperAngle,0,1);
    mi_clearselected
end

mi_selectlabel(0.1,miny-maxy/2+0.1);
mi_setblockprop('Air',0,esize,'<None>',0,0,1);
mi_clearselected

mi_saveas(strcat(obj.params.Name,'.FEM'))
mi_createmesh;
mi_analyze(0)

% Load the solution
mi_loadsolution

for i=1:k-1
    mo_selectblock(mean(PointVault(1+(i-1)*2:4+(i-1)*2,1)),mean(PointVault(1+(i-1)*2:4+(i-1)*2,2)));
end

Fy(ii,1)=mo_blockintegral(19);
closefemm

end


y=-disY/2:disY/10:disY/2;


% Parse
obj.output.StiffnessY=[y',Fy];
% Print
if obj.params.Echo
    fprintf('Successfully calculate stiffness Y! .\n');
end
end

