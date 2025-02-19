function Plot(obj,varargin)
% Plot Assembly
% Author : Xie Yu
p=inputParser;
addParameter(p,'Part',[]);
addParameter(p,'Group',[]);
addParameter(p,'axe',1);
addParameter(p,'grid',0);
addParameter(p,'equal',1);
addParameter(p,'alpha',1);
addParameter(p,'face_alpha',1);
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
addParameter(p,'base_size',1);
addParameter(p,'view',[-37.5,30]);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
addParameter(p,'zlim',[]);
addParameter(p,'BeamGeom',0);
parse(p,varargin{:});
opt=p.Results;

if opt.connection==1
    opt.face_alpha=0.2;
    opt.base_size=0.1;
end

P=obj.V;
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

if and(isempty(opt.Part),isempty(opt.Group))
    Num=GetNPart(obj);
    group=(1:Num)';
elseif and(~isempty(opt.Part),isempty(opt.Group))
    Num=size(opt.Part,1);
    group=opt.Part;
elseif and(isempty(opt.Part),~isempty(opt.Group))
    Num=size(obj.Group{opt.Group,1},1);
    group=obj.Group{opt.Group,1};
elseif and(~isempty(opt.Part),~isempty(opt.Group))
    Num=size(obj.Group{opt.Group,1},1);
    group=obj.Group{opt.Group,1};
end

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
EE=[];
MNode=[];
colornum=1;
for i=1:Num
    PartNum=group(i,1);
    if isempty(opt.section)
        [Shell,Beam,Face,MNode,BeamSection]=PartPlot(obj,Shell,Beam,Face,i,MNode,Num,PartNum,BeamSection,opt.BeamGeom);
    else
        [colornum,EE]=SectionPlot(obj,i,Num,EE,PartNum,opt,colornum);
    end
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
%% Plot Load
if opt.load==1
    Temp=[obj.V;obj.Cnode];
    X1=Temp(obj.BcPrescribeList,1);
    Y1=Temp(obj.BcPrescribeList,2);
    Z1=Temp(obj.BcPrescribeList,3);
    U1=[];V1=[];W1=[];
    U2=[];V2=[];W2=[];
    for i=1:size(obj.Load,1)
        Temp_U1=obj.Load{i,1}.amp(:,1);
        Temp_V1=obj.Load{i,1}.amp(:,2);
        Temp_W1=obj.Load{i,1}.amp(:,3);
        Temp_U2=obj.Load{i,1}.amp(:,4);
        Temp_V2=obj.Load{i,1}.amp(:,5);
        Temp_W2=obj.Load{i,1}.amp(:,6);
        U1=[U1;Temp_U1]; %#ok<AGROW>
        V1=[V1;Temp_V1]; %#ok<AGROW>
        W1=[W1;Temp_W1]; %#ok<AGROW>
        U2=[U2;Temp_U2]; %#ok<AGROW>
        V2=[V2;Temp_V2]; %#ok<AGROW>
        W2=[W2;Temp_W2]; %#ok<AGROW>
    end

    g=Rplot('x',X1,'y',Y1,'z',Z1,'u',U1,'v',V1,'w',W1);
    g=axe_property(g,'xlim',[xmmin,xmmax],...
        'ylim',[ymmin,ymmax],...
        'zlim',[zmmin,zmmax],...
        'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','red');
    g=geom_quiver3(g,'AutoScaleFactor',opt.load_scale);

    draw(g);

    g=Rplot('x',X1,'y',Y1,'z',Z1,'u',U2,'v',V2,'w',W2);
    g=axe_property(g,'xlim',[xmmin,xmmax],...
        'ylim',[ymmin,ymmax],...
        'zlim',[zmmin,zmmax],...
        'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','red');
    g=geom_quiver3(g,'AutoScaleFactor',opt.load_scale,'Alignment','head');
    g=geom_quiver3(g,'AutoScaleFactor',opt.load_scale,'Alignment','center');

    draw(g);

    if ~isempty(obj.SF)
        num=GetNSF(obj);
        for i=1:num
            switch obj.SF{i,1}.type
                case 'SFBEAM'
                    for j=1:size(obj.SF{i,1}.elements,1)
                        Numpart=obj.SF{i,1}.part;
                        No=obj.SF{i,1}.elements(j,:);

                        N1=obj.Part{Numpart,1}.mesh.elements(No,1);
                        N2=obj.Part{Numpart,1}.mesh.elements(No,2);
                        X2=obj.Part{Numpart,1}.mesh.nodes([N1,N2],1);
                        Y2=obj.Part{Numpart,1}.mesh.nodes([N1,N2],2);
                        Z2=obj.Part{Numpart,1}.mesh.nodes([N1,N2],3);

                        g=Rplot('x',X2,'y',Y2,'z',Z2);
                        g=axe_property(g,'xlim',[xmmin,xmmax],...
                            'ylim',[ymmin,ymmax],...
                            'zlim',[zmmin,zmmax],...
                            'view',opt.view);
                        g=set_layout_options(g,'hold',1);
                        g=set_color_options(g,'map','yellow');
                        g=set_line_options(g,'base_size',2);
                        g=geom_line(g);
                        draw(g);
                    end
                case 'SFE'
                    for j=1:size(obj.SF{i,1}.elements,1)
                        Numpart=obj.SF{i,1}.part;
                        No=obj.SF{i,1}.elements(j,:);

                        N1=obj.Part{Numpart,1}.mesh.elements(No,1);
                        N2=obj.Part{Numpart,1}.mesh.elements(No,2);
                        X2=obj.Part{Numpart,1}.mesh.nodes([N1,N2],1);
                        Y2=obj.Part{Numpart,1}.mesh.nodes([N1,N2],2);
                        Z2=obj.Part{Numpart,1}.mesh.nodes([N1,N2],3);

                        g=Rplot('x',X2,'y',Y2,'z',Z2);
                        g=axe_property(g,'xlim',[xmmin,xmmax],...
                            'ylim',[ymmin,ymmax],...
                            'zlim',[zmmin,zmmax],...
                            'view',opt.view);
                        g=set_layout_options(g,'hold',1);
                        g=set_color_options(g,'map','yellow');
                        g=set_line_options(g,'base_size',2);
                        g=geom_line(g);
                        draw(g);
                    end

            end
        end
    end
