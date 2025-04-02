classdef RayleighEstimate < Component
    % Class RayleighEstimate
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            };

        inputExpectedFields = {
            'Xi'% 阻尼比
            'f1' % 自振频率 注意频率和圆频率区别
            'f2' % 自振频率  
            };

        outputExpectedFields = {
            'alpha'
            'beta'

            };

        baselineExpectedFields = {
            };

        default_Name='RayleighEstimate_1'; % Set default params name
        default_Echo=1; % Set default params Echo
    end
    methods

        function obj = RayleighEstimate(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='RayleighEstimate.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Write the fomula of the component calculation
            f1=obj.input.f1;
            f2=obj.input.f2;
            Xi=obj.input.Xi;

            alpha=2*f1*f2*Xi/(f1+f2);
            beta=2*Xi/(f1+f2)/2/pi;

            % Parse
            obj.output.alpha=alpha;
            obj.output.beta=beta;

            if obj.params.Echo
                fprintf('Successfully calculate rayleigh damping .\n');
            end
        end
    end
end

