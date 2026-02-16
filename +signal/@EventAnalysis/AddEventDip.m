function obj = AddEventDip(obj,tlim,xlim,amp)
% 添加倾角事件
% Author : Xie Yu

t=obj.input.t;
x=obj.input.x;

if nargin < 2
xlim=[min(x) max(x)];
tlim=[min(t) max(t)];
amp =[1,1];
end

if nargin < 3
    xlim=[min(x) max(x)];
    amp =[1,1];
end

if nargin < 4
    amp =[1,1];
end

Event=obj.output.Event;

Event=event_dip(Event,t,x,tlim,xlim,amp); % 生成倾角事件

obj.output.Event=Event;

end