end
%% Plot Displacement
if opt.dis==1
    Temp=[obj.V;obj.Cnode];
    X1=Temp(obj.BcDisplacementList,1);
    Y1=Temp(obj.BcDisplacementList,2);
    Z1=Temp(obj.BcDisplacementList,3);
    U1=[];V1=[];W1=[];
    U2=[];V2=[];W2=[];
    for i=1:size(obj.Displacement,1)
        Temp_U1=obj.Displacement{i,1}.amp(:,1);
        Temp_V1=obj.Displacement{i,1}.amp(:,2);
        Temp_W1=obj.Displacement{i,1}.amp(:,3);
        Temp_U2=obj.Displacement{i,1}.amp(:,4);
        Temp_V2=obj.Displacement{i,1}.amp(:,5);
        Temp_W2=obj.Displacement{i,1}.amp(:,6);
        U1=[U1;Temp_U1]; %#ok<AGROW>
        V1=[V1;Temp_V1]; %#ok<AGROW>
        W1=[W1;Temp_W1]; %#ok<AGROW>
        U2=[U2;Temp_U2]; %#ok<AGROW>
        V2=[V2;Temp_V2]; %#ok<AGROW>
        W2=[W2;Temp_W2]; %#ok<AGROW>
    end

    g=Rplot('x',X1,'y',Y1,'z',Z1,'u',U1,'v',V1,'w',W1);
    g=axe_property(g,'xlim',[xmmin,xmmax],...
        'ylim',[ymmin,ymmax],...
        'zlim',[zmmin,zmmax],...
        'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','blue');
    g=geom_quiver3(g,'AutoScaleFactor',opt.load_scale);

    draw(g);

    g=Rplot('x',X1,'y',Y1,'z',Z1,'u',U2,'v',V2,'w',W2);
    g=axe_property(g,'xlim',[xmmin,xmmax],...
        'ylim',[ymmin,ymmax],...
        'zlim',[zmmin,zmmax],...
        'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','blue');
    g=geom_quiver3(g,'AutoScaleFactor',opt.load_scale,'Alignment','head');
    g=geom_quiver3(g,'AutoScaleFactor',opt.load_scale,'Alignment','center');

    draw(g);

