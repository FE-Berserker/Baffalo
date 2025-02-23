function PlotORB(obj,loadstep,subloadstep,varargin)
% Plot ORB of RotDyn
% Author : XieYu
p=inputParser;
addParameter(p,'scale',10);
parse(p,varargin{:});
opt=p.Results;

filename=strcat('ORB',num2str(loadstep),'_',num2str(subloadstep),'.txt');
ORB=ImportORB(filename);

P=[obj.output.Assembly.V;obj.output.Assembly.Cnode];
Elements=cell2mat(cellfun(@(x)(x.mesh.elements(:,1:2)),obj.output.Assembly.Part,'UniformOutput',false));
R=ORB.A*opt.scale;

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
ymmin=ymmin-max(R);
ymmax=ymmax+max(R);
zmmin=zmmin-max(R);
zmmax=zmmax+max(R);
% figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',1,'hold',1);
g=set_axe_options(g,'grid',0,'equal',1);
draw(g);

Num=size(Elements,1);
Beam.x=[];
Beam.y=[];
Beam.z=[];
Beam.Cb=[];

BeamDeform.x=[];
BeamDeform.y=[];
BeamDeform.z=[];
BeamDeform.Cb=[];

for i=1:Num
    EE=Elements(i,1:2);
    EE=mat2cell(EE,ones(1,size(EE,1)));
    X=cellfun(@(x)P(x',1)',EE,'UniformOutput',false);
    Y=cellfun(@(x)P(x',2)',EE,'UniformOutput',false);
    Z=cellfun(@(x)P(x',3)',EE,'UniformOutput',false);
    XX=X;

    TempYY=cellfun(@(x)ORB.A(x',1)'.*opt.scale.*cos(ORB.PHI(x',1)'/180*pi),EE,'UniformOutput',false);
    TempZZ=cellfun(@(x)ORB.B(x',1)'.*opt.scale.*sin(ORB.PHI(x',1)'/180*pi),EE,'UniformOutput',false);

    YY=cellfun(@(x,y,z)y.*cos(ORB.PSI(x',1)'/180*pi)+z.*sin(ORB.PSI(x',1)'/180*pi),EE,TempYY,TempZZ,'UniformOutput',false);
    ZZ=cellfun(@(x,y,z)-y.*sin(ORB.PSI(x',1)'/180*pi)+z.*cos(ORB.PSI(x',1)'/180*pi),EE,TempYY,TempZZ,'UniformOutput',false);

    Beam.x=[Beam.x;X];
    Beam.y=[Beam.y;Y];
    Beam.z=[Beam.z;Z];
    Beam.Cb=[Beam.Cb,ones(1,size(X,1))];

    BeamDeform.x=[BeamDeform.x;XX];
    BeamDeform.y=[BeamDeform.y;YY];
    BeamDeform.z=[BeamDeform.z;ZZ];
    BeamDeform.Cb=[BeamDeform.Cb,ones(1,size(X,1))];
end

if ~isempty(Beam.x)
    g=Rplot('x',Beam.x,'y',Beam.y,'z',Beam.z,'color',Beam.Cb);
    g=set_color_options(g,'map','black');
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',1,'step_size',0);
    g=geom_line(g);
    draw(g);
end

if ~isempty(BeamDeform.x)
    g=Rplot('x',BeamDeform.x,'y',BeamDeform.y,'z',BeamDeform.z,'color',BeamDeform.Cb);
    g=set_color_options(g,'map','red');
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',1,'step_size',0);
    g=geom_line(g);
    draw(g);
end

% Plot Circle
rotnum=60;
ang=linspace(0,2*pi,rotnum);

for i=1:size(ORB.Nodes,1)
    A=ORB.A(i,1)*opt.scale;
    B=ORB.B(i,1)*opt.scale;
    phi=ORB.PSI(i,1);

    Tempyy=A*cos(ang);
    Tempzz=B*sin(ang);

    yy=Tempyy.*cos(phi/180*pi)+Tempzz.*sin(phi/180*pi);
    zz=-Tempyy.*sin(phi/180*pi)+Tempzz.*cos(phi/180*pi);
    num=ORB.Nodes(i,1);
    xx=repmat(P(num,1),1,rotnum);
    line(xx,yy,zz)
end
