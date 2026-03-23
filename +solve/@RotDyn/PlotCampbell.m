function obj=PlotCampbell(obj,varargin)
% Plot Campbell
% Author : Xie Yu
p=inputParser;
addParameter(p,'NMode',[]);
addParameter(p,'Exci',1);
parse(p,varargin{:});
opt=p.Results;

if isempty(opt.NMode)
    opt.NMode=obj.params.NMode;
end

if isempty(obj.output.Campbell)
    obj=ImportCampbell(obj,'Campbell.txt',opt.NMode);
end
X=obj.input.Speed;
Y=table2array(obj.output.Campbell(:,3:end));

if ~isempty(opt.NMode)
    Y=Y(1:opt.NMode,:);
end

if isempty(opt.Exci)
    figure
    g=Rplot('x',X,'y',Y,'color',1:size(Y,1));
    g=set_title(g,'Campbell Chart');
    g=set_layout_options(g,'axe',1);
    g=axe_property(g,'xlim',[0,X(1,end)],'ylim',[0,max(max(Y))]);
    g=set_names(g,'column','Origin','x','Speed [RPM]','y','Frequency [Hz]','color','Mode');
    g=set_axe_options(g,'grid',1);
    g=geom_line(g);
    draw(g);
else
    Y1=NaN(size(opt.Exci,1),numel(X));
    for i=1:size(opt.Exci,1)
        Num=opt.Exci(i,1);
        Y1(i,:)=X/60*Num;
    end

    figure
    g=Rplot('init',1);
    g=set_layout_options(g,'axe',1,'hold',1);
    g=axe_property(g,'xlim',[0,X(1,end)],'ylim',[0,max(max(Y))],'view',[0,90]);
    draw(g);

    g=Rplot('x',X,'y',Y,'color',1:size(Y,1));
    g=set_layout_options(g,'hold',1);
    g=set_names(g,'column','Origin','x','Speed [RPM]','y','Frequency [Hz]','color','Mode');
    g=set_axe_options(g,'grid',1);
    g=axe_property(g,'xlim',[0,X(1,end)],'ylim',[0,max(max(Y))],'view',[0,90]);
    g=geom_line(g);
    draw(g);

    g=Rplot('x',X,'y',Y1);
    g=set_layout_options(g,'hold',1);
    g=set_names(g,'column','Origin','x','Speed [RPM]','y','Frequency [Hz]');
    g=set_axe_options(g,'grid',1);
    g=axe_property(g,'xlim',[0,X(1,end)],'ylim',[0,max(max(Y))],'view',[0,90]);
    g=set_color_options(g,'map','black');
    g=geom_line(g);
    draw(g);


    X3=[];
    Y3=[];
    for i=1:size(Y1,1)
        a=Point2D('Temp','Echo',0);
        a=AddPoint(a,X',Y1(i,:)');

        b=Line2D('Temp','Echo',0);
        b=AddCurve(b,a,1);
        for j=1:size(Y,1)
            a=AddPoint(a,X',Y(j,:)');
            b=AddCurve(b,a,j+1);
        end

        for k=1:size(Y,1)
            [x0,y0]= CurveIntersection(b,1,k+1);
            X3=[X3;x0];
            Y3=[Y3;y0];
        end
    end


    g=Rplot('x',X3,'y',Y3);
    g=set_layout_options(g,'hold',1);
    g=set_names(g,'column','Origin','x','Speed [RPM]','y','Frequency [Hz]');
    g=set_axe_options(g,'grid',1);
    g=axe_property(g,'xlim',[0,X(1,end)],'ylim',[0,max(max(Y))],'view',[0,90]);
    g=set_color_options(g,'map','red');
    g=geom_point(g);
    draw(g);

end

end