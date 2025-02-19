function PlotExplod(obj,varargin)
% Plot Assembly Exploded view
% Author : Xie Yu
p=inputParser;
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
addParameter(p,'Ratio',[1.5,1.5,1.5]);
parse(p,varargin{:});
opt=p.Results;

Ratio=opt.Ratio;
P=obj.V;
Center=mean(P);
if isempty(opt.xlim)
    xmmin=0.95.*min(P(:,1)).*(min(P(:,1))>0)+...
        1.05.*min(P(:,1)).*(min(P(:,1))<0)-...
        0.1.*(min(P(:,1))==0);
    xmmax=1.05.*max(P(:,1)).*(max(P(:,1))>0)+...
        0.95.*max(P(:,1)).*(max(P(:,1))<0)+...
        0.1.*(max(P(:,1))==0);
else
    xmmin=opt.xlim(1,1);
    xmmax=opt.xlim(1,2);
end

if isempty(opt.ylim)
    ymmin=0.95.*min(P(:,2)).*(min(P(:,2))>0)+...
        1.05.*min(P(:,2)).*(min(P(:,2))<0)-...
        0.1.*(min(P(:,2))==0);
    ymmax=1.05.*max(P(:,2)).*(max(P(:,2))>0)+...
        0.95.*max(P(:,2)).*(max(P(:,2))<0)+...
        0.1.*(max(P(:,2))==0);
else
    ymmin=opt.ylim(1,1);
    ymmax=opt.ylim(1,2);
end

if isempty(opt.zlim)
    zmmin=0.95.*min(P(:,3)).*(min(P(:,3))>0)+...
        1.05.*min(P(:,3)).*(min(P(:,3))<0)-...
        0.1.*(min(P(:,3))==0);
    zmmax=1.05.*max(P(:,3)).*(max(P(:,3))>0)+...
        0.95.*max(P(:,3)).*(max(P(:,3))<0)+...
        0.1.*(max(P(:,3))==0);
else
    zmmin=opt.zlim(1,1);
    zmmax=opt.zlim(1,2);
end

xmmin=xmmin+(xmmin-Center(1))*opt.Ratio(1);
xmmax=xmmax+(xmmax-Center(1))*opt.Ratio(1);
ymmin=ymmin+(ymmin-Center(2))*opt.Ratio(2);
ymmax=ymmax+(ymmax-Center(2))*opt.Ratio(2);
zmmin=zmmin+(zmmin-Center(3))*opt.Ratio(3);
zmmax=zmmax+(zmmax-Center(3))*opt.Ratio(3);
%% Intial figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',1,'hold',1);
g=axe_property(g,'xlim',[xmmin,xmmax],...
    'ylim',[ymmin,ymmax],...
    'zlim',[zmmin,zmmax],...
    'view',[-37.5,30]);
g=set_axe_options(g,'equal',1);
draw(g);


Num=GetNPart(obj);
group=(1:Num)';


% Element Type
Shell.V=[];
Shell.el=[];
Shell.Cb=[];
Beam.x=[];
Beam.y=[];
Beam.z=[];
Beam.Cb=[];
Face.el=[];
Face.V=[];
Face.Cb=[];
MNode=[];

