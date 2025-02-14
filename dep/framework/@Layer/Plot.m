function Plot(obj,varargin)
% Plot Layer
% Author : Xie Yu
p=inputParser;
addParameter(p,'group',[]);
addParameter(p,'pointson',1);
addParameter(p,'lineson',1);
addParameter(p,'mesheson',1);
addParameter(p,'dualson',1);
addParameter(p,'planeson',1);
addParameter(p,'linesmerge',0);
addParameter(p,'surfaceson',1);
addParameter(p,'face_normal',[])
addParameter(p,'face_alpha',1)
addParameter(p,'edge_alpha',1)
addParameter(p,'xlim',[])
addParameter(p,'ylim',[])
addParameter(p,'zlim',[])
addParameter(p,'edgecolor',[.2,.2,.2]);
addParameter(p,'planescale',1);
addParameter(p,'View',[]);
addParameter(p,'equal',1);
addParameter(p,'grid',1);
addParameter(p,'axe',1);

parse(p,varargin{:});
opt=p.Results;
PPx=[];PPy=[];PPz=[];
LPx=[];LPy=[];LPz=[];LCb=[];
MPx=[];MPy=[];MPz=[];
DPx=[];DPy=[];DPz=[];


if isempty(opt.group)
    if opt.pointson==1&&~isempty(obj.Points)
        PPx=cellfun(@(x)x.P(:,1),obj.Points,'UniformOutput',false);
        PPy=cellfun(@(y)y.P(:,2),obj.Points,'UniformOutput',false);
        PPz=cellfun(@(z)z.P(:,3),obj.Points,'UniformOutput',false);
    end
    if opt.lineson==1&&~isempty(obj.Lines)
        El=cellfun(@(x)(x.El),obj.Lines,'UniformOutput',false);
        if opt.linesmerge==1
            El=cellfun(@(x)[x;[x(end,2),1]],El,'UniformOutput',false);
            for i=1:size(obj.Lines,1)
                Points=obj.Lines{i,1}.P;
                EE=El{i,1};
                Div=GetLineDiv(EE);
                pre=1;
                for j=1:size(Div,1)
                    post=Div(j,1);
                    SS=EE(pre:post,:);
                    Seq=[SS(:,1);SS(end,2)];
                    LPx{end+1,1}=Points(Seq,1); %#ok<AGROW>
                    LPy{end+1,1}=Points(Seq,2); %#ok<AGROW>
                    LPz{end+1,1}=Points(Seq,3); %#ok<AGROW>
                    LCb=[LCb;i]; %#ok<AGROW>
                    pre=post+1;
                end
            end
        else
            for i=1:size(obj.Lines,1)
                Points=obj.Lines{i,1}.P;
                EE=El{i,1};
                Div=GetLineDiv(EE);   
                pre=1;
                for j=1:size(Div,1)
                    post=Div(j,1);
                    SS=EE(pre:post,:);
                    Seq=[SS(:,1);SS(end,2)];
                    LPx{end+1,1}=Points(Seq,1); %#ok<AGROW>
                    LPy{end+1,1}=Points(Seq,2); %#ok<AGROW>
                    LPz{end+1,1}=Points(Seq,3); %#ok<AGROW>
                    LCb=[LCb;i]; %#ok<AGROW>
                    pre=post+1;
                end           
            end
        end
    end
    if opt.mesheson==1&&~isempty(obj.Meshes)
        MPx=cellfun(@(x)(x.Vert(:,1)),obj.Meshes,'UniformOutput',false);
        MPy=cellfun(@(x)(x.Vert(:,2)),obj.Meshes,'UniformOutput',false);
        MPz=cellfun(@(x)(x.Vert(:,3)),obj.Meshes,'UniformOutput',false);
    end
    if opt.dualson==1&&~isempty(obj.Duals)
        DPx=cellfun(@(x)(x.pv(:,1)),obj.Duals,'UniformOutput',false);
        DPy=cellfun(@(x)(x.pv(:,2)),obj.Duals,'UniformOutput',false);
        DPz=cellfun(@(x)(x.pv(:,3)),obj.Duals,'UniformOutput',false);
    end

