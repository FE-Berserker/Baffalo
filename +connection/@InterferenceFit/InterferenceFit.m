classdef InterferenceFit < Component
    % 过盈配合类
    % Author: Xie Yu
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Name' % 名称
            'Echo'
            'RzA' % 外圈粗糙度 [um]
            'Rzl' % 内圈粗糙度 [um]
            'uf' % 摩擦系数
            'Temperature'% 轴和轴套温度
            'T_Ref'% 参考温度
            'KA' % 应用系数
            'StressType' % 应力计算类型 1.等效应力 2. 主应力
            };
        
        inputExpectedFields = {
            'Hub_Mat'
            'Shaft_Mat'
            'DaA' % 轴套外径 [mm]
            'DF' % 过盈直径 [mm]
            'Dil' % 轴内径 [mm]
            'LF' % 配合长度 [mm]
            'Umin' % 最小过盈 [mm]
            'Umax' % 最大过盈 [mm]
            'Tn' % 名义扭矩 [Nmm]
            'Shaft_Rm' % 抗拉强度 [MPa]
            'Shaft_Rp' % 屈服强度 [MPa]
            'Hub_Rm' % 抗拉强度 [MPa]
            'Hub_Rp' % 屈服强度 [MPa]
            };
        
        outputExpectedFields = {
            'Uwmin' % 最小有效过盈量
            'Uwmax' % 最大有效过盈量
            'P'% 过盈压力 [Mpa]
            'F'% 拔出力 [N]
            'Torque'% 打滑扭矩 [Nmm]
            'Hub_Stress'
            'Shaft_Inner_Stress'
            'Shaft_Outer_Stress'
            'Assembly'
            };
        
        baselineExpectedFields = {
            'Sr'% 滑动安全系数
            'S_sRm'% 轴断裂安全系数
            };
        default_Name='InterferenceFit1'
        default_Echo=1;
        default_RzA=4.8;
        default_Rzl=4.8;
        default_uf=0.15;
        default_T_Ref=20;
        default_Temperature=[20,20];
        default_KA=1;
        default_StressType=1;
        base_Sr=1.2;
        base_S_sRm=1.5;
        base_S_sRp=1;
        base_S_hRm=1.5;
        base_S_hRp=1;

    end
    methods
        
        function obj = InterferenceFit(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='InterferenceFit.pdf';
        end
        
        function obj = solve(obj)
            % Calculate outputs
            obj.output.Uwmax=obj.input.Umax-0.4*(obj.params.RzA+obj.params.Rzl)/1000;
            obj.output.Uwmin=obj.input.Umin-0.4*(obj.params.RzA+obj.params.Rzl)/1000;
            [Pmax,Pmin,Pmean]=Contact_Pressure_Cal(obj);
            obj.output.P=[Pmax,Pmin,Pmean];
            [Hub_Stress,Shaft_Inner_Stress,Shaft_Outer_Stress,...
                Hub_max1,Hub_max2,Shaft_max1,Shaft_max2]=Stress_Cal(obj);
            obj.output.Hub_Stress=Hub_Stress;
            obj.output.Shaft_Inner_Stress=Shaft_Inner_Stress;
            obj.output.Shaft_Outer_Stress=Shaft_Outer_Stress;
            obj.output.F=[Pmax,Pmin,Pmean].*pi.*obj.input.DF.*obj.input.LF.*obj.params.uf;
            obj.output.Torque=obj.output.F.*obj.input.DF/2;
            % Calculate capacity
            if ~isempty(obj.input.Tn)
                obj.capacity.Sr=obj.output.Torque(2)/obj.input.Tn/obj.params.KA;
            end
            if ~isempty(obj.input.Hub_Rm)
                obj.capacity.S_hRm=obj.input.Hub_Rm/Hub_max1;
            end
            if ~isempty(obj.input.Hub_Rp)
                obj.capacity.S_hRp=obj.input.Hub_Rp/Hub_max2;
            end
            if ~isempty(obj.input.Shaft_Rm)
                obj.capacity.S_sRm=obj.input.Shaft_Rm/Shaft_max1;
            end
            if ~isempty(obj.input.Shaft_Rp)
                obj.capacity.S_sRp=obj.input.Shaft_Rp/Shaft_max2;
            end

            %% Print
            if obj.params.Echo
                fprintf('Successfully calculate output .\n');
            end

        end
    end
end