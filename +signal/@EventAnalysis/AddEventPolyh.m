function obj = AddEventPolyh(obj,v,xhyp,zhyp,ahyp,flag,dx,noversamp)
% EVENT_POLYH: construct a polygonal event by diffraction superposition
% EVENT_POLYH: 通过绕射叠加构造一个多边形事件
%
% obj = AddEventPolyh(obj,v,xhyp,zhyp,ahyp,flag,dx,noversamp)
%
% EVENT_POLYH inserts a polygonal event in a matrix. The event
% is constructed from a superposition of hyperbolae.
% EVENT_POLYH 在矩阵中插入一个多边形事件。该事件由双曲线的叠加构成。
%
% v ... velocity (scalar)
% v ... 速度（标量）。
% xhyp ... vector of x coordinates of hyperbolae
% xhyp ... 双曲线的 x 坐标向量。
% zhyp ... vector of z coordinates of hyperbolae
% zhyp ... 双曲线的 z 坐标向量。
% ahyp ... vector of amplitudes of hyperbolae
% ahyp ... 双曲线的振幅向量。
%    ****NOTE: ahyp, xhyp, and zhyp must all be the same size****
%    ****注意：ahyp, xhyp 和 zhyp 必须具有相同的大小****
% flag ... if 1, then amplitudes are divided by cos(theta), otherwise no effect
% flag ... 如果为 1，振幅除以 cos(theta)，否则无影响。
%      ******** default = 1 *********
%      ******** 默认值 = 1 *********
% dx ... nominal spacing of hyperbolae. Between each pair of xhyp, hyperbolae
%		will be placed at this horizontal increment if the local dip is zero. For
%		nonzero dip the horizontal spacing is dx*cos(theta).
% dx ... 双曲线的名义间距。在每对 xhyp 之间，如果局部倾角为零，双曲线
%       将按此水平增量放置。对于非零倾角，水平间距为 dx*cos(theta)。
%      ******** default = abs(x(2)-x(1)) *********
%      ******** 默认值 = abs(x(2)-x(1)) *********
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
    flag=1;
    dx= obj.output.dx;
    noversamp=10;
end

if nargin < 7
    dx= obj.output.dx;
    noversamp=10;
end

if nargin < 8
    noversamp=10;
end

Event=event_polyh(Event,t,x,v,xhyp,zhyp,ahyp,flag,dx,noversamp);

obj.output.Event=Event;

end

