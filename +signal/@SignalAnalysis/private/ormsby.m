function [w,t]=ormsby(f1,f2,f3,f4,tlen,dt)
% ORMSBY: 创建 Ormsby 带通滤波器
%
% [w,t]=ormsby(f1,f2,f3,f4,tlen,dt)
%
% 根据四个频率参数创建 Ormsby 子波
% f1 = 低频截止频率
% f2 = 无衰减通过的最低频率
% f3 = 有衰减通过的最高频率
% f4 = 高频截止频率
% tlen = 子波长度（秒）。子波将跨越
%	-tlen/2 到 tlen/2
% dt = 子波采样间隔（秒）

% 检查输入参数的合理性
fnyq=.5/dt;% 奈奎斯特频率
if(any(diff([0,f1,f2,f3,f4,fnyq])<0))
    error('you must have f1<f2<f3<f4<fnyq');
end
if(tlen<dt)
    error('wavelet length, tlen, must be greater than dt');
end

% 创建时间坐标向量
  n=round(tlen/dt)+1;
  nzero=ceil((n+1)/2);% 零时刻采样点在此处
  nr=n-nzero;% nzero右侧的采样点数
  nl=n-nr-1;% nzero左侧的采样点数
  t=dt*(-nl:nr)';

% 构造子波

	w= (pi*f4^2) * (sinque(pi*f4*t)).^2/(f4-f3);
	w= w- (pi*f3^2) * (sinque(pi*f3*t)).^2/(f4-f3);
	w= w- (pi*f2^2) * (sinque(pi*f2*t)).^2/(f2-f1);
	w= w+ (pi*f1^2) * (sinque(pi*f1*t)).^2/(f2-f1);

% 归一化
    w=wavenorm(w,t,2);