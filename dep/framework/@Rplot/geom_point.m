function obj=geom_point(obj,varargin)
% geom_point Display data as points
%
% This will add a layer that will display data as points

p=inputParser;
addParameter(p,'dodge',0);
addParameter(p,'alpha',1);
parse(p,varargin{:});


obj.geom=vertcat(obj.geom,{@(dobj,dd)my_point(dobj,dd,p.Results)});
obj.results.geom_point_handle={};
end

function hndl=my_point(obj,draw_data,params)
if obj.continuous_color_options.active
    
    obj.plot_lim.maxc(obj.current_row,obj.current_column)=max(obj.plot_lim.maxc(obj.current_row,obj.current_column),max(comb(draw_data.continuous_color)));
    obj.plot_lim.minc(obj.current_row,obj.current_column)=min(obj.plot_lim.maxc(obj.current_row,obj.current_column),min(comb(draw_data.continuous_color)));
    
    if isempty(draw_data.z)
            [x,y]=to_polar(obj,draw_data.x,draw_data.y);
            if iscell(draw_data.x) && ~iscell(draw_data.continuous_color) % Case in which continuous color is given as an array while xy given as cells
                for k=1:length(x)
                    hndl=scatter(x{k},y{k},...
                        draw_data.point_size.^2,...
                        repmat(draw_data.continuous_color(k),length(x{k}),1),...
                        draw_data.marker,...
                        'MarkerFaceColor','flat','MarkerEdgeColor','none');
                end
            else % Case in which xy and continuous color are all arrays or all cells
                hndl=scatter(comb(x),comb(y),...
                    draw_data.point_size.^2,...
                    comb(draw_data.continuous_color),...
                    draw_data.marker,...
                    'MarkerFaceColor','flat','MarkerEdgeColor','none');
            end
    else
        if iscell(draw_data.x) && ~iscell(draw_data.continuous_color) % Case in which continuous color is given as an array while xyz given as cells
            for k=1:length(draw_data.x)
                hndl=scatter3(draw_data.x{k},draw_data.y{k},draw_data.z{k},...
                    draw_data.point_size.^2,...
                    repmat(draw_data.continuous_color(k),length(draw_data.x{k}),1),...
                    draw_data.marker,...
                    'MarkerFaceColor','flat','MarkerEdgeColor','none');
            end
        else % Case in which xyz and continuous color are all arrays or all cells
            hndl=scatter3(comb(draw_data.x),comb(draw_data.y),comb(draw_data.z),...
                draw_data.point_size.^2,...
                comb(draw_data.continuous_color),...
                draw_data.marker,...
                'MarkerFaceColor','flat','MarkerEdgeColor','none');
        end
    end
else
    if isempty(draw_data.z)
        %Normal case !
        x=comb(draw_data.x);
       
        x=dodger(x,draw_data,params.dodge);

        [x,y]=to_polar(obj,x,comb(draw_data.y));
        hndl=line(x,y,...
            'LineStyle','none',...
            'Marker',draw_data.marker,...
            'MarkerEdgeColor','none',...
            'MarkerSize',draw_data.point_size,...
            'MarkerFaceColor',draw_data.color);
    else
        hndl=line(comb(draw_data.x),comb(draw_data.y),comb(draw_data.z),...
            'LineStyle','none',...
            'Marker',draw_data.marker,...
            'MarkerEdgeColor','none',...
            'markerSize',draw_data.point_size,...
            'MarkerFaceColor',draw_data.color);
    end
end

if obj.point_options.plabel==1
    for i=1:size(x,1)
        drawText(obj,x(i,1),y(i,1),sprintf('P%d',i));
    end
end

set_alpha(hndl,1,params.alpha);

obj.results.geom_point_handle{obj.result_ind,1}=hndl;
end