else
    if opt.pointson==1&&~isempty(obj.Points)
        PPx=cellfun(@(x)(x.P(:,1)),obj.Points(opt.group,1),'UniformOutput',false);
        PPy=cellfun(@(y)(y.P(:,2)),obj.Points(opt.group,1),'UniformOutput',false);
        PPz=cellfun(@(z)(z.P(:,3)),obj.Points(opt.group,1),'UniformOutput',false);
    end
    if opt.lineson==1&&~isempty(obj.Lines)
        El=cellfun(@(x)(x.El),obj.Lines(opt.group,1),'UniformOutput',false);
        if opt.linesmerge==1
            El=cellfun(@(x)[x;[x(end,2),1]],El,'UniformOutput',false);
            for i=1:size(opt.group,1)
                Points=obj.Lines{opt.group(i,1),1}.P;
                EE=El{i,1};
                Div=GetLineDiv(EE);
                pre=1;
                for j=1:size(Div,1)
                    post=Div(j,1);
                    SS=EE(pre:post,:);
                    Seq=[SS(:,1);SS(end,2)];
                    LPx{end+1,1}=Points(Seq,1); %#ok<AGROW>
                    LPy{end+1,1}=Points(Seq,2); %#ok<AGROW>
                    LPz{end+1,1}=Points(Seq,3); %#ok<AGROW>
                    LCb=[LCb;i]; %#ok<AGROW>
                    pre=post+1;
                end
            end
        else
            for i=1:size(opt.group,1)
                Points=obj.Lines{opt.group(i,1),1}.P;
                EE=El{i,1};
                Div=GetLineDiv(EE);   
                pre=1;
                for j=1:size(Div,1)
                    post=Div(j,1);
                    SS=EE(pre:post,:);
                    Seq=[SS(:,1);SS(end,2)];
                    LPx{end+1,1}=Points(Seq,1); %#ok<AGROW>
                    LPy{end+1,1}=Points(Seq,2); %#ok<AGROW>
                    LPz{end+1,1}=Points(Seq,3); %#ok<AGROW>
                    LCb=[LCb;i]; %#ok<AGROW>
                    pre=post+1;
                end           
            end
        end
    end
    if opt.mesheson==1&&~isempty(obj.Meshes)
        MPx=cellfun(@(x)(x.Vert(:,1)),obj.Meshes(opt.group,1),'UniformOutput',false);
        MPy=cellfun(@(x)(x.Vert(:,2)),obj.Meshes(opt.group,1),'UniformOutput',false);
        MPz=cellfun(@(x)(x.Vert(:,3)),obj.Meshes(opt.group,1),'UniformOutput',false);
    end
    if opt.dualson==1&&~isempty(obj.Duals)
        DPx=cellfun(@(x)(x.pv(:,1)),obj.Duals(opt.group,1),'UniformOutput',false);
        DPy=cellfun(@(x)(x.pv(:,2)),obj.Duals(opt.group,1),'UniformOutput',false);
        DPz=cellfun(@(x)(x.pv(:,3)),obj.Duals(opt.group,1),'UniformOutput',false);
    end
end

Px=[cell2mat(PPx);cell2mat(LPx);cell2mat(MPx);cell2mat(DPx)];
Py=[cell2mat(PPy);cell2mat(LPy);cell2mat(MPy);cell2mat(DPy)];
Pz=[cell2mat(PPz);cell2mat(LPz);cell2mat(MPz);cell2mat(DPz)];
if isempty(opt.xlim)

    deltax=max(Px)-min(Px);
    x1=(min(Px)-0.05*deltax).*(deltax~=0)...
        +0.95*min(Px).*(deltax==0);
    x2=(max(Px)+0.05*deltax).*(deltax~=0)...
        +1.05*max(Px).*(deltax==0);
    if and(x1==0,x2==0)
        x1=-0.05;
        x2=0.05;
    end
    xmmin=min(x1,x2);
    xmmax=max(x1,x2);
