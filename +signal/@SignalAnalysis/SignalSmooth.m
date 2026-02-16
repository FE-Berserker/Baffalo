function obj = SignalSmooth(obj,varargin)
% 信号平滑
% Author : Xie Yu
p = inputParser;
addParameter(p, 'method', 'wavelet'); % wavelet 小波 bandpass 带通 butterband 巴特沃斯
addParameter(p, 'tsmo', []); % 平滑窗长度
addParameter(p, 'window', 'gauss'); % box tri gauss
addParameter(p, 'fmin', []); % 
addParameter(p, 'fmax', []); % 
addParameter(p, 'phase', 0); % 0 零相位滤波器 1 最小相位滤波器
addParameter(p, 'max_atten', 80); % 最大分贝
addParameter(p, 'n', 4); % 巴特沃斯滤波器阶数
parse(p, varargin{:});
opt = p.Results;

switch opt.method
    case 'wavelet'
        obj=WaveletSmooth(obj,opt);
    case 'bandpass'
        obj=BandpassSmooth(obj,opt);
    case 'butterband'
        obj=ButterpassSmooth(obj,opt);
end

end

function obj=WaveletSmooth(obj,opt)
%% 平滑处理参数
dt=obj.output.dt;
sn=obj.input.s;

if isempty(opt.tsmo)
    tsmo=128*dt;% 平滑窗长度 [s]
else
    tsmo=opt.tsmo;
end

nsmo=round(tsmo/dt);% 平滑窗样点数

switch opt.window
    case 'box'
        %% 方法1：矩形窗（Boxcar）平滑
        box=ones(1,nsmo);% 创建矩形窗（全1向量）
        s=convz(sn,box/nsmo);% 卷积并归一化

    case 'tri'
        %% 方法2：三角窗（Triangular）平滑
        box=ones(1,nsmo);% 创建矩形窗（全1向量）
        triang=conv(box,box);% 两个矩形窗卷积得到三角窗
        s=convz(sn,triang/sum(triang));% 卷积并归一化

    case 'gauss'
        tsmog=2*tsmo;% 高斯窗长度是矩形窗的2倍
        sigma=tsmog/4;% 高斯函数标准差
        tg=-tsmog/2:dt:tsmog/2;% 高斯窗时间向量（以0为中心）
        g=exp(-(tg/sigma).^2);% 高斯函数
        g=g/sum(g);% 归一化高斯窗
        s=convz(sn,g);% 卷积平滑
end

Range=obj.params.Range;
if ~isempty(Range)
    t1=Range(1);
    t2=Range(2);
    ind=near(obj.input.t,t1,t2);
    s=s(ind);
end

obj.output.s_Transform=s;
end

function obj=BandpassSmooth(obj,opt)

t=obj.input.t;
sn=obj.input.s;
fmin=opt.fmin;
fmax=opt.fmax;
phase=opt.phase;
max_atten=opt.max_atten;

s=filtf(sn,t,fmin,fmax,phase,max_atten);

Range=obj.params.Range;
if ~isempty(Range)
    t1=Range(1);
    t2=Range(2);
    ind=near(obj.input.t,t1,t2);
    s=s(ind);
end

obj.output.s_Transform=s;

end

function obj=ButterpassSmooth(obj,opt)

t=obj.input.t;
sn=obj.input.s;
fmin=opt.fmin;
fmax=opt.fmax;
phase=opt.phase;
n=opt.n;

s=butterband(sn,t,fmin(1),fmax(1),n,phase);% 零相位巴特沃斯带通滤波器

Range=obj.params.Range;
if ~isempty(Range)
    t1=Range(1);
    t2=Range(2);
    ind=near(obj.input.t,t1,t2);
    s=s(ind);
end

obj.output.s_Transform=s;

end
