function trout=comb(trin,n,flag)
%COMB ... 创建梳状函数（每隔n个采样点有一个尖峰）
%
%    trout=comb(trin,n,flag)
%    trout=comb(trin,n)
%
% 输出一个梳状函数，每隔n个采样点有一个单位尖峰
%
% trin= 输入道（用于确定输出维度）
% n= 尖峰之间的间隔（采样点数）
%    如果n为负数，尖峰会交替为+1和-1
% flag= 0 ... 第一个单位尖峰位于采样点n/2（*** 默认 ***）
% flag= 1 ... 第一个单位尖峰位于采样点1
% flag= 2 ... 第一个单位尖峰位于采样点n
% trout= 输出的梳状函数

% 参数数量检查，如果少于3个参数，设置默认flag为0
if nargin<3
    flag=0;
end
%
% 初始化输出为与输入相同大小的零数组
trout=zeros(size(trin));
% 计算起始位置：默认为n/2向下取整
m=floor(abs(n/2));
% 如果flag=1，第一个尖峰位于采样点1
if flag==1
    m=1;
end
% 如果flag=2，第一个尖峰位于采样点n
if flag==2
    m=abs(n);
end
% 正间隔情况：所有尖峰都是+1
if n>0
    while m<=length(trin)
        trout(m)=1.0;      % 设置单位尖峰
        m=m+n;             % 移动到下一个尖峰位置
    end
else
% 负间隔情况：尖峰在+1和-1之间交替
    spike=-1.0;            % 初始尖峰值
    while m<=length(trin)
        spike=-1*spike;    % 翻转尖峰符号
        trout(m)=spike;    % 设置交替尖峰
        m=m+abs(n);        % 移动到下一个尖峰位置（使用绝对间隔）
    end
end