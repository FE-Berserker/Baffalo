function obj = AddEventDiffSection(obj,dx,dt,xmax,zmax,v0,c,fmin,fmax,ieveryt,ieveryx)
% DIFFRACTION_SECTION: make a section full of diffractions on a regular grid
% DIFFRACTION_SECTION: 在规则网格上制作完整的绕射剖面
%
% obj = AddEventDiffSection(obj,dx,dt,xmax,zmax,v0,c,fmin,fmax,ieveryt,ieveryx)
%
% DIFFRACTION_SECTION creates a modelled diffraction section with diffractors
% placed on a regular grid.
% DIFFRACTION_SECTION 创建一个绕射剖面，在规则网格上放置绕射点。
%
% dx ... spatial grid size (in both x and z)
% dx ... 空间网格尺寸（x 和 z 方向）。
%      ******** default = 10 *********
%      ******** 默认值 = 10 *********
% dt ... time sample size
% dt ... 时间采样间隔。
%      ******** default = .002 *********
%      ******** 默认值 = .002 *********
% xmax ... maximum lateral spatial coordinate
% xmax ... 最大横向空间坐标。
%      ******** default = 2000 *********
%      ******** 默认值 = 2000 *********
% zmax ... maximum depth
% zmax ... 最大深度。
%      ******** default = 2000 *********
%      ******** 默认值 = 2000 *********
% v0 ... velocity at z=0
% v0 ... z=0 处的速度。
%      ******** default = 1800 *********
%      ******** 默认值 = 1800 *********
% c ... vertical velocity gradient
% c ... 垂直速度梯度。
%      Note: velocity function is v=v0+c*z. Set c=0 for constant velocity
%      注意：速度函数为 v=v0+c*z。设置 c=0 可获得恒定速度。
%      ******** default = 0.6 *********
%      ******** 默认值 = 0.6 *********
% fmin ... low frequency of pass band
% fmin ... 通带低频。
%      ******** default = 10 *********
%      ******** 默认值 = 10 *********
% fmax ... high frequency of passband
% fmax ... 通带高频。
%      ******** default = .4*fnyq *********
%      ******** 默认值 = .4*fnyq *********
% ieveryt ... place a diffractor every this many time samples
% ieveryt ... 每隔这么多时间样本放置一个绕射点。
%      ******** default = 50 *********
%      ******** 默认值 = 50 *********
% ieveryx ... place a diffractor every this many x samples
% ieveryx ... 每隔这么多 x 样本放置一个绕射点。
%      ******** default = 20 *********
%      ******** 默认值 = 20 *********
%
% Output:
% seis ... modelled diffraction section
% t ... time coordinate for seis
% x ... x coordinate for seis
% v ... instantaneous velocity as a function of time
% seis ... 建模的绕射剖面
% t ... seis 的时间坐标
% x ... seis 的 x 坐标
% v ... 作为时间函数的瞬时速度

t=obj.input.t;
x=obj.input.x;
Event=obj.output.Event;

if nargin < 2
    dt=.002;
end

if nargin < 3
    xmax=2000;
end

if nargin < 4
    zmax=2000;
end

if nargin < 5
    v0=1800;
end

if nargin < 6
    c=.6;
end

if nargin < 7
    fmin=10;
end

fnyq=.5/dt;
if nargin < 8
   fmax=.4*fnyq;
end

if nargin < 9
    ieveryt=50;
end

if nargin < 10
    ieveryx=20;
end

% Create the diffraction section
[seis,new_t,new_x,v]=diffraction_section(dx,dt,xmax,zmax,v0,c,fmin,fmax,ieveryt,ieveryx);

% Update input structure with new coordinates
obj.input.t = new_t;
obj.input.x = new_x;

% Update Event with the new section
Event = seis;
obj.output.Event = Event;

end

