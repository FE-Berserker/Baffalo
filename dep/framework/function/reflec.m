function [r,t]=reflec(tmax,dt,amp,m,n)
% REFLEC: synthetic pseudo random reflectivity
% REFLEC: 合成伪随机反射系数
%
% [r,t]=reflec(tmax,dt,amp,m,n)
% [r,t]=reflec(tmax,dt,amp,m)
% [r,t]=reflec(tmax,dt,amp)
% [r,t]=reflec(tmax,dt)
%
% REFLEC creates a psuedo random reflectivity by first
% generating a Gaussian random noise sequence and then raising
% each element in the sequence to a small integral power. This
% has the effect of making the sequence more spiky.
% REFLEC 通过首先生成高斯随机噪声序列，然后将序列中的每个元素
% 提升到一个小的整数次幂来创建伪随机反射系数。这样做的效果是
% 使序列更加"尖刺"（稀疏）。
%
% tmax = record length
%        记录长度
% dt= sample rate
%    采样率
% amp= maximum rc;
% ************* default=.2 *******************
%     最大反射系数
%     ************* 默认值=.2 *******************
% m= exponentiation power to which gaussian distribution
%    is raised; Should be an odd power to preserve the sign
%    of the sample.
% ***************** default= 3 ***********************
%    高斯分布提升到的次幂；应为奇次幂以保持样本的符号
%    ***************** 默认值=3 ***********************
% n= random number seed;
% ************* defaults to a random number based on the
%                system clock  ***********
%    随机数种子
%    ************* 默认为基于系统时钟的随机数 ***********

if(nargin<3)
  amp=.2;              % 默认最大反射系数
 end
if(nargin<4)
 m=3;                  % 默认奇次幂
end
if(nargin<5)
  c=clock;             % 获取系统时钟
  n=c(6);              % 使用秒数作为种子
end
m=round(m);            % 取整
t=(0.:dt:tmax)';       % 生成时间向量
% matlab random number generator screws up with a negative seed
% matlab 随机数生成器在使用负种子时会出错
%randn('seed',abs(n))
rng('default');        % 重置随机数生成器
rng(abs(n));           % 设置随机数种子
if(floor(m/2)*2==m)    % 判断是否为偶次幂
    tmp=randn(size(t));
    r=(tmp.^m).*sign(tmp);  % 偶次幂时保持符号
else
    r=randn(size(t)).^m;    % 奇次幂直接计算
end
r=amp*r/max(abs(r));   % 归一化到最大振幅