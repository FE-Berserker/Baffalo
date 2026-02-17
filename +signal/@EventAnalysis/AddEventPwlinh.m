function obj = AddEventPwlinh(obj,v,xhyp,zhyp,ahyp,flag,dx,noversamp)
% EVENT_PWLINH: diffraction superposition along a piecewise linear track
% EVENT_PWLINH: 沿分段线性轨迹的绕射叠加
%
% amat=event_pwlinh(amat,t,x,v,xhyp,zhyp,ahyp,flag,dx,noversamp)
%
% EVENT_PWLINH constructs the exploding reflector response from a piecewise
% linear structure by superposition of hyperbolae.
% EVENT_PWLINH 通过双曲线叠加构造分段线性结构的爆炸反射器响应。
%
% v ... velocity (scalar)
% xhyp ... vector of x coordinates of piecewise linear structure
% zhyp ... vector of z coordinates of piecewise linear structure
%     ****NOTE: depth and vertical time are related by z=v*t/2 ****
% ahyp ... vector of amplitudes of piecewise linear structure
%      amplitudes on each segment are interpolated from bounding values of ahyp
%    ****NOTE: ahyp, xhyp, and zhyp must all be the same size****
% flag ... if 1, then amplitudes are divided by cos(theta) where theta is the
%		local dip [tan(theta)=diff(zhyp)./diff(xhyp)]
%				otherwise no effect
%      ******** default = 1 *********
% dx ... nominal spacing of hyperbolae. Between each pair of xhyp, hyperbolae
%		will be placed at this horizontal increment if the local dip is zero. For
%		nonzero dip the horizontal spacing is dx*cos(theta). Setting dx to 0 will
%		cause hyperbolae to be placed only at the exact coordinates in (xhyp,zhyp)
%		and not at interpolated locations.
%      ******** default = abs(x(2)-x(1)) ********
% noversamp ... each output trace is created by nearest-neighbor interpolation into
%		a temporary over-sampled trace that is then properly resampled. The greater the
%		oversampling, the better the result.
%      ******** default = 10 *********


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

Event=event_pwlinh(Event,t,x,v,xhyp,zhyp,ahyp,flag,dx,noversamp);

obj.output.Event=Event;

end

