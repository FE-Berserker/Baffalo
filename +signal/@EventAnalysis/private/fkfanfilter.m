function [seisf,mask,f,kx]=fkfanfilter(seis,t,x,va1,va2,dv,flag,xpad,tpad,izero)
%FKFANFILTER ... 对地震剖面或记录进行 f-k 扇形滤波
%
% [seisf,mask,f,kx]=fkfanfilter(seis,t,x,va1,va2,dv,flag,xpad,tpad,izero)
%
% FKFANFILTER 设计并应用 f-k（频率-波数）扇形抑制滤波器。
% 抑制区域为扇形，由两个边界视速度 va1 和 va2 定义。
% 这些速度以正数表示，可以选择抑制正负视速度或仅抑制其中一个。
% 滤波器边缘使用升余弦锥形。滤波器被构造为一个掩膜（mask），
% 这是一个与数据的 f-k 频谱大小相同的乘法算子，其值在 0 到 1 之间。
% 通过返回所有四个值可以检查此掩膜，然后绘制它。
%
% seis ... 要滤波的地震剖面或记录。每列一条地震道
% t ... seis 的时间坐标向量
% x ... seis 的空间坐标向量
% 要求：size(seis,1) 必须等于 length(t)，size(seis,2) 必须等于 length(x)
% va1 ... 定义抑制扇形的最小视速度。输入 0 表示抑制比 va2 慢的所有内容
% va2 ... 定义抑制扇形的最大视速度
% 要求：va2>va1，两个值都不能为负数
% dv  ... 抑制扇形边缘锥形的宽度，单位为速度
% 要求：0<dv<va1<=va2。设置 va1=va2 会给出非常窄的抑制区域。
%       要更好地抑制特定速度 vn，应使 va1 略小于 vn，va2 略大于 vn
%
% flag ... -1 ... 仅抑制负视速度
%           0 ... 抑制正视速度和负视速度（默认）
%           1 ... 仅抑制正视速度
% ********* 默认 flag=0 *********
% xpad ... 附加到 seis 的空间零填充大小（x 单位）
% ********* 默认 = 0.1*(max(x)-min(x))***********
% tpad ... 附加到 seis 的时间零填充大小（t 单位）
% ********* 默认 = 0.1*(max(t)-min(t)) **********
% izero ... 1 表示将滤波前为零的任何内容重新置零，0 表示不
% ********* 默认 = 1 *********************
%
% 注意：提供的 xpad 和 tpad 值是最小填充，因为在附加这些填充后，
% 矩阵会在两个维度上进一步扩展到下一个 2 的幂次。
%
% seisf ... 去除所有填充的 f-k 滤波结果。它将与 seis 大小相同
% mask ... f-k 滤波器乘数。如果 seisfk 是填充输入的 f-k 变换，
%       则 f-k 滤波器应用为 seisfk.*mask
% f ... 掩膜的频率坐标
% kx ... 掩膜的波数坐标

% ========== 参数默认值设置 ==========
if(nargin<10)
    izero=1;  % 默认重新置零
end
if(nargin<9)
    tpad=0.1*(max(t)-min(t));  % 默认时间填充为长度的10%
end
if(nargin<8)
    xpad=0.1*(max(x)-min(x));  % 默认空间填充为长度的10%
end
if(nargin<7)
    flag=0;  % 默认抑制正负视速度
end
[nt,nx]=size(seis);  % 获取地震数据的大小
% ========== 输入验证（已注释） ==========
% if(~isdeployed)
%     if(length(t)~=nt)
%         error('seis and t have incompatible sizes')
%     end
%     if(length(x)~=nx)
%         error('seis and x have incompatible sizes')
%     end
%     if(dv<=0 || va1<0 || va2<=0)
%         error('dv, va1,va2 must not be negative')
%     end
%     if(va1>va2)
%         error('va1 must be less than va2')
%     end
%     % if(dv>va1)
%     %     error('dv must be less than va1')
%     % end
%     small=1000000 *eps;
%     test=sum(abs(diff(diff(x))))/(length(x)*abs(x(1)-x(end)));%平均不规则性
%     if(test>.5)
%         error('x coordinates must be regularly spaced')
%     end
%     if(sum(abs(diff(diff(t))))>small)
%         error('t coordinates must be regularly spaced')
%     end
% else
    errmsg='';
    test=sum(abs(diff(diff(x))))/(length(x)*abs(x(1)-x(end)));%平均不规则性
    if(test>.05)
        errmsg='x coordinate is too irregular';
    end
    if(~isempty(errmsg))
        seisf=errmsg;
        return;
    end
% end

% ========== 记录零值位置 ==========
if(izero==1)
    jzero=seis==0;  % 标记原始数据中的零值位置
end
dx=x(2)-x(1);  % 空间采样间隔
dt=t(2)-t(1);  % 时间采样间隔

% ========== 如果 x 递减则翻转矩阵 ==========
if(dx<0)
    seis=fliplr(seis);
    x=fliplr(x);
end

% ========== 附加空间填充 ==========
nx2=nx;
if(xpad>0)
    nxpad=round(xpad/abs(dx));  % 计算填充的采样点数
    seis=[seis zeros(nt,nxpad)];  % 在右侧添加零填充
    nx2=nx+nxpad;  % 更新空间维度
    x=(0:nx2-1)*abs(dx);  % 更新 x 坐标
