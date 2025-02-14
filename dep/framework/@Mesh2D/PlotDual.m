function PlotDual(obj,varargin)
%PLOT Plot Mesh2D object

p=inputParser;
addParameter(p,'grid',0);
addParameter(p,'area',0);
addParameter(p,'center',0);
addParameter(p,'axe',1);
addParameter(p,'equal',1);
addParameter(p,'base_size',1);
addParameter(p,'xlim',[]);
addParameter(p,'ylim',[]);
parse(p,varargin{:});
opt=p.Results;

cp=obj.Dual.cp;
ce=obj.Dual.ce;
ev=obj.Dual.ev;
pv=obj.Dual.pv(:,1:2);

[~,tv] = triadual2(cp,ce,ev);
%only draw indexed edges
in = zeros(size(ev,1),1);
for ci = 1 : size(cp,1)
    in(ce(cp(ci,2):cp(ci,3))) = +1;
end
% Intial
figure('Position',[100 100 500 500]);
g=Rplot('init',1);
g=set_layout_options(g,'axe',opt.axe,'hold',1);
if and(~isempty(opt.xlim),~isempty(opt.ylim))
    g=axe_property(g,'xlim',opt.xlim,'ylim',opt.ylim,'View',[0,90]);
elseif and(~isempty(opt.xlim),isempty(opt.ylim))
    g=axe_property(g,'xlim',opt.xlim,'View',[0,90]);
elseif and(isempty(opt.xlim),~isempty(opt.ylim))
    g=axe_property(g,'ylim',opt.ylim,'View',[0,90]);
end
g=set_axe_options(g,'grid',opt.grid,'equal',opt.equal);
draw(g);

if  opt.area==0
    g=Rplot('faces',tv,'vertices',pv);
    g=set_layout_options(g,'axe',opt.axe,'hold',1);
    if and(~isempty(opt.xlim),~isempty(opt.ylim))
        g=axe_property(g,'xlim',opt.xlim,'ylim',opt.ylim,'View',[0,90]);
    elseif and(~isempty(opt.xlim),isempty(opt.ylim))
        g=axe_property(g,'xlim',opt.xlim,'View',[0,90]);
    elseif and(isempty(opt.xlim),~isempty(opt.ylim))
        g=axe_property(g,'ylim',opt.ylim,'View',[0,90]);
    end
    g=geom_patch(g,'edgecolor','none');
    % figure
    draw(g);
else
    [~,fc]=ComputeGeometryDual(obj);
%------------------------------------ triangulate dual cells
   [tp,tv] = triadual2(cp,ce,ev);
%----------------------------- expand cell colour onto trias
    if (size(fc,1) == size(tp,1))
    %-------------------------------- alloc. colour per tria
        tc = zeros(size(tv,1),1);
    %-------------------------------- expand colour per tria
        for ci = 1 : size(tp,1)
            for ti = tp(ci,1):tp(ci,2)
                tc(ti) = fc(ci) ;
            end
        end
    else
    %--------------------------------------- uniform colours
        tc = fc;
    end 
    patch('faces',tv,'vertices',pv,'facevertexcdata',tc,...
        'facecolor','flat','edgecolor','none');

end

if opt.center==1
    [pc,~]=ComputeGeometryDual(obj);
    g=Rplot('x',pc(:,1),'y',pc(:,2),'Z',pc(:,3));
    g=geom_point(g);
    g=set_layout_options(g,'hold',1);
    if and(~isempty(opt.xlim),~isempty(opt.ylim))
        g=axe_property(g,'xlim',opt.xlim,'ylim',opt.ylim,'View',[0,90]);
    elseif and(~isempty(opt.xlim),isempty(opt.ylim))
        g=axe_property(g,'xlim',opt.xlim,'View',[0,90]);
    elseif and(isempty(opt.xlim),~isempty(opt.ylim))
        g=axe_property(g,'ylim',opt.ylim,'View',[0,90]);
    end
    draw(g);
end


patch('faces',ev(in==+1,:),'vertices',pv,'facecolor','none','linewidth',opt.base_size);

end

