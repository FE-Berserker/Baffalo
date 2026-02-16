function obj = EventWavelet(obj,varargin)
% 小波变换
% Author : Xie Yu
%% 解析可选参数
p = inputParser;
addParameter(p, 'WaveType', 'zero'); % zero min
addParameter(p, 'm', 4); % 2~7
addParameter(p, 'tlength', []); % 默认127*dt
addParameter(p, 'fdom', 15); % 主频率 15Hz 
addParameter(p, 'phaserot', 0); % 相位旋转
addParameter(p, 'stab', 0.000001); % 白噪声因子
addParameter(p, 'shift', 0); % 时间偏移

parse(p, varargin{:});
opt = p.Results;

dt=obj.output.dt;
m=opt.m;
fdom=opt.fdom;
stab=opt.stab;
E=obj.output.Event;
t=obj.input.t;

if isempty(opt.tlength)
    tlength=127*dt;
else
    tlength=opt.tlength;
end

switch opt.WaveType
    case 'zero'
        [w, tw] = ricker(dt,fdom,tlength);  % 生成最小相位小波（因果小波）  
    case 'min'
        [w, tw]= wavemin(dt,fdom,tlength,m,stab);  % 生成最小相位小波（因果小波）      
end

w = w/max(w);           % 将最小相位小波归一化到最大值为1

if opt.phaserot~=0
    w=phsrot(w,opt.phaserot);% 对 w 进行相位旋转
end

if opt.shift~=0
    w=stat(w,t,opt.shift); % 对 w 进行时间偏移
end

switch opt.WaveType
    case 'zero'
        E = sectconv(E,t,w,tw);%apply wavelet
    case 'min'
        E = sectconvm(E,t,w,tw);%apply wavelet
end

% 输出
obj.output.Event=E;

end
