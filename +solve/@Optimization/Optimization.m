classdef Optimization < Component
    % Class Optimization
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' %名称
            'Parameter'
            'Method'
            'Echo'
            };

        inputExpectedFields = {
            'LBound'% 下边界
            'UBound'% 上边界
            'Constraint'% 约束方程
            'Goal'% 目标函数 
            };

        outputExpectedFields = {
            'Fmin' % 最优值
            'GBest' % 最优个体
            'G_Iteration'
            'F_Iteration'
            };

        baselineExpectedFields = {};
        default_Name='Optimization1';
        default_Parameter=[];
        default_Method='PSO'
        default_Echo=1;
    end
    methods

        function obj = Optimization(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Optimization.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            Cost=obj.input.Goal;
            Constraint=obj.input.Constraint;
            Lb=obj.input.LBound;
            Ub=obj.input.UBound;
            para=obj.params.Parameter;
            switch obj.params.Method
                case 'PSO'
                    [gbest,fbest,gbest1,fitness1] = PSO(Cost,Constraint,Lb,Ub,para);
            end
            obj.output.Fmin=fbest;
            obj.output.GBest=gbest;
            obj.output.G_Iteration=gbest1;
            obj.output.F_Iteration=fitness1;

        end

    end
end
