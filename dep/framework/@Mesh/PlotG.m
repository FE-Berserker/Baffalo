function PlotG(obj,varargin)
% Plot Mesh G
% Author : Xie Yu
p=inputParser;
addParameter(p,'grid',1);
addParameter(p,'name',1);
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'alpha',1);
addParameter(p,'face_alpha',1);
addParameter(p,'section',[]);
addParameter(p,'volume',[]);
parse(p,varargin{:});
opt=p.Results;

if isempty(obj.G)
    fprintf('Nothing to plot.\n');
end

G=obj.G;
nodes = G.faces.nodes;
Temp1=G.cells.faces(:,1);
Temp1=reshape(Temp1,[6,size(Temp1,1)/6]);
Temp1=Temp1';
Temp2=G.faces.nodes;
Temp2=reshape(Temp2,[4,size(Temp2,1)/4]);
Temp2=Temp2';
elements=[Temp2(Temp1(:,1),:),Temp2(Temp1(:,2),:)];
faces=element2patch(elements,[],'hex8');

if isempty(opt.section)
    Face=faces;
else
    pos=opt.section.pos;
    v=opt.section.vec;
    numel=size(elements,1);
    Center=zeros(numel,3);
    for i=1:numel
        Temp_n=elements(i,:);
        nn=nodes(Temp_n',:);
        Center(i,:)=mean(nn);
    end
    u=center-repmat(pos,size(center,1),1);
    v=repmat(v,size(center,1),1);
    u=mat2cell(u,ones(1,size(u,1)));
    v=mat2cell(v,ones(1,size(v,1)));
    angle=cellfun(@(x,y)atan2d(norm(cross(x,y)),dot(x,y)),u,v,...
        'UniformOutput',false);
    angle=cell2mat(angle);
    row=angle<=90;
    Face=element2patch(elements(row,:),[],'hex8');
end

Vert=obj.Meshoutput.nodes;
if opt.volume==0
    g=Rplot('faces',Face,'vertices',Vert);
else
    volume=G.cells.volumes;
    minv=min(volume);
    maxv=max(volume);
    Delta=maxv-minv;
    Cb=round((volume-minv)/Delta*100)+1;
    g=Rplot('faces',Face,'vertices',Vert,'facecolor',repmat(Cb,6,1));
    g=set_color_options(g,'othermap','BuOrR_14');

end

if opt.name
    g=set_title(g,'View Solid of elements');
end

g=set_layout_options(g,'axe',opt.axe);
g=set_line_options(g,'base_size',1);
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);

g=geom_patch(g,'alpha',opt.alpha,'face_alpha',opt.face_alpha);

% figure
figure('Position',[100 100 800 800]);
draw(g);
end