end


%% Plot boundary
if opt.boundary==1
    Temp=[obj.V;obj.Cnode];
    X=Temp(obj.BcSupportList,1);
    Y=Temp(obj.BcSupportList,2);
    Z=Temp(obj.BcSupportList,3);
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

%% Plot EndRelease
if opt.endrelease==1
    Temp=[obj.V;obj.Cnode];
    X=Temp(obj.EndReleaseList,1);
    Y=Temp(obj.EndReleaseList,2);
    Z=Temp(obj.EndReleaseList,3);
    g=Rplot('x',X,'y',Y,'z',Z);
    g=axe_property(g,'xlim',[xmmin,xmmax],...
        'ylim',[ymmin,ymmax],...
        'zlim',[zmmin,zmmax],...
        'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','cyan');
    g = set_point_options(g,'base_size', opt.marker_size);
    g=geom_point(g,'alpha',0.7);
    draw(g);
end

%% Plot Master node of sub structure
if ~isempty(obj.SubStrM.Node)
    Node=[obj.V;obj.Cnode];
    NN=(1:size(obj.SubStrM.Node,1))';
    NN=mat2cell(NN,ones(size(NN,1),1));
    NNN=cellfun(@(x)GetSubStrMNum(obj,x),NN,'UniformOutput',false);
    NNN=cell2mat(NNN);
    X=Node(NNN,1);
    Y=Node(NNN,2);
    Z=Node(NNN,3);
    g=Rplot('x',X,'y',Y,'z',Z);
    g=axe_property(g,'xlim',[xmmin,xmmax],...
        'ylim',[ymmin,ymmax],...
        'zlim',[zmmin,zmmax],...
        'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','red');
    g = set_point_options(g,'base_size', opt.marker_size);
    g=geom_point(g);
    draw(g);
end

