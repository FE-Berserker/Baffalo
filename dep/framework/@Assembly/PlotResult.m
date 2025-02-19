function PlotResult(obj,varargin)
% Visualizing boundary conditions. Markers plotted on the semi-transparent
% model denote the nodes in the various boundary condition lists. 
p=inputParser;
addParameter(p,'U',[]);
addParameter(p,'Stress',[]);
addParameter(p,'elements',[]);
addParameter(p,'scale',1);
addParameter(p,'axe',1);
addParameter(p,'grid',0);
addParameter(p,'equal',1);
addParameter(p,'colorbar',1);
addParameter(p,'jet',10);
addParameter(p,'deformed',0);
addParameter(p,'userdefined',[]);
parse(p,varargin{:});
opt=p.Results;


x=opt.scale.*obj.Sensor.U(:,2);
y=opt.scale.*obj.Sensor.U(:,3);
z=opt.scale.*obj.Sensor.U(:,4);
VV=[obj.V;obj.Cnode];
VV_deformed=VV+[x,y,z];
P=VV_deformed;
xmmin=0.95.*min(P(:,1)).*(min(P(:,1))>0)+...
    1.05.*min(P(:,1)).*(min(P(:,1))<0)-...
    0.1.*(min(P(:,1))==0);
xmmax=1.05.*max(P(:,1)).*(max(P(:,1))>0)+...
    0.95.*max(P(:,1)).*(max(P(:,1))<0)+...
    0.1.*(max(P(:,1))==0);
ymmin=0.95.*min(P(:,2)).*(min(P(:,2))>0)+...
    1.05.*min(P(:,2)).*(min(P(:,2))<0)-...
    0.1.*(min(P(:,2))==0);
ymmax=1.05.*max(P(:,2)).*(max(P(:,2))>0)+...
    0.95.*max(P(:,2)).*(max(P(:,2))<0)+...
    0.1.*(max(P(:,2))==0);
zmmin=0.95.*min(P(:,3)).*(min(P(:,3))>0)+...
    1.05.*min(P(:,3)).*(min(P(:,3))<0)-...
    0.1.*(min(P(:,3))==0);
zmmax=1.05.*max(P(:,3)).*(max(P(:,3))>0)+...
    0.95.*max(P(:,3)).*(max(P(:,3))<0)+...
    0.1.*(max(P(:,3))==0);

% figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
draw(g);

% Select faces

if isempty(opt.elements)
    FF=obj.Fb;
else
    Temp=cellfun(@(x)mat2cell(x,ones(size(x,1),1)),obj.EE,'UniformOutput',false);
    EE=[];
    for i=1:size(Temp,1)
        EE=[EE;Temp{i,1}]; %#ok<AGROW> 
    end
    EE=cellfun(@(x)x(2:end),EE,'UniformOutput',false);
    EE=EE(opt.elements,1);
    EE=cell2mat(EE);
    num=size(EE,2);
    switch num
        case 3
            FF=element2patch(EE,[],'tri3');
        case 4
            FF=element2patch(EE,[],'tet4');
        case 5
            FF=element2patch(EE,[],'pyra5');
        case 6
            FF=element2patch(EE,[],'tri6');
        case 8
            FF=element2patch(EE,[],'hex8');
        case 10
            FF=element2patch(EE,[],'tet10');
        case 14
            FF=element2patch(EE,[],'rhomdo14');
        case 20
            FF=element2patch(EE,[],'hex20');
    end
end



if ~isempty(opt.Stress)
    switch opt.Stress
        case 'Sx'
            data=obj.Sensor.Stress(:,2);
        case 'Sy'
            data=obj.Sensor.Stress(:,3);
        case 'Sz'
            data=obj.Sensor.Stress(:,4);
        case 'Sxy'
            data=obj.Sensor.Stress(:,5);
        case 'Syz'
            data=obj.Sensor.Stress(:,6);
        case 'Sxz'
            data=obj.Sensor.Stress(:,7);
    end
end

if ~isempty(opt.U)
    switch opt.U
        case 'Ux'
            data=obj.Sensor.U(:,2);
        case 'Uy'
            data=obj.Sensor.U(:,3);
        case 'Uz'
            data=obj.Sensor.U(:,4);
        case 'Usum'
            data=obj.Sensor.U(:,5);
    end
end

if ~isempty(opt.userdefined)
    data=opt.userdefined;
end

if opt.deformed==1
patch('Faces',FF,'Vertices',VV,'facecolor','none','edgecolor','k');
end
patch('Faces',FF,'Vertices',VV_deformed,'facevertexcdata',data,'facecolor','interp','edgecolor','none');
axe1=gca;

if opt.colorbar==1
   colorbar(axe1,'north')
end

colormap(jet(opt.jet))
camlight


end


