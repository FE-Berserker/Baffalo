function PlotEvent(obj, varargin)

p = inputParser;
addParameter(p, 'xRange', []); % 空间范围
addParameter(p, 'tRange', []); % 时间范围

parse(p, varargin{:});
opt = p.Results;


x=obj.input.x;
t=obj.input.t;
Event=obj.output.Event;

if ~isempty(opt.xRange)
    indx=near(x,opt.xRange(1),opt.xRange(2));%space window
    Event=Event(:,indx);
end

if ~isempty(opt.tRange)
    ind=near(t,opt.xRange(1),opt.xRange(2));%time window
    Event=Event(ind,:);
end


figure
imagesc(x,t,Event);
axis xy
xlabel('Position');
ylabel('Time [s]');
set(gca, 'YDir', 'reverse');
colormap gray
colorbar
end

