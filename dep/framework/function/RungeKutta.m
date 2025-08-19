function [y,K]=RungeKutta(dfun,x0,y0,h,a,b,type)
%此方程为龙格库塔法，dfun为导函数，x0，y0为初始值
%h为迭代的步长，a、b代表区间的下限和上限
%type表示方式，默认为2，表示二级2阶龙格库塔法，type=4表示经典四级的龙格库塔法
if nargin<7
    type=2;
end
switch type
    case 2
        c2=1;%此处可根据需要自由调整c2的值，默认为1，即改进的Euler法
        [y,K]=RK2(dfun,x0,y0,h,a,b,c2);
    case 4
        [y,K]=RK4(dfun,x0,y0,h,a,b);%此处为经典的四阶龙格库塔法
end
end
function [y,K]=RK2(dfun,x0,y0,h,a,b,c2)
b2=1/2/c2;a21=c2;b1=1-b2;
N=floor(b-a)/h;
K=NaN(N+1,3);y=NaN(N+1,3);K(1,1)=0;
y(1,1)=0;y(1,2)=x0;y(1,3)=y0;
for i=1:N
    K(i+1,1)=i;y(i+1,1)=i;
    K(i+1,2)=feval(dfun,y(i,2),y(i,3));
    K(i+1,3)=feval(dfun,y(i,2)+c2*h,y(i,3)+h*a21*K(i+1,2));
    y(i+1,2)=x0+i*h;
    y(i+1,3)=y(i,3)+h*b1*K(i+1,2)+h*b2*K(i+1,3);
end
end

function [y,K]=RK4(dfun,x0,y0,h,a,b)
B=[1/6;1/3;1/3;1/6];
N=floor((b-a)/h);
K=NaN(N+1,5);y=NaN(N+1,3);K(1,1)=0;
y(1,1)=0;y(1,2)=x0;y(1,3)=y0;
for i=1:N
    K(i+1,1)=i;y(i+1,1)=i;
    K(i+1,2)=feval(dfun,y(i,2),y(i,3));
    K(i+1,3)=feval(dfun,y(i,2)+h/2,y(i,3)+h/2*K(i+1,2));
    K(i+1,4)=feval(dfun,y(i,2)+h/2,y(i,3)+h/2*K(i+1,3));
    K(i+1,5)=feval(dfun,y(i,2)+h,y(i,3)+h*K(i+1,4));
    y(i+1,2)=x0+i*h;
    y(i+1,3)=y(i,3)+h*K(i+1,2:5)*B;
end
end
    
    
    

