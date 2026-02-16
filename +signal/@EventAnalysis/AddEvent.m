function obj = AddEvent(obj,Event_New)
% 添加事件
% Author : Xie Yu

Event=obj.output.Event;
Event=Event+Event_New;

obj.output.Event=Event;

end

