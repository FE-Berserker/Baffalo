function obj = EventFilter(obj,varargin)
% 信号平滑
% Author : Xie Yu
p = inputParser;
addParameter(p, 'method', 'bandpass'); % bandpass 带通 butterband 巴特沃斯 fkfan fk扇形滤波
addParameter(p, 'fmin', []); % 
addParameter(p, 'fmax', []); % 
addParameter(p, 'phase', 0); % 0 零相位滤波器 1 最小相位滤波器
addParameter(p, 'max_atten', 80); % 最大分贝 
addParameter(p, 'n', 4); % 巴特沃斯滤波器阶数
addParameter(p, 'va1', []); % va1 定义抑制扇形的最小视速度。输入 0 表示抑制比 va2 慢的所有内容
addParameter(p, 'va2', []); % va2 定义抑制扇形的最大视速度
addParameter(p, 'dv', []); % dv  抑制扇形边缘锥形的宽度，单位为速度
addParameter(p, 'fkfanflag', 0);% fkfanflag ... -1 ... 仅抑制负视速度
%           0 ... 抑制正视速度和负视速度（默认）
%           1 ... 仅抑制正视速度
addParameter(p, 'xpad', []); % 附加到 event 的空间零填充大小（x 单位）
addParameter(p, 'tpad', []); % 附加到 event 的时间零填充大小（x 单位）
addParameter(p, 'izero', 1); % 1 表示将滤波前为零的任何内容重新置零，0 表示不

parse(p, varargin{:});
opt = p.Results;

switch opt.method
    case 'bandpass'
        obj=BandpassSmooth(obj,opt);
    case 'butterband'
        obj=ButterpassSmooth(obj,opt);
    case 'fkfan'
        obj=fkfanSmooth(obj,opt);

end

end

function obj=BandpassSmooth(obj,opt)

t=obj.input.t;
sn=obj.output.Event;
fmin=opt.fmin;
fmax=opt.fmax;
phase=opt.phase;
max_atten=opt.max_atten;

s=filtf(sn,t,fmin,fmax,phase,max_atten);

obj.output.Event=s;

end

function obj=ButterpassSmooth(obj,opt)

t=obj.input.t;
sn=obj.output.Event;
fmin=opt.fmin;
fmax=opt.fmax;
phase=opt.phase;
n=opt.n;

s=butterband(sn,t,fmin(1),fmax(1),n,phase);% 零相位巴特沃斯带通滤波器

obj.output.Event=s;

end

function obj=fkfanSmooth(obj,opt)

t=obj.input.t;
x=obj.input.x;
sn=obj.output.Event;
va1=opt.va1;
va2=opt.va2;
dv=opt.dv;
flag=opt.fkfanflag;
xpad=opt.xpad;
tpad=opt.tpad;
izero=opt.izero;

if isempty(xpad)
    xpad=0.1*(max(x)-min(x));
end

if isempty(tpad)
    tpad=0.1*(max(t)-min(t));
end


[s,~,~,~]=fkfanfilter(sn,t,x,va1,va2,dv,flag,xpad,tpad,izero);

obj.output.Event=s;

end