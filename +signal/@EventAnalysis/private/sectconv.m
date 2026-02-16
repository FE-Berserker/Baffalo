function sect = sectconv(sect,t,w,tw,flag)
% SECTCONV: convolves a wavelet with a seismic section
% SECTCONV: 子波与地震剖面的褶积
%
% sectout = sectconv(sectin,t,w,tw)
%
% SECTCONV convolves a wavelet with a seismic section.
% SECTCONV 将子波与地震剖面进行褶积。
%
% sectin ... input section of size nsamp x ntr. That is one trace per
%	column.
% sectin ... 输入剖面，尺寸为 nsamp x ntr（采样点数 x 道数），每列代表一道。
% t ... nsamp long time coordinate vector for sectin
% t ... 输入剖面的时间坐标向量，长度为 nsamp。
% w ... wavlet to be convolved with section
% w ... 与剖面进行褶积的子波。
% tw ... time coordinate vector for wavelet. Abort will occur if wavelet
%	and sectin have different time sample rates.
% tw ... 子波的时间坐标向量。如果子波与剖面的采样率不同，程序将终止。
% sectout ... output section of size nsamp x ntr.
% sectout ... 输出剖面，尺寸为 nsamp x ntr。

if nargin<5
    flag=0;
end


[~,ntr]=size(sect); % 获取输入剖面尺寸：nsamp=采样点数, ntr=道数

% 计算时间采样间隔
dt=t(2)-t(1);     % 剖面时间采样间隔
dtw=tw(2)-tw(1);  % 子波时间采样间隔
small = 1.e06*eps; % 容差阈值
if( abs( dt-dtw ) > small )
	error(' wavelet and section must have same sample rates '); % 报错：子波和剖面必须具有相同的采样率
end
nz=near(tw,0.); % 找到子波中零时间点附近的采样索引
if(abs(tw(nz)) > small)
	disp('WARNING from sectconv: Wavelet has no sample at time zero'); % 警告：子波在零时间处无采样点
end

% 对每一道进行褶积处理
switch flag
    case 0
        for k=1:ntr
            sect(:,k) = convz( sect(:,k),w,nz); % 调用convz函数进行褶积，输入剖面、子波和零点索引
        end
    case 1
        for k=1:ntr
            sect(:,k) = convm( sect(:,k),w,nz); % 调用convz函数进行褶积，输入剖面、子波和零点索引
        end
end