%% Plot connection
Num=size(obj.Connection,1);
if and(opt.connection==1,Num~=0)
    mas=obj.Connection(:,1);
    Temp=obj.Master(mas,:);
    coor=GetNodeCoor(obj,Temp(:,1),Temp(:,2));

    X=coor(:,1);
    Y=coor(:,2);
    Z=coor(:,3);
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

    sla=obj.Connection(:,2);
    P=obj.Slaver(sla,1);
    sla_Node=cell2mat(P);
    Temp=[obj.V;obj.Cnode];

    X=Temp(sla_Node,1);
    Y=Temp(sla_Node,2);
    Z=Temp(sla_Node,3);

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

    X=[];Y=[];Z=[];
    for j=1:Num
        Temp1=obj.Master(mas(j,1),:);
        coor=GetNodeCoor(obj,Temp1(:,1),Temp1(:,2));
        X1=coor(:,1);
        Y1=coor(:,2);
        Z1=coor(:,3);

        X2=Temp(obj.Slaver{sla(j,1),1},1);
        Y2=Temp(obj.Slaver{sla(j,1),1},2);
        Z2=Temp(obj.Slaver{sla(j,1),1},3);
        X1=repmat(X1,size(X2,1),1);
        Y1=repmat(Y1,size(Y2,1),1);
        Z1=repmat(Z1,size(Z2,1),1);
        X=[X;X1,X2]; %#ok<AGROW>
        Y=[Y;Y1,Y2]; %#ok<AGROW>
        Z=[Z;Z1,Z2]; %#ok<AGROW>
    end
    X=mat2cell(X,ones(size(X,1),1));
    Y=mat2cell(Y,ones(size(Y,1),1));
    Z=mat2cell(Z,ones(size(Z,1),1));
    X=cellfun(@(x)x',X,'UniformOutput',false);
    Y=cellfun(@(x)x',Y,'UniformOutput',false);
    Z=cellfun(@(x)x',Z,'UniformOutput',false);
    g=Rplot('x',X,'y',Y,'z',Z,'color',i*ones(1,size(X,1)));
    g=axe_property(g,'xlim',[xmmin,xmmax],...
        'ylim',[ymmin,ymmax],...
        'zlim',[zmmin,zmmax],...
        'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_line_options(g,'base_size',4,'step_size',0);
    g=geom_line(g);
    draw(g);
    % Plot Spring
    if ~isempty(obj.Spring)
        Node=[obj.V;obj.Cnode];
        NN1=NaN(size(obj.Spring,1),1);
        NN2=NaN(size(obj.Spring,1),1);
        for i=1:size(obj.Spring,1)
            NN1(i,1)=GetMasterNum(obj,obj.Spring(i,1));
            NN2(i,1)=GetMasterNum(obj,obj.Spring(i,2));
        end
        X1=Node(NN1(:,1),1);
        Y1=Node(NN1(:,1),2);
        Z1=Node(NN1(:,1),3);
        X2=Node(NN2(:,1),1);
        Y2=Node(NN2(:,1),2);
        Z2=Node(NN2(:,1),3);
        X=[X1,X2];
        Y=[Y1,Y2];
        Z=[Z1,Z2];
        X=mat2cell(X,ones(size(X,1),1));
        Y=mat2cell(Y,ones(size(Y,1),1));
        Z=mat2cell(Z,ones(size(Z,1),1));
        X=cellfun(@(x)x',X,'UniformOutput',false);
        Y=cellfun(@(x)x',Y,'UniformOutput',false);
        Z=cellfun(@(x)x',Z,'UniformOutput',false);

        g=Rplot('x',X,'y',Y,'z',Z,'color',i*ones(1,size(X,1)));
        g=axe_property(g,'xlim',[xmmin,xmmax],...
            'ylim',[ymmin,ymmax],...
            'zlim',[zmmin,zmmax],...
            'view',opt.view);
        g=set_layout_options(g,'hold',1);
        g=set_line_options(g,'base_size',4,'step_size',0);
        g=geom_line(g);
        draw(g);
    end

end
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

function [colornum,EE]=SectionPlot(obj,i,Num,EE,PartNum,opt,colornum)
% Plot part section
Order=obj.Part{PartNum,1}.mesh.order;
FF=obj.Part{PartNum,1}.mesh.facesBoundary;
post_acc=obj.Part{PartNum,1}.acc_node;
if i==Num
    if ~isempty(FF)
        EE=[EE;obj.Part{PartNum,1}.mesh.elements];
        NN=obj.Part{PartNum,1}.mesh.nodes;
    else
        EE=[EE;obj.Part{PartNum,1}.mesh.elements(:,1:2)];
        NN=obj.Part{PartNum,1}.mesh.nodes;
    end
    [EE,colornum]=PlotSectionPart(opt,EE,NN,FF,colornum,Order);
elseif obj.Part{PartNum,1}.New==0
    if ~isempty(FF)
        EE=obj.Part{PartNum,1}.mesh.elements;
        NN=obj.Part{PartNum,1}.mesh.nodes;
    else
        EE=[EE;obj.Part{PartNum,1}.mesh.elements(:,1:2)];
        NN=obj.Part{PartNum,1}.mesh.nodes;
    end
    [EE,colornum]=PlotSectionPart(opt,EE,NN,FF,colornum,Order);
elseif and(obj.Part{PartNum,1}.New==1,obj.Part{PartNum+1,1}.acc_node~=post_acc)
    if ~isempty(FF)
        EE=[EE;obj.Part{PartNum,1}.mesh.elements];
        NN=obj.Part{PartNum,1}.mesh.nodes;
    else
        EE=[EE;obj.Part{PartNum,1}.mesh.elements(:,1:2)];
        NN=obj.Part{PartNum,1}.mesh.nodes;
    end
    [EE,colornum]=PlotSectionPart(opt,EE,NN,FF,colornum,Order);
elseif and(obj.Part{PartNum,1}.New==1,obj.Part{PartNum+1,1}.acc_node==post_acc)
    if ~isempty(FF)
        EE=[EE;obj.Part{PartNum,1}.mesh.elements];
    else
        EE=[EE;obj.Part{PartNum,1}.mesh.elements(:,1:2)];
    end
end

end

function [EE,colornum]=PlotSectionPart(opt,EE,NN,FF,colornum,Order)
pos=opt.section.pos;
v=opt.section.vec;
center=patchcenter(NN,EE);
u=center-repmat(pos,size(center,1),1);
v=repmat(v,size(center,1),1);
u=mat2cell(u,ones(1,size(u,1)));
v=mat2cell(v,ones(1,size(v,1)));
angle=cellfun(@(x,y)atan2d(norm(cross(x,y)),dot(x,y)),u,v,...
    'UniformOutput',false);
angle=cell2mat(angle);
row=find(angle<=90);
MNode=[];
if ~isempty(row)
    num=size(EE,2);
    switch num
        case 2
            Face=[EE(row,:),EE(row,2)];
        case 3
            Face=EE(row,:);
        case 4
            if size(FF,2)==2
                Face=EE(row,:);
            else
                Face=element2patch(EE(row,:));
            end
        case 5
            % Face=Boundary(EE(row,:));
            Face=element2patch(EE(row,:),(1:1:size(EE(row,:),1))','pyra5');
        case 6
            if Order==1
                % Face=Boundary(EE(row,:));
                Face=element2patch(EE(row,:),(1:1:size(EE(row,:),1))','tri6');
            else
                Face=EE(row,1:3);
                MNode=NN(unique(EE(row,:)));
            end

        case 8
            if Order==1
                % Face=Boundary(EE(row,:));
                Face=element2patch(EE(row,:),(1:1:size(EE(row,:),1))','hex8');
            else
                Face=EE(row,1:4);
                MNode=NN(unique(EE(row,:)));
            end
        case 10
            % Face=Boundary(EE(row,:));
            Face=element2patch(EE(row,1:4),(1:1:size(EE(row,1:4),1))','tet4');
            % Face=Face(:,1:3);
            MNode=NN(unique(EE(row,:)));
        case 14
            % Face=element2patch(EE(row,:),[],'rhomdo14');
        case 20
            % Face=Boundary(EE(row,:));
            Face=element2patch(EE(row,1:8),(1:1:size(EE(row,1:8),1))','hex8');
            % Face=Face(:,1:4);
            MNode=NN(unique(EE(row,:)));
    end
    Cb=repmat(colornum,size(Face,1),1);
    if colornum==5
        colornum=1;
    else
        colornum=colornum+1;
    end
    % Plot face
    g=Rplot('faces',Face,'vertices',NN,'facecolor',Cb);
    g=axe_property(g,'xlim',opt.xlim,'ylim',opt.ylim,'zlim',opt.zlim,'view',opt.view);
    g=set_layout_options(g,'hold',1);
    g=set_color_options(g,'map','lch');
    g=set_line_options(g,'base_size',opt.base_size,'step_size',0);
    g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha,'face_normal',opt.face_normal);
    draw(g);  
    % Plot node
    if ~isempty(MNode)
        g=Rplot('X',MNode(:,1),'Y',MNode(:,2),'Z',MNode(:,3));
        g=set_layout_options(g,'axe',opt.axe,'hold',1);
        g=axe_property(g,'view',opt.view);
        g=set_color_options(g,'map','black');
        g=geom_point(g);
        g=set_point_options(g,'base_size',2);
        draw(g);
    end
end
EE=[];
end