for i=1:Num
    PartNum=group(i,1);
    [Shell,Beam,Face,MNode]=PartPlot(obj,Shell,Beam,Face,i,MNode,Num,PartNum,Center,Ratio,...
        xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
end



end

function [Shell,Beam,Face,MNode]=PartPlot(obj,Shell,Beam,Face,i,MNode,Num,PartNum,Center,Ratio,...
    xmmin,xmmax,ymmin,ymmax,zmmin,zmmax)
% Plot part
Order=obj.Part{PartNum,1}.mesh.order;
FF=obj.Part{PartNum,1}.mesh.facesBoundary;
VV=obj.Part{PartNum,1}.mesh.nodes;
Cb=obj.Part{PartNum,1}.mesh.boundaryMarker;
El=obj.Part{PartNum,1}.mesh.elements;

if and(~isempty(obj.Part{PartNum,1}.mesh.facesBoundary),obj.Part{PartNum,1}.New==0)
    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
elseif and(~isempty(obj.Part{PartNum,1}.mesh.facesBoundary),obj.Part{PartNum,1}.New==1)
    if i==Num
        [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
    elseif obj.Part{PartNum+1,1}.New==0
        [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
    elseif obj.Part{PartNum+1,1}.New==1
        if i~=1
            post=obj.Part{PartNum+1,1}.acc_node;
            if obj.Part{PartNum,1}.acc_node~=post
                [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
            end
        end

        switch Order
            case 1
                if size(FF,2)==2
                    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
                end
            case 2
                if size(FF,2)==3
                    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
                end
        end
    end

elseif isempty(obj.Part{PartNum,1}.mesh.facesBoundary)

    EE=obj.Part{PartNum,1}.mesh.elements(:,1:2);
    EE=mat2cell(EE,ones(1,size(EE,1)));
    VV=obj.Part{PartNum,1}.mesh.nodes;
    X=cellfun(@(x)VV(x',1)',EE,'UniformOutput',false);
    Y=cellfun(@(x)VV(x',2)',EE,'UniformOutput',false);
    Z=cellfun(@(x)VV(x',3)',EE,'UniformOutput',false);
    Beam.x=[Beam.x;X];
    Beam.y=[Beam.y;Y];
    Beam.z=[Beam.z;Z];
    Beam.Cb=[Beam.Cb,i*ones(1,size(X,1))];

    if obj.Part{PartNum,1}.New==0
        [Beam]=PlotBeam(Beam,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
    elseif obj.Part{PartNum,1}.New==1
        if i==Num
            [Beam]=PlotBeam(Beam,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
        elseif obj.Part{PartNum+1,1}.New==0
            [Beam]=PlotBeam(Beam,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax);
        end

    end

end
end

function [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i,Center,Ratio,...
    xmmin,xmmax,ymmin,ymmax,zmmin,zmmax)
switch Order
    case 1
        if size(FF,2)==3
            acc=size(Face.V,1);
            Face.el=[Face.el;FF+acc,FF(:,3)+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
        elseif size(FF,2)==4
            acc=size(Face.V,1);
            Face.el=[Face.el;FF+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
        elseif size(FF,2)==2
            acc=size(Shell.V,1);
            Shell.el=[Shell.el;El+acc];
            Shell.V=[Shell.V;VV];
            Shell.Cb=[Shell.Cb;ones(size(El,1),1)*i];
        end
    case 2
        if size(FF,2)==3
            acc=size(Shell.V,1);
            Shell.el=[Shell.el;El(:,1:end/2)+acc];
            Shell.V=[Shell.V;VV];
            Shell.Cb=[Shell.Cb;ones(size(El,1),1)*i];
            MNode=[MNode;VV];
        end

        if size(FF,2)==6
            acc=size(Face.V,1);
            Face.el=[Face.el;FF(:,1:3)+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
            MNode=[MNode;VV];
        end

        if size(FF,2)==8
            acc=size(Face.V,1);
            Face.el=[Face.el;FF(:,1:4)+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
            MNode=[MNode;VV];
        end
end



%% plot
if ~isempty(Face.el)
    CenterFace=mean(Face.V);
    delta=(CenterFace-Center).*(Ratio-1);

    g=Rplot('faces',Face.el,'vertices',Face.V+repmat(delta,size(Face.V,1),1),'facecolor',Face.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',[-37.5,30]);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',1,'step_size',0);
    g=geom_patch(g,'alpha',1,'face_alpha',1);
    draw(g);
end



if ~isempty(Shell.el)
    CenterFace=mean(Shell.V);
    delta=(CenterFace-Center).*(Ratio-1);
    g=Rplot('faces',Shell.el,'vertices',Shell.V+repmat(delta,size(Shell.V,1)),'facecolor',Shell.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',[-37.5,30]);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',1,'step_size',0);
    g=geom_patch(g,'alpha',1,'face_alpha',1);
    draw(g);
end

if ~isempty(MNode)
    delta=(MNode-Center).*repmat((Ratio-1),size(MNode,1),1);
    g=Rplot('X',MNode(:,1)+delta(:,1),'Y',MNode(:,2)+delta(:,2),'Z',MNode(:,3)+delta(:,3));
    g=set_layout_options(g,'axe',1,'hold',1);
    g=axe_property(g,'view',[-37.5,30]);
    g=set_color_options(g,'map','black');
    g=geom_point(g);
    g=set_point_options(g,'base_size',2);
    draw(g);
end
Face.el=[];
Face.V=[];
Face.Cb=[];
Shell.el=[];
Shell.V=[];
Shell.Cb=[];
MNode=[];
end

function [Beam]=PlotBeam(Beam,Center,Ratio,xmmin,xmmax,ymmin,ymmax,zmmin,zmmax)
if ~isempty(Beam.x)
    Beam.x=reshape(cell2mat(Beam.x),[],1);
    Beam.y=reshape(cell2mat(Beam.y),[],1);
    Beam.z=reshape(cell2mat(Beam.z),[],1);
    delta=(mean([Beam.x,Beam.y,Beam.z])-Center).*(Ratio-1);
    g=Rplot('x',Beam.x+delta(1),'y',Beam.y+delta(2),'z',Beam.z+delta(3),'color',[Beam.Cb;Beam.Cb]);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',[-37.5,30]);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',1,'step_size',0);
    g=geom_line(g);
    draw(g);
end
Beam.x=[];
Beam.y=[];
Beam.z=[];
Beam.Cb=[];
end