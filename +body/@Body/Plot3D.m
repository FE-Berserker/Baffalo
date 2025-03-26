function Plot3D(obj,varargin)
p=inputParser;
addParameter(p,'faceno',[]);
addParameter(p,'face_normal',0);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.faceno)
    PlotFace(obj.output.SolidMesh,'face_normal',opt.face_normal,'face_alpha',1);
else
    Temp=obj.output.SolidMesh;
    Cb=Temp.Cb;
    Cb(Temp.Cb==opt.faceno,:)=1;
    Cb(Temp.Cb~=opt.faceno,:)=2;
    g1=Rplot('faces',Temp.Face,'vertices',Temp.Vert,'facecolor',Cb);
    g1=set_title(g1,'View face of elements');
    g1=set_layout_options(g1,'axe',1);
    g1=set_line_options(g1,'base_size',1,'step_size',0);
    g1=set_axe_options(g1,'grid',1,'equal',1);
    g1=geom_patch(g1,'alpha',1,'face_alpha',0.5,'face_normal',opt.face_normal);
    % figure
    figure('Position',[100 100 800 800]);
    draw(g1);


end
end