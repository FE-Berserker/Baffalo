function obj = CalMagneticField(obj)
% Calculate Radial PMB magnetic field
% Author : Xie Yu

Material=obj.params.Material;

% Open femm
openfemm;
newdocument(0);
mi_probdef(0,'millimeters','axi',1e-8,0,30);

% Load geometry information
StatorR=obj.input.StatorR;
RotorR=obj.input.RotorR;
Height=obj.input.Height;
StatorDir=obj.input.StatorDir;
RotorDir=obj.input.RotorDir;
MaxR=max([StatorR,RotorR]);
k=size(Height,2);
esize=min(StatorR(2)-StatorR(1),RotorR(2)-RotorR(1))/10;
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
    0,Material.Sigma*1000,0,0,1,0,0,0,0,0)
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

% Print
if obj.params.Echo
    fprintf('Successfully calculate magnetic field ! .\n');
end
end

