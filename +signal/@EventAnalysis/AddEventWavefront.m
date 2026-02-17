function obj = AddEventWavefront(obj,tnot,xnot,v,amp,aper)
% EVENT_WAVEFRONT: inserts a wavefront (circle) event in a matrix
% EVENT_WAVEFRONT: 在矩阵中插入一个波前圆事件
%
% obj = AddEventWavefront(obj,tnot,xnot,v,amp,aper)
%
% EVENT_WAVEFRONT inserts a wavefront circle event in a matrix. This is
% done in the time domain so that the reciprocal nature of diffraction
% hyperbolae and wavefront circles can be easily demonstrated.
% EVENT_WAVEFRONT 在矩阵中插入一个波前圆事件。这是在时间域中完成的，
% 以便可以容易地演示双曲线绕射和波前圆的互易性质。
%
% tnot ... t coordinate of the wavefront nadir (lowest point)
% tnot ... 波前最低点的时间坐标。
% xnot ... x coordinate of the wavefront nadir (lowest point)
% xnot ... 波前最低点的空间坐标。
% v ... velocity of wavefront. Value is divided by two to simulate post stack.
% v ... 波前速度。该值除以2以模拟叠加后数据。
% amp ... amplitude of the wavefront
% amp ... 波前振幅。
% aper ... truncate wavefront beyond this aperture
% aper ... 在此孔径外截断波前。
%      ******** default is no truncation ********
%      ******** 默认值：无截断 ********

t=obj.input.t;
x=obj.input.x;
Event=obj.output.Event;

if nargin < 6
    aper = inf;
end

Event=event_wavefront(Event,t,x,tnot,xnot,v,amp,aper);

obj.output.Event=Event;

end

