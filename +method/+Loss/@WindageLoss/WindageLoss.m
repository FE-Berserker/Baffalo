classdef WindageLoss < Component
    % Class Name
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name of Component
            'Echo' % Print
            'Rho' % 空气密度 [kg/m3]
            'Mu' % 动态粘度 [Pa s]
            };

        inputExpectedFields = {
            'n' % 转子转速 [RPM]
            'D2out' % 内转子外径 [m]
            'D1in' % 外转子内径 [m]
            'Li' % 电枢有效长度 [m]
            'dsh' % 轴直径 [m]
            'vax' % 风扇风速 [m/s]
            'dsl' % 护套厚度 [m]
            };

        outputExpectedFields = {
            'Pa' % 气隙体抗力力矩损耗
            'Pad' % 转子表面抵抗力力矩损耗
            'Pc' % 冷却介质轴向流动损耗
            'Re' % 气隙雷诺数
            'cf' % 摩擦系数
            'Red'% 圆盘雷诺数
            'cfd' % 摩擦系数
            'vt' % 平均切向线速度
            'v' % 转子表面线速度
            'Ptotal'
            };

        baselineExpectedFields = {
            };

        default_Name='WindageLoss_1'; % Set default params name
        default_Echo=1; % Set default params Echo
        default_Rho=1.225; 
        default_Mu=1.7966e-05;
    end
    methods

        function obj = WindageLoss(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='WindageLoss.pdf'; % Set help file name, put it in the folder "Document"
        end

        function obj = solve(obj)
            if isempty(obj.input.vax)
                vax=0;
            else
                vax=obj.input.vax;
            end

            if isempty(obj.input.dsl)
                dsl=0;
            else
                dsl=obj.input.dsl;
            end
            % Write the fomula of the component calculation
            n=obj.input.n;
            Omega=n/60*2*pi;
            Rho=obj.params.Rho;
            D2out=obj.input.D2out;
            D1in=obj.input.D1in;
            Mu=obj.params.Mu;
            Li=obj.input.Li;
            dsh=obj.input.dsh;

            g=(D1in-D2out)/2;

            Re=Rho*Omega*(g-dsl)*D2out/2/Mu;
            if Re<10000
                cf=0.515*(2*(g-dsl)/D2out)^0.3/(Re^0.5);
            else
                cf=0.0325*(2*(g-dsl)/D2out)^0.3/(Re^0.2);
            end
            Pa=pi*cf*Rho*Omega^3*D2out^4/16*Li;

            Red=Rho*Omega*D2out^2/4/Mu;

            if Red<3e5
                cfd=3.87/(Red^0.5);
            else
                cfd=0.146/(Red^0.2);
            end

            Pad=1/64*cfd*Rho*Omega^3*(D2out^5-dsh^5);

            v=D2out*Omega/2;
            vt=0.5*v;

            Pc=2/3*pi*Rho*vt*vax*Omega*((0.5*D1in)^3-(0.5*D2out)^3);
            

            % Parse
            obj.output.Pa=Pa;
            obj.output.Re=Re;
            obj.output.cf=cf;
            obj.output.Red=Red;
            obj.output.cfd=cfd;
            obj.output.Pad=Pad;
            obj.output.v=v;
            obj.output.vt=vt;
            obj.output.Pc=Pc;
            obj.output.Ptotal=Pa+Pad+Pc;

            % Print
            if obj.params.Echo
                fprintf('Successfully calculate windage loss .\n');
            end
        end
    end
end

