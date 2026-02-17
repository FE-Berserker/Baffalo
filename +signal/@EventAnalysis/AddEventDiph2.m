function obj = AddEventDiph2(obj,v,x0,x1,z0,ndelx,theta,amp,flag,noversamp)
% EVENT_DIPH2: construct a dipping event with sparse diffraction superposition
% EVENT_DIPH2: 构造一个带有稀疏绕射叠加的倾伏事件
%
% obj = AddEventDiph2(obj,v,x0,x1,z0,ndelx,theta,amp,flag,noversamp)
%
% EVENT_DIPH2 inserts a dipping (linear) event in a matrix. The event
% is constructed from a superposition of hyperbolae. The spacing of the
% hyperbolae is controlled by ndelx.
% EVENT_DIPH2 在矩阵中插入一个倾伏（线性）事件。该事件由双曲线的叠加构成。
% 双曲线的间距由 ndelx 控制。
%
% v ... velocity (scalar)
% v ... 速度（标量）。
% x0 ... starting x coordinate of the event
% x0 ... 事件的起始 x 坐标。
% x1 ... ending x coordinate of the event
% x1 ... 事件的结束 x 坐标。
% z0 ... starting depth of the event
% z0 ... 事件的起始深度。
% ndelx ... horizontal distance between hyperbola expressed as xdist=ndelx*dx
%        where dx=x(2)-x(1). ndelx must be an integer greater than or equal to one.
% ndelx ... 双曲线之间的水平距离，表示为 xdist=ndelx*dx，其中 dx=x(2)-x(1)。
%         ndelx 必须是大于等于 1 的整数。
% theta ... dip (degrees) of the event
% theta ... 事件的倾角（度）。
% amp ... vector of length 2 giving the amplitudes at either end of the event. Intermediate
%       amplitudes are interpolated in x. Can be a single number if constant amplitude is desired.
% amp ... 长度为 2 的向量，给出事件两端的振幅。中间振幅在 x 方向进行插值。
%       如需恒定振幅，可输入单个数值。
% flag ... if 1, then amplitudes are divided by cos(theta), otherwise no effect
% flag ... 如果为 1，振幅除以 cos(theta)，否则无影响。
%      ******** default = 1 *********
%      ******** 默认值 = 1 *********
% noversamp ... each output trace is created by nearest-neighbor interpolation into
%		a temporary over-sampled trace that is then properly resampled. The greater the
%		oversampling, the better the result.
% noversamp ... 每条输出道通过最近邻插值创建到临时过采样道中，然后进行适当重采样。
%		过采样倍数越高，结果越好。
%      ******** default = 10 *********
%      ******** 默认值 = 10 *********

t=obj.input.t;
x=obj.input.x;
Event=obj.output.Event;

if nargin < 6
    error('ndelx is required. Must be an integer >= 1.');
end

if nargin < 7
    theta = 0;
end

if nargin < 8
    amp =[1,1];
    flag=1;
    noversamp=10;
end

if nargin < 9
    flag=1;
    noversamp=10;
end

if nargin < 10
    noversamp=10;
end

Event=event_diph2(Event,t,x,v,x0,x1,z0,ndelx,theta,amp,flag,noversamp);

obj.output.Event=Event;

end

