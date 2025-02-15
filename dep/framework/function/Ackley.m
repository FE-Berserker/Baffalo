function y=Ackley(x,c1)
%Ackley?函数??
%输入x,给出相应的y值,在x=(0,0,…,0)?处有全局极小点0,为得到最大值，返回值取相反数??
if nargin<2
c1=20;
end
[row,col]=size(x);
if row>1
    error('输入的参数错误');
end
y=-c1*exp(-0.2*sqrt((1/col)*(sum(x.^2))))-exp((1/col)*sum(cos(2*pi.*x)))+exp(1)+c1;
end