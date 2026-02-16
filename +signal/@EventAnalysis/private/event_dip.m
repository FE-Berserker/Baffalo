function amat=event_dip(amat,t,x,tlims,xlims,amp)
% EVENT_DIP: 在矩阵中插入倾斜（线性）事件
%
% amat=event_dip(amat,t,x,tlims,xlims,amp)
%
% EVENT_DIP: Inserts a dipping (linear) event in a matrix.
%
% 输入参数:
% amat ... 大小为 nrows x ncols 的矩阵（地震数据）
% t ... 长度为 nrows 的向量，给出矩阵的 t 坐标（时间/深度）
% x ... 长度为 ncols 的向量，给出矩阵的 x 坐标（空间位置）
% tlims ... 长度为 2 的向量，给出事件的 t 坐标范围 [t_start, t_end]
% xlims ... 长度为 2 的向量，给出事件的 x 坐标范围 [x_start, x_end]
% amp ... 长度为 2 的向量，给出事件两端的振幅值
%       中间振幅通过 x 插值获得
%   *************** 默认值为 [1 1] *****************
%
% 输出参数:
% amat ... 添加了倾斜事件后的矩阵
%
% 功能说明:
% 该函数在指定的 x 和 t 范围内生成一条线性倾斜的同相轴，
% 振幅可以在线性插值下变化。事件使用 Ricker 小波进行建模。
%
% 注意: tlims 和 xlims 定义了倾斜事件的两端点坐标

if(nargin<6)
    amp=[1 1]; % 如果未提供振幅参数，使用默认值 [1 1]
end

% 遍历列（道）：找到 xlims 范围内的 x 坐标索引
nc= between(xlims(1),xlims(2),x,2);

% 创建单位脉冲（spike）用于生成小波
spike=zeros(length(t),1);
spike(1)=1; % 在第一个时间点设置单位脉冲

if(isscalar(amp)) 
    amp=[amp amp]; 
end % 如果只提供一个振幅值，扩展为两个相同的值

if(nc~=0) % 如果有 x 坐标落在指定范围内
	tmin=t(1); % 时间范围起点
	tmax=t(length(t)); % 时间范围终点
	% dt=t(2)-t(1); % 时间采样间隔
	for k=nc % 遍历每一列（道）
		tk = interpextrap(xlims,tlims,x(k)); % 插值计算当前 x 处对应的 t 坐标
		a = interpextrap(xlims,amp,x(k)); % 插值计算当前 x 处对应的振幅
		if( between(tmin,tmax,tk) ) % 如果计算出的 t 在有效范围内
			amat(:,k)=amat(:,k) + a*stat(spike,t,tk-tmin); % 添加带振幅的小波到该列
		end
	end
end