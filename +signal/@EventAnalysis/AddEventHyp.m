function obj = AddEventHyp(obj,vstk,t0,x0,amp,hypflag,hypaper)
% 添加倾角事件
% Author : Xie Yu

t=obj.input.t;
x=obj.input.x;

if nargin<3
    t0=min(t);
    x0=(max(x)+min(x))/2;
    amp=1;
    hypflag=3;
    hypaper=inf;
elseif nargin<4
    x0=(max(x)+min(x))/2;
    amp=1;
    hypflag=3;
    hypaper=inf;
elseif nargin<5
    amp=1;
    hypflag=3;
    hypaper=inf;
elseif nargin<6
    hypflag=3;
    hypaper=inf;
elseif nargin<7
    hypaper=inf;
end

Event=obj.output.Event;

Event=event_hyp(Event,t,x,t0,x0,vstk,amp(1),hypflag,hypaper); % 生成双曲事件

obj.output.Event=Event;

end

