function Plot3D(obj,varargin)
% Plot SubModel
% Author：Xie Yu
p=inputParser;
addParameter(p,'axe',1);
addParameter(p,'grid',0);
addParameter(p,'equal',1);
addParameter(p,'alpha',1);
addParameter(p,'face_alpha',0.2);
addParameter(p,'face_normal',0);
addParameter(p,'load',0);
addParameter(p,'load_scale',0.9);
addParameter(p,'dis',0);
addParameter(p,'dis_scale',1);
addParameter(p,'moment_scale',0.9);
addParameter(p,'boundary',0);
addParameter(p,'endrelease',0);
addParameter(p,'marker_size',5);
addParameter(p,'section',[]);
addParameter(p,'connection',0);
addParameter(p,'base_size',0.1);
addParameter(p,'view',[-37.5,30]);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
addParameter(p,'BeamGeom',0);
parse(p,varargin{:});
opt=p.Results;


P=obj.input.Coarse.V;
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
opt.xlim=[xmmin,xmmax];
opt.ylim=[ymmin,ymmax];
opt.zlim=[zmmin,zmmax];
%% Intial figure
figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
g=axe_property(g,'xlim',[xmmin,xmmax],...
    'ylim',[ymmin,ymmax],...
    'zlim',[zmmin,zmmax],...
    'view',opt.view);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
draw(g);


Num1=GetNPart(obj.input.Coarse);
group=(1:Num1)';


% Element Type
Shell.V=[];
Shell.el=[];
Shell.Cb=[];
Beam.x=[];
Beam.y=[];
Beam.z=[];
Beam.Cb=[];
BeamSection.V=[];
BeamSection.el=[];
BeamSection.Cb=[];
Face.el=[];
Face.V=[];
Face.Cb=[];
MNode=[];
for i=1:Num1
    PartNum=group(i,1);
    [Shell,Beam,Face,MNode,BeamSection]=PartPlot(obj.input.Coarse,Shell,Beam,Face,i,MNode,Num1,PartNum,BeamSection,opt.BeamGeom);
end

Num2=GetNPart(obj.input.Sub);
group=(1:Num2)';
for i=1:Num2
    PartNum=group(i,1);
    [Shell,Beam,Face,MNode,BeamSection]=PartPlot(obj.input.Sub,Shell,Beam,Face,i,MNode,Num1,PartNum,BeamSection,opt.BeamGeom);
end

%% plot
if ~isempty(Face.el)
    g=Rplot('faces',Face.el,'vertices',Face.V,'facecolor',Face.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha,'face_normal',opt.face_normal);
    draw(g);
end

if ~isempty(Beam.x)
    g=Rplot('x',Beam.x,'y',Beam.y,'z',Beam.z,'color',Beam.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_line(g);
    draw(g);
end

if ~isempty(BeamSection)
    g=Rplot('faces',BeamSection.el,'vertices',real(BeamSection.V),'facecolor',BeamSection.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha,'face_normal',opt.face_normal);
    draw(g);
end


if ~isempty(Shell.el)
    g=Rplot('faces',Shell.el,'vertices',Shell.V,'facecolor',Shell.Cb);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha,'face_normal',opt.face_normal);
    draw(g);
end

if ~isempty(MNode)
    g=Rplot('X',MNode(:,1),'Y',MNode(:,2),'Z',MNode(:,3));
    g=set_layout_options(g,'axe',opt.axe,'hold',1);
    g=axe_property(g,'view',opt.view);
    g=set_color_options(g,'map','black');
    g=geom_point(g);
    g=set_point_options(g,'base_size',2);
    draw(g);
end

%% Plot cut boundary
Temp=[obj.input.Sub.V;obj.input.Sub.Cnode];
X=Temp(obj.input.Sub.CutBoundary,1);
Y=Temp(obj.input.Sub.CutBoundary,2);
Z=Temp(obj.input.Sub.CutBoundary,3);
g=Rplot('x',X,'y',Y,'z',Z);
g=axe_property(g,'xlim',[xmmin,xmmax],...
    'ylim',[ymmin,ymmax],...
    'zlim',[zmmin,zmmax],...
    'view',opt.view);
g=set_layout_options(g,'hold',1);
g=set_color_options(g,'map','black');
g = set_point_options(g,'base_size', opt.marker_size);
g=geom_point(g);
draw(g);


end

function [Shell,Beam,Face,MNode,BeamSection]=PartPlot(obj,Shell,Beam,Face,i,MNode,Num,PartNum,BeamSection,BeamGeom)
% Plot part
Order=obj.Part{PartNum,1}.mesh.order;
FF=obj.Part{PartNum,1}.mesh.facesBoundary;
VV=obj.Part{PartNum,1}.mesh.nodes;
Cb=obj.Part{PartNum,1}.mesh.boundaryMarker;
El=obj.Part{PartNum,1}.mesh.elements;

if and(~isempty(obj.Part{PartNum,1}.mesh.facesBoundary),obj.Part{PartNum,1}.New==0)
    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
elseif and(~isempty(obj.Part{PartNum,1}.mesh.facesBoundary),obj.Part{PartNum,1}.New==1)
    if i==Num
        [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
    elseif obj.Part{PartNum+1,1}.New==0
        [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
    elseif obj.Part{PartNum+1,1}.New==1
        if i~=1
            post=obj.Part{PartNum+1,1}.acc_node;
            if obj.Part{PartNum,1}.acc_node~=post
                [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
            end
        end

        switch Order
            case 1
                if size(FF,2)==2
                    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
                end
            case 2
                if size(FF,2)==3
                    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
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
    if BeamGeom==1
        if size(obj.Part{PartNum,1}.mesh.elements,2)==3
            SectionNum=obj.Part{PartNum,1}.Sec;
            if SectionNum~=0
                DEE=obj.Part{PartNum,1}.mesh.elements(:,3);
                DX=VV(DEE,1);
                DY=VV(DEE,2);
                DZ=VV(DEE,3);
                [TempNode,TempFace,TempCb]=CalBeamSection(obj,[X,Y,Z],[DX,DY,DZ],SectionNum,i);
                BeamSection.el=[BeamSection.el;TempFace+size(BeamSection.V,1)];
                BeamSection.V=[BeamSection.V;TempNode];
                BeamSection.Cb=[BeamSection.Cb;TempCb];
            end
        end
    end
end
end

function [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i)
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
end






