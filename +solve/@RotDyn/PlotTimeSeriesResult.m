function PlotTimeSeriesResult(obj,varargin)
% Plot TimeSeriesResult of RotDyn
% Author : XieYu
p=inputParser;
addParameter(p,'Component',[]);% Component no'
addParameter(p,'Node',[]);% Node no
addParameter(p,'Load',[]);% Load no
addParameter(p,'PIDController',[]);% Controller no
addParameter(p,'rpm',1);% rpm no
parse(p,varargin{:});
opt=p.Results;


if obj.params.Type==5
    opt.rpm=1;
end
Result=GetTimeSeriesResult(obj,'Node',opt.Node,'Component',opt.Component,...
    'Load',opt.Load,'rpm',opt.rpm,...
    'PIDController',opt.PIDController);

for i=1:size(opt.rpm,1)

    for j=1:size(Result(i).data,2)
        Data=Result(i).data(j);

        x=Data.Time;
        x=repmat(x,3,1);
        x=mat2cell(x,ones(1,3))';

        Pos = GetNodePos(obj,Data.Node);

        y1=cell(1,3);
        y1{1}=Data.X;
        y1{2}=Data.Y;
        y1{3}=Data.Z;
        y2=cell(1,3);
        y2{1}=Data.TX;
        y2{2}=Data.MY;
        y2{3}=Data.MZ;
        Cb=cell(3,1);

        switch Data.Unit
            case 'mm'
                Cb{1,1}='Ux';
                Cb{2,1}='Uy';
                Cb{3,1}='Uz';
                ylabel=strcat('$mm$');
            case 'mm/s'
                Cb{1,1}='vx';
                Cb{2,1}='vy';
                Cb{3,1}='vz';
                ylabel=strcat('$mm/s$');
            case 'mm/s2'
                Cb{1,1}='ax';
                Cb{2,1}='ay';
                Cb{3,1}='az';
                ylabel=strcat('$mm/s^2$');
            case 'N'
                Cb{1,1}='Fx';
                Cb{2,1}='Fy';
                Cb{3,1}='Fz';
                ylabel=strcat('$N$');
        end

        figure('Position',[100 100 1000 800]);
        g(1,1)=Rplot('x',x,'y',y1,'color',Cb);
        g(1,1)=set_line_options(g(1,1),'base_size',1,'step_size',0);
        g(1,1)=set_text_options(g(1,1),'interpreter','latex');
        g(1,1)=axe_property(g(1,1),'XLim',[0,Data.Time(end)]);
        g(1,1)=set_axe_options(g(1,1),'grid',1);
        g(1,1)=set_names(g(1,1),'column','Origin','x','Time (s)','y',ylabel,'color','Position');
        g(1,1)=geom_line(g(1,1));

        switch Data.Unit
            case 'mm'
                Cb{1,1}='$\theta_x$';
                Cb{2,1}='$\theta_y$';
                Cb{3,1}='$\theta_z$';
                ylabel=strcat('$rad$');
            case 'mm/s'
                Cb{1,1}='$\theta_x/s$';
                Cb{2,1}='$\theta_y/s$';
                Cb{3,1}='$\theta_z/s$';
                ylabel=strcat('$rad/s$');
            case 'mm/s2'
                Cb{1,1}='$\theta_x/s^2$';
                Cb{2,1}='$\theta_y/s^2$';
                Cb{3,1}='$\theta_z/s^2$';
                ylabel=strcat('$rad/s^2$');
            case 'N'
                Cb{1,1}='Tx';
                Cb{2,1}='My';
                Cb{3,1}='Mz';
                ylabel=strcat('$Nmm$');
        end


        g(2,1)=Rplot('x',x,'y',y2,'color',Cb);
        g(2,1)=set_line_options(g(2,1),'base_size',1,'step_size',0);
        g(2,1)=set_text_options(g(2,1),'interpreter','latex');
        g(2,1)=axe_property(g(2,1),'XLim',[0,Data.Time(end)]);
        g(2,1)=set_axe_options(g(2,1),'grid',1);
        g(2,1)=set_names(g(2,1),'column','Origin','x','Time (s)','y',ylabel,'color','Position');
        g(2,1)=geom_line(g(2,1));
        g=set_title(g,strcat(Data.Name,'(Position',num2str(Pos),')'));
        draw(g);

    end

end
end