%     if(dx>0)
%         x=(0:nx2-1)*dx;
%     else
%         x=(nx2-1:-1:0)*abs(dx);
%     end
end

% ========== 附加时间填充 ==========
% nt2=nt;
if(tpad>0)
    ntpad=round(tpad/dt);  % 计算填充的采样点数
    nt2=nt+ntpad;  % 更新时间维度
    t=(0:nt2-1)*dt;  % 更新 t 坐标
    seis=[seis;zeros(ntpad,nx2)];  % 在底部添加零填充
end

% ========== f-k 变换 ==========
[seisfk,f,kx]=fktran(seis,t,x);  % 前向 f-k 变换

% ========== 设计滤波器掩膜 ==========
mask=ones(size(seisfk));  % 初始化掩膜为全1
kmin=3;  % 抑制区域的最小宽度（采样点数）
va1dv=va1-dv;  % 低端锥形开始位置
va2dv=va2+dv;  % 高端锥形结束位置
dk=kx(2)-kx(1);  % 波数间隔
k0=kx(1);  % 第一个波数样本
nk2=length(kx);  % 波数样本数

% ========== 对每个频率构建扇形掩膜 ==========
for k=1:length(f)
% for k=62
    % 抑制区域：从 kr1 到 kr2 完全抑制
    kr1=f(k)/va1;  % 低端抑制边界
    kr2=f(k)/va2;  % 高端抑制边界

    % 锥形区域
    kr0=f(k)/va1dv;  % 从 kr0 到 kr1 的锥形
    kr3=f(k)/va2dv;  % 从 kr2 到 kr3 的锥形
    % 注意：kr0<kr1<kr2<kr3

    % ========== 负视速度抑制 ==========
    if(flag==0 || flag==-1)
        % 负视速度
        ik0=(-kr0-k0)/dk+1;  % 锥形开始索引
        ik1=(-kr1-k0)/dk+1;  % 完全抑制开始索引
        if(ik1-ik0<kmin)
            ik0=ik1-kmin;  % 确保第一个边缘至少有 kmin 个样本
        end
        ik2=(-kr2-k0)/dk+1;  % 完全抑制结束索引
        ik3=(-kr3-k0)/dk+1;  % 锥形结束索引
        if(ik3-ik2<kmin)
            ik3=ik2+kmin;  % 确保第二个边缘至少有 kmin 个样本
        end

        jk1=max([round(ik1) 1]);
        jk2=round(ik2);
        if(round(ik3)>0)
            mask(k,jk1:jk2)=0;  % 完全抑制区域
            jk0=max([round(ik0) 1]);
            % 第一个锥形（升余弦）
            if(ik1>0)
                mask(k,jk0:jk1)=(.5+.5*cos(pi*((jk0:jk1)-ik0)/(ik1-ik0))).*mask(k,jk0:jk1);
            end
            jk3=round(ik3);
            % 第二个锥形
            jk2=max([jk2 1]);
            mask(k,jk2:jk3)=(.5+.5*cos(-pi*((jk2:jk3)-ik3)/(ik2-ik3))).*mask(k,jk2:jk3);
        end
    end

    % ========== 正视速度抑制 ==========
    if(flag==0 || flag==1)
        % 正视速度
        ik0=(kr0-k0)/dk+1;  % 锥形结束索引
        ik1=(kr1-k0)/dk+1;  % 完全抑制结束索引
        if(ik0-ik1<kmin)
            ik0=ik1+kmin;  % 确保最终锥形至少有 kmin 个样本
        end
        ik2=(kr2-k0)/dk+1;  % 完全抑制开始索引
        ik3=(kr3-k0)/dk+1;  % 锥形开始索引
        if(ik2-ik3<kmin)
            ik3=ik2-kmin;
        end

        jk1=min([round(ik1) nk2]);
        jk2=round(ik2);
        if(round(ik3)<=nk2)
            mask(k,jk2:jk1)=0;  % 完全抑制区域
            jk0=min([round(ik0) nk2]);
            if(ik1<nk2)
                mask(k,jk1:jk0)=(.5+.5*cos(pi*((jk1:jk0)-ik0)/(ik1-ik0))).*mask(k,jk1:jk0);
            end
            jk3=round(ik3);
            jk2=min([jk2 nk2]);
            mask(k,jk3:jk2)=(.5+.5*cos(-pi*((jk3:jk2)-ik3)/(ik2-ik3))).*mask(k,jk3:jk2);
        end
    end
end

% ========== 应用掩膜 ==========
seisfk=seisfk.*mask;  % 将掩膜与 f-k 频谱相乘

% ========== 逆变换 ==========
seisf=ifktran(seisfk,f,kx);  % 逆 f-k 变换

% ========== 移除填充 ==========
if(size(seisf,1)>nt)
    seisf=seisf(1:nt,:);  % 移除时间填充
end
if(size(seisf,2)>nx)
    seisf=seisf(:,1:nx);  % 移除空间填充
end

% ========== 重新置零 ==========
if(izero==1)
    seisf(jzero)=0;  % 将原始零值位置重新置零
end

% ========== 如果 x 原本递减则翻转回来 ==========
if(dx<0)
    seisf=fliplr(seisf);
end
    