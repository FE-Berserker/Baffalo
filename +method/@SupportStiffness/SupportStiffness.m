classdef SupportStiffness < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Ang' % 旋转角度
            };

        inputExpectedFields = {
            'N' % 支座数量
            'ka' % 轴向刚度 N/mm
            'ks' % 剪切刚度 N/mm
            'Dp' % 支座分度圆 mm
            };

        outputExpectedFields = {
            'Ka' % 总体轴向刚度 N/mm
            'Ksx' % 总体x向剪切刚度 N/mm
            'Ksy' % 总体y向剪切刚度 N/mm
            'Kt' % 总体扭转刚度 N·mm/rad
            'Kbx' % 总体x向弯曲刚度 N·mm/rad
            'Kby' % 总体y向弯曲刚度 N·mm/rad
            };

        baselineExpectedFields = {
            };

        default_Name='SupportStiffness_1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Ang=0;
    end
    methods

        function obj = SupportStiffness(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='SupportStiffness.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            % Check input is Null
            Check(obj)

            %% Write the fomula of the component calculation
            ka=obj.input.ka;
            N=obj.input.N;
            ks=obj.input.ks;
            Dp=obj.input.Dp;
            Rp=Dp/2;
            Ang=obj.params.Ang;

            % 总体轴向刚度
            Ka=N*ka;
            % 总体剪切刚度
            Ksx=N*ks;
            Ksy=N*ks;
            % 总体扭转刚度
            Kt=N*ks*Rp^2;
            % 总体弯曲刚度
            Temp_Kbx=zeros(N,1);
            Temp_Kby=zeros(N,1);

            for i=1:N
                theta=Ang/180*pi+2*pi/N*(i-1);
                Temp_Kbx(i,1)=(Rp*sin(theta))^2*ka;
                Temp_Kby(i,1)=(Rp*cos(theta))^2*ka;
            end

            Kbx=sum(abs(Temp_Kbx));
            Kby=sum(abs(Temp_Kby));

            %% Parse
            obj.output.Ka=Ka;
            obj.output.Ksx=Ksx;
            obj.output.Ksy=Ksy;
            obj.output.Kt=Kt;
            obj.output.Kbx=Kbx;
            obj.output.Kby=Kby;

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate support stiffness .\n');
            end
        end
    end
end