else
    xmmin=opt.xlim(1,1);
    xmmax=opt.xlim(1,2);
end

if isempty(opt.ylim)

    deltay=max(Py)-min(Py);
    y1=(min(Py)-0.05*deltay).*(deltay~=0)...
        +0.95*min(Py).*(deltay==0);
    y2=(max(Py)+0.05*deltay).*(deltay~=0)...
        +1.05*max(Py).*(deltay==0);
    if and(y1==0,y2==0)
        y1=-0.05;
        y2=0.05;
    end
    ymmin=min(y1,y2);
    ymmax=max(y1,y2);
else
    ymmin=opt.ylim(1,1);
    ymmax=opt.ylim(1,2);
end

if isempty(opt.zlim)

    deltaz=max(Pz)-min(Pz);
    z1=(min(Pz)-0.05*deltaz).*(deltaz~=0)...
        +0.95*min(Pz).*(deltaz==0);
    z2=(max(Pz)+0.05*deltaz).*(deltaz~=0)...
        +1.05*max(Pz).*(deltaz==0);
    if and(z1==0,z2==0)
        z1=-0.05;
        z2=0.05;
    end
    zmmin=min(z1,z2);
    zmmax=max(z1,z2);

else
    zmmin=opt.zlim(1,1);
    zmmax=opt.zlim(1,2);
end

