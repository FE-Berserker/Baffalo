function Plot(obj,varargin)
% Plot MultiBody
% Author : Xie Yu

p=inputParser;
addParameter(p,'axe',1);
addParameter(p,'grid',0);
addParameter(p,'equal',1);
addParameter(p,'alpha',1);
addParameter(p,'face_alpha',1);
addParameter(p,'face_normal',0);
addParameter(p,'marker_size',5);
addParameter(p,'base_size',1);
addParameter(p,'view',[-37.5,30]);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
parse(p,varargin{:});
opt=p.Results;

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
Con.X=[];
Con.Y=[];
Con.Z=[];
MNode=[];
accShellV=0;
accFaceV=0;
for i=1:obj.Summary.Total_Body
    position=obj.Body{i, 1}.Position;
    TempShell=obj.Body{i,1}.Geom.Shell;
    TempBeam=obj.Body{i,1}.Geom.Beam;
    TempFace=obj.Body{i,1}.Geom.Face;
    TempMNode=obj.Body{i,1}.Geom.MNode;
    TempCon=obj.Body{i,1}.Geom.Con;

    if ~isempty(TempShell.el)
        T=Transform(TempShell.V);
        T=Rotate(T,position(4),position(5),position(6));
        T=Translate(T,position(1),position(2),position(3));
        Shell.V=[Shell.V;Solve(T)];
        Shell.el=[Shell.el;TempShell.el+accShellV];
        Shell.Cb=[Shell.Cb;TempShell.Cb];
    end

    if ~isempty(TempBeam.x)
        TempCoor=cellfun(@(x,y,z)[x',y',z'],TempBeam.x,TempBeam.y,TempBeam.z,'UniformOutput',false);
        T=Transform(TempCoor);
        T=Rotate(T,position(4),position(5),position(6));
        T=Translate(T,position(1),position(2),position(3));
        TempCoor=Solve(T);
        X=cellfun(@(x)x(:,1)',TempCoor,'UniformOutput',false);
        Y=cellfun(@(x)x(:,2)',TempCoor,'UniformOutput',false);
        Z=cellfun(@(x)x(:,3)',TempCoor,'UniformOutput',false);
        Baem.x=[Beam.x;X];
        Baem.y=[Beam.y;Y];
        Baem.z=[Beam.z;Z];
        Baem.Cb=[Beam.Cb;TempBeam.Cb];
    end

    if ~isempty(TempFace.el)
        T=Transform(TempFace.V);
        T=Rotate(T,position(4),position(5),position(6));
        T=Translate(T,position(1),position(2),position(3));
        Face.V=[Face.V;Solve(T)];
        Face.el=[Face.el;TempFace.el+accFaceV];
        Face.Cb=[Face.Cb;TempFace.Cb];
    end

    if ~isempty(TempMNode)
        T=Transform(TempMNode);
        T=Rotate(T,position(4),position(5),position(6));
        T=Translate(T,position(1),position(2),position(3));
        MNode=[MNode;Solve(T)]; %#ok<AGROW>
    end
    T=Transform([TempCon.X,TempCon.Y,TempCon.Z]);
    T=Rotate(T,position(4),position(5),position(6));
    T=Translate(T,position(1),position(2),position(3));
    TempCoor=Solve(T);
    Con.X=[Con.X;TempCoor(:,1)];
    Con.Y=[Con.Y;TempCoor(:,2)];
    Con.Z=[Con.Z;TempCoor(:,3)];

    accShellV=size(Shell.V,1);
    accFaceV=size(Face.V,1);
end


P=[Shell.V;[Beam.x,Beam.y,Beam.z];Face.V;Con.X,Con.Y,Con.Z];
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

%% Connection node
X=Con.X;
Y=Con.Y;
Z=Con.Z;

g=Rplot('x',X,'y',Y,'z',Z);
g=axe_property(g,'xlim',[xmmin,xmmax],...
    'ylim',[ymmin,ymmax],...
    'zlim',[zmmin,zmmax],...
    'view',opt.view);
g=set_layout_options(g,'hold',1);
g=set_color_options(g,'map','yellow');
g = set_point_options(g,'base_size', opt.marker_size);
g=geom_point(g);
draw(g);

%% Joint plot
if ~isempty(obj.Joint)
    Tempx=[];Tempy=[];Tempz=[];
    for i=1:size(obj.Joint,1)
        Coor1=GetBodyMarker(obj,obj.Joint{i,1}.From(1,1),obj.Joint{i,1}.From(1,2));
        Coor2=GetBodyMarker(obj,obj.Joint{i,1}.To(1,1),obj.Joint{i,1}.To(1,2));
        Tempx{i,1}=[Coor1(1),Coor2(1)];
        Tempy{i,1}=[Coor1(2),Coor2(2)];
        Tempz{i,1}=[Coor1(3),Coor2(3)];
    end

    g=Rplot('x',Tempx,'y',Tempy,'z',Tempz);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','red');
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_line(g);
    draw(g);
end

%% Constraint plot
if ~isempty(obj.Constraint)
    Tempx=[];Tempy=[];Tempz=[];
    for i=1:size(obj.Constraint,1)
        Coor1=GetBodyMarker(obj,obj.Constraint{i,1}.From(1,1),obj.Constraint{i,1}.From(1,2));
        Coor2=GetBodyMarker(obj,obj.Constraint{i,1}.To(1,1),obj.Constraint{i,1}.To(1,2));
        Tempx{i,1}=[Coor1(1),Coor2(1)];
        Tempy{i,1}=[Coor1(2),Coor2(2)];
        Tempz{i,1}=[Coor1(3),Coor2(3)];
    end

    g=Rplot('x',Tempx,'y',Tempy,'z',Tempz);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','blue');
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_line(g);
    draw(g);
end

%% Force plot
if ~isempty(obj.Force)
    Tempx=[];Tempy=[];Tempz=[];
    for i=1:size(obj.Force,1)
        Coor1=GetBodyMarker(obj,obj.Force{i,1}.From(1,1),obj.Force{i,1}.From(1,2));
        Coor2=GetBodyMarker(obj,obj.Force{i,1}.To(1,1),obj.Force{i,1}.To(1,2));
        Tempx{i,1}=[Coor1(1),Coor2(1)];
        Tempy{i,1}=[Coor1(2),Coor2(2)];
        Tempz{i,1}=[Coor1(3),Coor2(3)];
    end

    g=Rplot('x',Tempx,'y',Tempy,'z',Tempz);
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','black');
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_line(g);
    draw(g);
end

end
