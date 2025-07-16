classdef Compliance < Component
    % Compliance.m
    % Author: Yu Xie, Aug 2023

    properties (Hidden, Constant)

        paramsExpectedFields = {
            };

        inputExpectedFields = {
            'E'% E1,E2,E3
            'G'% G23 G31 G12
            'v'% v23 v31 v12
            };

        outputExpectedFields = {
            'Matrix_S'% 刚度矩阵
            'Matrix_C'% 柔度矩阵
            };

        baselineExpectedFields = {};

    end

    methods

        function obj = Compliance(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end

        function obj = solve(obj)
            %calculate outputs
            E1=obj.input.E(1);
            E2=obj.input.E(2);
            E3=obj.input.E(3);
            v21=obj.input.v(3);
            v32=obj.input.v(1);
            v31=obj.input.v(2);
            G12=obj.input.G(3);
            G23=obj.input.G(1);
            G13=obj.input.G(2);
            obj.output.Matrix_C=cal_C(E1,E2,E3,v21,v32,v31,G12,G23,G13);
            obj.output.Matrix_S=cal_S(E1,E2,E3,v21,v32,v31,G12,G23,G13);
        end
    end
end

function C=cal_C(E1,E2,E3,v21,v32,v31,G12,G23,G13)
C1=OrthotropicCompliance(E1,E2,E3,v21,v32,v31,G12,G23,G13);
if min(eig(C1))>0
    C=C1;
else
    C='输入参数不合理，请核对。';
end
end

function S=cal_S(E1,E2,E3,v21,v32,v31,G12,G23,G13)
S1=OrthotropicCompliance(E1,E2,E3,v21,v32,v31,G12,G23,G13);
if min(eig(S1))>0
    S=inv(S1);
else
    S='输入参数不合理，请核对。';
end
end

function S=OrthotropicCompliance(E1,E2,E3,v21,v32,v31,G12,G23,G13)
%函数功能：用于计算正交各向异性材料的柔度矩阵。
%调用格式：OrthotropicCompliance(E1,E2,E3,v21,v32,v31,G12,G23,G13)。
%输入参数：E1、E2、E3—弹性模量；
%         v21、v32、v31—泊松比；
%         G23、G31、G12—剪切弹性模量。
%运行结果：6×6柔度矩阵。
S=[1/E1 -v21/E1 -v31/E1 0 0 0;
    -v21/E1 1/E2 -v32/E2 0 0 0;
    -v31/E1 -v32/E2 1/E3 0 0 0;
    0 0 0 1/G23 0 0;
    0 0 0 0 1/G13 0;
    0 0 0 0 0 1/G12];
end
