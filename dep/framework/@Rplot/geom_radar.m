function obj=geom_radar(obj,varargin)
% geom_radar Display data as radar
%
% This will add a layer that will display data as radar
p=inputParser;
addParameter(p,'dodge',0);
addParameter(p,'alpha',1);
parse(p,varargin{:});

obj.multi.radar=1;
obj.geom=vertcat(obj.geom,{@(dobj,dd)my_radar(dobj,dd,p.Results)});
obj.results.geom_radar_handle={};
end

function hndl=my_radar(obj,draw_data,params)
if obj.continuous_color_options.active

    obj.plot_lim.maxc(obj.current_row,obj.current_column)=max(obj.plot_lim.maxc(obj.current_row,obj.current_column),max(comb(draw_data.continuous_color)));
    obj.plot_lim.minc(obj.current_row,obj.current_column)=min(obj.plot_lim.minc(obj.current_row,obj.current_column),min(comb(draw_data.continuous_color)));

    if isempty(draw_data.z)
        [x,y]=to_polar(obj,draw_data.x,draw_data.y);

        %We fake continuous colors lines by creating patch objects
        %without fill. Since they need to be closed we draw the
        %line twice
        if iscell(x)
            for k=1:length(x)
                if iscell(draw_data.continuous_color) %Within-line continuous color given
                    hndl=patch([shiftdim(x{k}) ; flipud(shiftdim(x{k}))],...
                        [shiftdim(y{k}) ; flipud(shiftdim(y{k}))],...
                        [shiftdim(draw_data.continuous_color{k}) ; flipud(shiftdim(draw_data.continuous_color{k}))],...
                        'faceColor','none','EdgeColor','interp','lineWidth',draw_data.line_size,'LineStyle',draw_data.line_style);
                else %Per-line continuous color given
                    hndl=patch([shiftdim(x{k}) ; flipud(shiftdim(x{k}))],...
                        [shiftdim(y{k}) ; flipud(shiftdim(y{k}))],...
                        repmat(draw_data.continuous_color(k),length(x{k})*2,1),...
                        'faceColor','none','EdgeColor','interp','lineWidth',draw_data.line_size,'LineStyle',draw_data.line_style);
                end
            end
        else
            hndl=patch([shiftdim(x) ; flipud(shiftdim(x))],...
                [shiftdim(y) ; flipud(shiftdim(y))],...
                [shiftdim(draw_data.continuous_color) ; flipud(shiftdim(draw_data.continuous_color))],...
                'faceColor','none','EdgeColor','interp','lineWidth',draw_data.line_size,'LineStyle',draw_data.line_style);
        end
    else
        if iscell(draw_data.x)
            for k=1:length(draw_data.x)
                if iscell(draw_data.continuous_color) %Within-line continuous color given
                    hndl=patch([shiftdim(draw_data.x{k}) ; flipud(shiftdim(draw_data.x{k}))],...
                        [shiftdim(draw_data.y{k}) ; flipud(shiftdim(draw_data.y{k}))],...
                        [shiftdim(draw_data.z{k}) ; flipud(shiftdim(draw_data.z{k}))],...
                        [shiftdim(draw_data.continuous_color{k}) ; flipud(shiftdim(draw_data.continuous_color{k}))],...
                        'faceColor','none','EdgeColor','interp','lineWidth',draw_data.line_size,'LineStyle',draw_data.line_style);
                else %Per-line continuous color given
                    hndl=patch([shiftdim(draw_data.x{k}) ; flipud(shiftdim(draw_data.x{k}))],...
                        [shiftdim(draw_data.y{k}) ; flipud(shiftdim(draw_data.y{k}))],...
                        [shiftdim(draw_data.z{k}) ; flipud(shiftdim(draw_data.z{k}))],...
                        repmat(draw_data.continuous_color(k),length(draw_data.x{k})*2,1),...
                        'faceColor','none','EdgeColor','interp','lineWidth',draw_data.line_size,'LineStyle',draw_data.line_style);
                end
            end
        else
            hndl=patch([shiftdim(draw_data.x) ; flipud(shiftdim(draw_data.x))],...
                [shiftdim(draw_data.y) ; flipud(shiftdim(draw_data.y))],...
                [shiftdim(draw_data.z) ; flipud(shiftdim(draw_data.z))],...
                [shiftdim(draw_data.continuous_color) ; flipud(shiftdim(draw_data.continuous_color))],...
                'faceColor','none','EdgeColor','interp','lineWidth',draw_data.line_size,'LineStyle',draw_data.line_style);
        end
    end


else
    %Combnan allows for drawing multiple lines without loops
    %(it adds a NaN between lines that have to be separated)
    if isempty(draw_data.z)

        x=combnan(draw_data.x);
        y=combnan(draw_data.y);
        x=dodger(x,draw_data,params.dodge);
        [x,y]=to_polar(obj,x,y);
        if ~obj.axe_options.rad
            x=x/180*pi;
        end

        hndl=line(combnan(x),combnan(y),'LineStyle',draw_data.line_style,'lineWidth',draw_data.line_size,'Color',draw_data.color);
    else
        error('Radar plot can not have z axial data')
    end
end


set_alpha(hndl,params.alpha,1);
obj.results.geom_radar_handle{obj.result_ind,1}=hndl;

end

