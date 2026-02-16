function sg=gainmute(s,t,x,xshot,xmute,tmute,gainpow)
% GAINMUTE ... 对地震数据集应用增益和切除
%
% sg=gainmute(s,t,x,xshot,xmute,tmute,gainpow)
%
% s ... 地震数据集，每列一道。也可以是数据集的单元格数组，
%       的情况下输出也将是类似的单元格数组。
% t ... time coordinate for s, length(t) must equal size(s,1) 
% x ... s 的接收器坐标，length(x) 必须等于 size(s,2)。如果 s 是
%       单元格数组，则不应提供此参数。
% xshot ... s 的锚点坐标。对于单个锚点，这是一个标量；对于
%       s 是单元格数组，这是一个与 s 长度相同的向量。
% xmute ... 指定切除时间的偏移距向量（至少两个值）。
%       切除使用实际源-接收器偏移距的绝对值，
%       因此应为非负数。最简单的
%       meaningfull values would be [0 xoffmax] where xoffmax is the
%       最大源-接收器偏移距。（并不严格需要
%       use the maximum offset as the mute is linearly extrapolated to
%       更大的偏移距。)
% tmute ... 与 xmute 对应的时间向量。在每个偏移距处，
%       早于切除时间的采样点将被置零。未在 xmute 中指定的偏移距的道
%       指定的偏移距的道将通过线性插值获得切除时间，或者如果
%       if the trace offset is larger than max(xmute), the times are
%       通过常数斜率外推计算。注意：size(tmute) 必须等于
%       equal size(xmute).
% 注意... 要关闭所有切除，输入 xmute=0 和 tmute=0。
% gainpow ... 对每道地震记录应用的增益为 t.^gainpow。不使用增益时，
%       增益，使用 gainpow=0。
% ************** default: gainpow=1 ******************

if(nargin<7)
    gainpow=1;  % 设置默认增益指数
end
if(~iscell(s))
    if(length(t)~=size(s,1))
        error('invalid t coordinate vector')
    end
    if(length(x)~=size(s,2))
        error('invalid x coordinate vector')
    end

    if(abs(gainpow)>10 || length(gainpow)>1)
        error('Bad value for gainpow')
    end

    if(size(xmute)~=size(tmute))
        error('xmute and tmute must be the same size')
    end
    
    if(sum(abs(xmute))==0)
        error('xmute cannot be all zero')
    end
    
    if(any(diff(xmute)<0))
        error('xmute must be increasing');
    end
    
    % 计算偏移距
    xoff=abs(x-xshot);
    
    % 插值切除时间
    if(length(xmute)>1)
        tmutex=interpextrap(xmute,tmute,abs(xoff));
    end

    sg=zeros(size(s));
    g=t.^gainpow;
    dt=t(2)-t(1);
    
    for k=1:length(xoff)
        % 应用增益
        if(gainpow~=0)
            tmp=s(:,k).*g;% 简单增益
        else
            tmp=s(:,k);
        end
        % 应用切除
        if(length(xmute)>1)
            imute=min([round(tmutex(k)/dt)+1,length(t)]);
            tmp(1:imute)=0;
        end

        sg(:,k)=tmp;
    end
else
    nshots=length(s);

    if(~iscell(x))
        xx=x;
        x=cell(1,nshots);
        for k=1:nshots
            x{k}=xx;
        end
    end
    if(length(t)~=size(s{1},1))
        error('invalid t coordinate vector')
    end
    if(length(x{1})~=size(s{1},2))
        error('invalid x coordinate vector')
    end

    if(abs(gainpow)>10 || length(gainpow)>1)
        error('Bad value for gainpow')
    end

    if(size(xmute)~=size(tmute))
        error('xmute and tmute must be the same size')
    end
    
    if(length(xshot)~=nshots)
        error('invalid shot coordinate array')
    end

    sg=cell(size(s));
    g=t(:).^gainpow;
    dt=t(2)-t(1);
    
    for kshot=1:nshots
        ss=s{kshot};
        xx=x{kshot};
        ssg=zeros(size(ss));
        if(length(xx)~=size(ss,2))
            error(['x coordinate for shot ' int2str(kshot) ' is incorrect']);
        end
        
        % 此炮的偏移距
        xoff=abs(xx-xshot(kshot));
        
        % 插值切除时间
        if(length(xmute)>1)
            tmutex=interpextrap(xmute,tmute,xoff);
        end
        
        for k=1:length(xoff)
            % 应用增益
            if(gainpow~=0)
                tmp=ss(:,k).*g;%simple gain
            else
                tmp=ss(:,k);
            end
            % 应用切除
            if(length(xmute)>1)
                imute=min([round(tmutex(k)/dt)+1,length(t)]);
                tmp(1:imute)=0;
            end

            ssg(:,k)=tmp;
        end
        sg{kshot}=ssg;
    end
end