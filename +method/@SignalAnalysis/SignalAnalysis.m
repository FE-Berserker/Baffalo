classdef SignalAnalysis < Component
    % Class SignalAnalysis
    % Author: Xie Yu
   
    properties(Hidden, Constant)
        paramsExpectedFields = {    
            'Name' %名称
            'DataName'
            'Echo' % Print
            };

        inputExpectedFields = {
            'TimeSeries'
            'Fs'% 采样频率 [Hz]
            };

        outputExpectedFields = {
            'Length' % data num
            'T' % 时间 [s]
            'F' % 频率 [Hz]
            'FFT'
            };

        baselineExpectedFields = {};
        default_Name='SignalAnalysis_1';
        default_Echo=1;
        default_DataName=[];
    end
    methods

        function obj = SignalAnalysis(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct); 
            obj.documentname='SignalAnalysis.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            L=size(obj.input.TimeSeries,1);
            T=1/obj.input.Fs;
            t=(0:L-1)*T;
            obj.output.Length=L;
            obj.output.T=t;

            if isempty(obj.params.DataName)
                warning('Please check the data type !')
            end
            % Print
            if obj.params.Echo
                fprintf('Successfully do the signal analysis ! .\n');
            end
        end

    end
end

