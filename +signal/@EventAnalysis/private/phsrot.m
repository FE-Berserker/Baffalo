function trout=phsrot(trin,theta)
% PHSROT Constant-phase rotate a trace
% PHSROT 恒定相位旋转轨迹
%
% trout=phsrot(trin,theta)
%
% PHSROT performs a constant phase rotation of the input trace
% through an angle of theta degrees.
% PHSROT 对输入轨迹进行恒定相位旋转，旋转角度为 theta 度
%
% trin= input trace or trace gather
%       输入轨迹或轨迹道集
% theta= phase rotation angle in degrees
%        相位旋转角度（度）
% trout= phase rotated trace
%        相位旋转后的轨迹

%test for section input
% 测试是否为剖面输入（多个轨迹）

[nsamps,ntraces]=size(trin);

if((nsamps-1)*(ntraces-1)==0)
    %single trace
    % 单条轨迹
    trout=rot(trin(:),theta);
    if(nsamps==1); trout=trout';end
else
    %multi trace
    % 多条轨迹
    trout=zeros(size(trin));
    for k=1:ntraces
        trout(:,k)=rot(trin(:,k),theta);
    end
end

end

function trrot=rot(tr,theta)

    nt=length(tr);                 % 轨迹长度
    nt2=2^nextpow2(nt);            % 下一个2的幂次（用于FFT）
    Tr=fft(tr,nt2);                % 傅里叶变换
    sgn=[ones(nt2/2,1);-ones(nt2/2,1)];  % 符号向量（正负频率）
    trh=real(ifft(Tr.*-1i.*sgn));  % 希尔伯特变换
    %rotate
    % 旋转
    trrot=cos(theta*pi/180)*tr-sin(theta*pi/180)*trh(1:nt);
end