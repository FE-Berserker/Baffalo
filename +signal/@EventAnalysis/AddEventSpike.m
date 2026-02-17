function obj = AddEventSpike(obj,tnot,xnot,amp)
% EVENT_SPIKE: inserts a spike in a matrix
% EVENT_SPIKE: 在矩阵中插入一个尖峰事件
%
% obj = AddEventSpike(obj,tnot,xnot,amp)
%
% EVENT_SPIKE inserts a spike event in a matrix.
% EVENT_SPIKE 在矩阵中插入一个尖峰事件。
%
% tnot ... t coordinate of the spike
% tnot ... 尖峰的时间坐标。
% xnot ... x coordinate of the spike
% xnot ... 尖峰的空间坐标。
% amp ... amplitude spike
% amp ... 尖峰振幅。

t=obj.input.t;
x=obj.input.x;
Event=obj.output.Event;

Event=event_spike(Event,t,x,tnot,xnot,amp);

obj.output.Event=Event;

end

