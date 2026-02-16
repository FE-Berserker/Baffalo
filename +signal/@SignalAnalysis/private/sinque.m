function s=sinque(x)
% SINQUE: sinc 函数求值
%
% s=sinque(x)
% 计算 sin(x)/x
%
% x= 输入参数向量
% s= sin(x)/x 的值向量

s=zeros(size(x));
ii=find(abs(x)<=eps);
s(ii)= ones(1,length(ii));
ii= find(s~=1.0);
s(ii)=sin(x(ii))./x(ii);