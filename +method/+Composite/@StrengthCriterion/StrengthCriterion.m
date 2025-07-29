classdef StrengthCriterion < Component
    % StrengthCriterion.m
    % Author: Yu Xie, Aug 2023

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'Method'
            'Echo'  
            };

        inputExpectedFields = {
            'Stress'
            'Strain'
            'Material'
            };

        outputExpectedFields = {
            'minR'
            'minR_detail'
            'R'
            };

        baselineExpectedFields = {};

        default_Method=1;
        default_Echo=1;
    end

    methods
        function obj = StrengthCriterion(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Composite_StrengthCriterion.pdf';
        end

        function obj = solve(obj)
            % Calculate outputs
            switch obj.params.Method
                case 1
                    obj=MaxStressCriterion(obj);
                case 2
                    obj=MaxStrainCriterion(obj);
                case 3
                    obj=TsaiHillCriterion(obj);
                case 4
                    obj=HoffmanCriterion(obj);
                case 5
                    obj=TsaiWuCriterion(obj);
                case 6
                    obj=HashinCriterion(obj);
                case 7
                    obj=PuckCriterion(obj);
            end

            % Set high allowables
            if isnan(obj.output.minR)
                obj.output.minR=99999;
            end
            for i=1:size(obj.output.minR_detail,2)
                if isnan(obj.output.minR_detail(i))
                    obj.output.minR_detail(i)=99999;
                end
            end

            row=1:size(obj.output.R,1);
            for i=1:size(obj.output.R,2)
                obj.output.R(row(isnan(obj.output.R(:,i)')),i)=99999;
            end

            if obj.params.Echo
                fprintf('Successfully calculate the strength criterion .\n');
            end

        end
    end

end
