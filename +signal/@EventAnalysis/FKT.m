function obj=FKT(obj)
%% 解析可选参数

t=obj.input.t;
x=obj.input.x;
Event=obj.output.Event;
[fks,f,k]=fktran(Event,t,x); % 计算 FK 变换

% 输出
obj.output.FKT.f=f;
obj.output.FKT.k=k;
obj.output.FKT.fks=fks;

end
