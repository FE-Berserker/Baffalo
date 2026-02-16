function obj = GainmuteEvent(obj,xshot,xmute,tmute,varargin)
% 添加倾角事件
% Author : Xie Yu
p = inputParser;
addParameter(p, 'gainpow', 1);
parse(p, varargin{:});
opt = p.Results;

t=obj.input.t;
x=obj.input.x;
Event=obj.output.Event;

Event=gainmute(Event,t,x,xshot,xmute,tmute,opt.gainpow);

obj.output.Event=Event;

end

