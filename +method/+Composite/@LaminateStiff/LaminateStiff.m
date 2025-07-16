classdef LaminateStiff < Component
    %% Laminate.m
    % Author: Yu Xie, Sep 2023

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'Slice'
            };

        inputExpectedFields = {
            'E'% E1,E2
            'G'% G12
            'v'% v21
            'tk' % thickness
            'theta'% 角度
            };

        outputExpectedFields = {
            'A'% 拉伸刚度系数
            'B'% 耦合刚度系数
            'D'% 弯曲刚度系数
            'a'
            'b'
            'c'
            'd'
            };

        baselineExpectedFields = {};

        default_Slice=90;
    end

    methods

        function obj = LaminateStiff(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end

        function obj = solve(obj)
            %calculate outputs
            E1=obj.input.E(1);
            E2=obj.input.E(2);
            v21=obj.input.v;
            G12=obj.input.G;
            tk=obj.input.tk;
            theta=obj.input.theta;
            [A,B,D]=LaminateStiffness(E1,E2,v21,G12,tk,theta);
            obj.output.A=A;
            obj.output.B=B;
            obj.output.D=D;
            [a,b,c,d]=LaminateCompliance(E1,E2,v21,G12,tk,theta);
            obj.output.a=a;
            obj.output.b=b;
            obj.output.c=c;
            obj.output.d=d;
        end


        
    end
end

function [A,B,D]=LaminateStiffness(E1,E2,v21,G12,tk,theta)
%函数功能：计算层合板的刚度系数矩阵[A]、[B]、[D]。
%调用格式：[A,B,D]=LaminateStiffness(E1,E2,v21,G12,tk,theta)
%输入参数：theta—铺层角度，输入时用向量表示。
%          tk—铺层厚度，且每层铺层厚度一样。
%          E1,E2,v12,G12—材料工程弹性常数。
%运行结果：A、B、D刚度系数矩阵，每个矩阵大小为3×3。
n=length(theta);
z=-n*tk/2:tk:n*tk/2;
A=zeros(3);B=zeros(3);D=zeros(3);
for i=1:n
    Q(:,:,i)=PlaneStiffness(E1,E2,v21,G12,theta(i)); %#ok<AGROW> 
    A=Q(:,:,i)*(z(i+1)-z(i))+A;
    B=0.5*Q(:,:,i)*(z(i+1)^2-z(i)^2)+B;
    D=(1/3)*Q(:,:,i)*(z(i+1)^3-z(i)^3)+D;
end

end

function [a,b,c,d]=LaminateCompliance(E1,E2,v21,G12,tk,theta) 
%函数功能：计算层合板的柔度系数矩阵[a]、[b]、[c]、[d]。
%调用格式：[a,b,c,d]= LaminateCompliance (E1,E2,v21,G12,tk,theta)
%输入参数：theta—铺层角度，输入时用向量表示。
%          tk—铺层厚度，且每层铺层厚度一样。
%          E1,E2,v12,G12—材料参数。
%运行结果：[a]、[b]、[c]、[d]柔度系数矩阵，每个矩阵大小为3×3。
[A,B,D]=LaminateStiffness(E1,E2,v21,G12,tk,theta) ;
S=inv([A,B;B,D]);
a=S(1:3,1:3);
b=S(1:3,4:6);
c=S(4:6,1:3);
d=S(4:6,4:6);
end

function C=PlaneStiffness(E1,E2,v21,G12,theta) 
%函数功能：用于计算单层复合材料板的刚度矩阵。
%调用格式：PlaneStiffness(E1,E2,v21,G12,theta)。
%输入参数：E1,E2—弹性模量；
%          v12—泊松比；
%          G12—剪切模量；
%          theta—偏轴角度。
%运行结果：3×3刚度矩阵。
S=PlaneCompliance (E1,E2,v21,G12,theta) ;
C=inv(S);
end

function S=PlaneCompliance(E1,E2,v21,G12,theta)
%函数功能：用于计算单层复合材料板的柔度矩阵。
%调用格式：PlaneCompliance(E1,E2,v12,G12,theta)。
%输入参数：E1,E2—弹性模量；
%          v12—泊松比；
%          G12—剪切模量；
%          theta—偏轴角度。
%运行结果：3×3柔度矩阵。
Ts=StressTransformation(theta,2);
RS=ReducedCompliance(E1,E2,v21,G12) ; 
Te=StrainTransformation(theta,2);
S=inv(Te)*RS*Ts; %#ok<MINV> 
end



