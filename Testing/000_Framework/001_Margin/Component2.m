classdef Component2 < Component
    % Class TestComponent
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'p'
            };

        inputExpectedFields = {
            'a' 
            'b'
            };

        outputExpectedFields = {
            'c'
            };

        baselineExpectedFields = {
            'S1'
            'S2'
            };

        statesExpectedFields = {};
        default_p=1;
        base_S1=1;
        base_S2=1;
    end
    methods

        function obj = Component2(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='Component.pdf';
        end

        function obj = solve(obj)
            a=obj.input.a;
            b=obj.input.b;
            p=obj.params.p;
            c=(a-b)*p;
            obj.output.c=c;
            obj.capacity.S1=c;
            obj.capacity.S2=c/1.2;
        end

    end
end