figure('Position',[100 100 800 800]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
if isempty(opt.View)
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
else
    g=axe_property(g,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'View',opt.View);
end
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
draw(g);

%% Points figure
if ~isempty(obj.Points)
    if opt.pointson==1
        g1=Rplot('x',PPx,'y',PPy,'Z',PPz,'color',(1:size(PPx,1)));
        g1=geom_point(g1);
        g1=set_layout_options(g1,'hold',1);
        if ~isempty(opt.View)
            g1=axe_property(g1,'View',opt.View);
        end
        draw(g1);
    end
end
%% Lines figure
if ~isempty(obj.Lines)
    if opt.lineson==1
        g2=Rplot('x',LPx,'y',LPy,'Z',LPz,'color',LCb);
        g2=geom_line(g2);
        g2=set_layout_options(g2,'hold',1);
        if ~isempty(opt.View)
            g2=axe_property(g2,'View',opt.View,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
        else
            g2=axe_property(g2,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
        end
        draw(g2);
    end
end
%% Meshes figure
if ~isempty(obj.Meshes)
    if opt.mesheson==1
        if ~isempty(opt.group)
            Temp_Face=cellfun(@(x)(x.Face),obj.Meshes(opt.group,1),'UniformOutput',false);
            Temp_Vert=cellfun(@(x)(x.Vert),obj.Meshes(opt.group,1),'UniformOutput',false);
            Temp_Cb=cellfun(@(x)(x.Cb),obj.Meshes(opt.group,1),'UniformOutput',false);
        else
            Temp_Face=cellfun(@(x)(x.Face),obj.Meshes,'UniformOutput',false);
            Temp_Vert=cellfun(@(x)(x.Vert),obj.Meshes,'UniformOutput',false);
            Temp_Cb=cellfun(@(x)(x.Cb),obj.Meshes,'UniformOutput',false);

        end
        g3=Rplot('faces',Temp_Face,'vertices',Temp_Vert,'facecolor',Temp_Cb);
        g3=geom_patch(g3,'face_normal',opt.face_normal,'face_alpha',opt.face_alpha,'edgecolor',opt.edgecolor,'edge_alpha',opt.edge_alpha);
        if isempty(opt.View)
            g3=axe_property(g3,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
        else
            g3=axe_property(g3,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax],'View',opt.View);
        end
        g3 = set_line_options(g3 , 'base_size', 0.5);
        g3=set_layout_options(g3,'hold',1);
        draw(g3);
    end
end
%% Duals figure
if ~isempty(obj.Duals)
    if opt.dualson==1
        if ~isempty(opt.group)
            Temp_cp=cellfun(@(x)(x.cp),obj.Duals(opt.group,1),'UniformOutput',false);
            Temp_ce=cellfun(@(x)(x.ce),obj.Duals(opt.group,1),'UniformOutput',false);
            Temp_ev=cellfun(@(x)(x.ev),obj.Duals(opt.group,1),'UniformOutput',false);
            Temp_pv=cellfun(@(x)(x.pv),obj.Duals(opt.group,1),'UniformOutput',false);
            Temp_Cb=cellfun(@(x)(x.Cb),obj.Duals(opt.group,1),'UniformOutput',false);
        else
            Temp_cp=cellfun(@(x)(x.cp),obj.Duals,'UniformOutput',false);
            Temp_ce=cellfun(@(x)(x.ce),obj.Duals,'UniformOutput',false);
            Temp_ev=cellfun(@(x)(x.ev),obj.Duals,'UniformOutput',false);
            Temp_pv=cellfun(@(x)(x.pv),obj.Duals,'UniformOutput',false);
            Temp_Cb=cellfun(@(x)(x.Cb),obj.Duals,'UniformOutput',false);
        end
        Temp_tv=cell(size(Temp_cp,1),1);
        for i=1:size(Temp_cp,1)
            cp=Temp_cp{i,1};
            ce=Temp_ce{i,1};
            ev=Temp_ev{i,1};
            %             Cb=Temp_Cb{i,1};
            %             pv=Temp_pv{i,1};
            [~,Temp_tv{i,1}] = triadual2(cp,ce,ev);
        end
        g4=Rplot('faces',Temp_tv,'vertices',Temp_pv,'facecolor',Temp_Cb);
        g4=set_layout_options(g4,'axe',opt.axe,'hold',1);
        g4=geom_patch(g4,'face_alpha',opt.face_alpha,'edgecolor','none');
        if ~isempty(opt.View)
            g4=axe_property(g4,'View',opt.View,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
        else
            g4=axe_property(g4,'xlim',[xmmin,xmmax],'ylim',[ymmin,ymmax],'zlim',[zmmin,zmmax]);
        end
        g4=set_layout_options(g4,'hold',1);
        draw(g4);
    end

    for i=1:size(Temp_ev,1)
        pv=Temp_pv{i,1};
        ev=Temp_ev{i,1};
        cp=Temp_cp{i,1};
        ce=Temp_ce{i,1};
        in = zeros(size(ev,1),1);
        for ci = 1 : size(cp,1)
            in(ce(cp(ci,2):cp(ci,3))) = +1;
        end
        patch('faces',ev(in==+1,:),'vertices',pv,'facecolor','none','edgecolor',opt.edgecolor);
    end
end
%% Planes figure
if ~isempty(obj.Planes)
    if opt.planeson==1
        for i=1:size(obj.Planes,1)
            ori=obj.Planes(i,1:3);
            vec1=obj.Planes(i,4:6);
            vec2=obj.Planes(i,7:9);
            scale=opt.planescale;
            p1=ori+(vec1+vec2).*scale;
            p2=ori+(vec1-vec2).*scale;
            p3=ori+(-vec1-vec2).*scale;
            p4=ori+(-vec1+vec2).*scale;
            Vert=[p1;p2;p3;p4];
            Face=[1,2,3,4];
            patch('faces',Face,'vertices',Vert,'facecolor',[0,1,1],'edgecolor','none','FaceAlpha',0.2);
        end
    end
end
end


function Div=GetLineDiv(El)
% Get Line divisions
Seq=(1:size(El,1)-1)';
Temp=El(2:end,1)-El(1:end-1,2);
Div=Seq(Temp~=0,1);
Div=[Div;size(El,1)];
end
