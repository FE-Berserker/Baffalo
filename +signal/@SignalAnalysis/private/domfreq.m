function fdom=domfreq(w,t,p,t1,t2,taperopt)
%DOMFREQ ... 估算信号的主频
%
% fdom=domfreq(w,t,p,t1,t2,taperopt);
%
% 如果W是输入信号的傅里叶变换，则主频
% 可通过质心法估算
% fdom=Int(f*abs(W).^p)/Int(abs(W).^p)
% 其中f为频率，Int为对频率的积分，p为
% 通常取2。
%
% w ... 输入信号（可以是子波或道集。如果是道集，则
%       每一列应为一道，返回的fdom将
%       对每道有一个值。）
% t ... w的时间坐标
% p ... 小整数
% **********默认p=2 ********
% t1 ... 估计窗口的起始时间
% ********** 默认 t(1) ***********
% t2 ... 估计窗口的结束时间
% ********** 默认 t(end) ************
% 如果w是道集，则t1和t2应各为单个标量或
% 每道一个值。
% ********** t1和t2的默认值为整道 *******
% taperopt ... 0  表示使用矩形窗
%              1  表示使用半窗，仅在末端进行锥化
%              2  表示使用两端锥化的窗
% ********** 默认 = 0 ***********
%
% fdom ... w的主频


if(nargin<3)
    p=2;
end
if(nargin<4)
    t1=t(1);
end
if(nargin<5)
    t2=t(end);
end
if(nargin<6)
    taperopt=0;
end

if(sum(abs(w))==0)
    error('输入信号全为零')
end
[nt,ntraces]=size(w);
if(nt==1)
    ntraces=1;%处理行向量输入的情况
    nt=length(w);
    w=w';
end
if(ntraces>1)
    if(isscalar(t1))
        t1=t1*ones(1,ntraces);
        t2=t2*ones(1,ntraces);
    else
        if(length(t1)~=ntraces)
            error('t1的长度必须等于道数');
        end
        if(length(t2)~=ntraces)
            error('t2的长度必须等于道数');
        end
    end
end
fdom=zeros(1,ntraces);
for k=1:ntraces
    tmp=w(:,k);
    ind=near(t,t1(k),t2(k));
    if(taperopt==0)
        win=ones(length(ind),1);
    elseif(taperopt==1)
        win=mwhalf(length(ind),10);
    elseif(taperopt==2)
        win=mwindow(length(ind),10);
    else
        error('无效的taperopt');
    end
    [W,f]=fftrl(tmp(ind).*win,t(ind));
    fdom(k)=sum(f.*abs(W).^p)/sum(abs(W).^p);
end

% [W,f]=fftrl(w,t);
% if(ntraces==1)
%     fdom=sum(f.*abs(W).^p)/sum(abs(W).^p);
% else
%     ff=f*ones(1,ntraces);
%     fdom=sum(ff.*abs(W).^p)./sum(abs(W).^p);
% end