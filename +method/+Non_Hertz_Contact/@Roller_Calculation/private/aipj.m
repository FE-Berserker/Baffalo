function [a,P,Q1]=aipj(delta,y,Dw,Eeqv,x,L)

%% 初始化计算
n=size(y,1);
h=L/2/n;% h为切片的厚度的一半
S=delta-y;%计算向量
S=S.*(S>0)+0.*(S<=0);
a=sqrt((Dw/2)^2-(Dw/2-delta)^2)*ones(n,1);% a为接触半宽
a=a.*(S>0)+0.*(S==0);
i3=find(a~=0);   %将a非0的数序列,以数组形式存入i3
i1=i3(1)-1; %%第一个不为0的数减1，因为后面从+1开始
n1=length(i3);
D=NaN(n1,n1);
for i=1:n1 %初始计算Dij,P,a
    for j=1:n1
        D(i,j)=integral(@(z)D_ij(z,a(j+i1),x(i+i1),x(j+i1),h),-a(j+i1),a(j+i1));
    end
end
S1=S;
S1(S==0)=[];
DD=sum(D);
P1=S1./DD'*pi*Eeqv;
% P1=pi*Eeqv*D^(-1)*S1;
a1=Dw/Eeqv*P1;

a(i1+1:i1+n1)=a1;
P(i1+1:i1+n1)=P1;

a01=a;
error=1;
%% 循环1
while error>1e-8||length(P1(P1<0))~=0 %#ok<ISMT>
i3=find(a>0);   %将a非0的数序列,以数组形式存入i3
i1=i3(1)-1; %%第一个不为0的数减1，因为后面从+1开始
n1=length(i3);
a(1:i1)=0;
a(i1+n1+1:n)=0;
P(1:i1)=0;
P(i1+n1+1:n)=0;
D=NaN(n1,n1);
for i=1:n1 %初始计算Dij,P,a
    for j=1:n1
        D(i,j)=integral(@(z)D_ij(z,a(j+i1),x(i+i1),x(j+i1),h),-a(j+i1),a(j+i1));
    end
end
S1=S(i1+1:i1+n1);
DD=sum(D);
P1=S1./DD'*pi*Eeqv;
a1=Dw/Eeqv*P1;

a(i1+1:i1+n1)=a1;
P(i1+1:i1+n1)=P1;

error=sum(abs(a01-a));
a=1/2*(a01+a);
a01=a;
end


Q1i_=0;
for i=1:n
    Q1i=a(i)*P(i);
    Q1i_=Q1i_+Q1i;
end
Q1=pi*h*Q1i_;