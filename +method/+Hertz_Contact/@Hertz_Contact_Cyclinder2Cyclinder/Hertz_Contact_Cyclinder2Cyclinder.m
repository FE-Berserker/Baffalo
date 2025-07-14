classdef Hertz_Contact_Cyclinder2Cyclinder < Component
    %% Hertz_Contact.m
    % 赫兹接触基本模型
    % Author: Yu Xie, Feb 2023

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'Contact_Length'% 赫兹接触长度[mm]
            'E1'% 接触体1弹性模量[Mpa]
            'E2'% 接触体2弹性模量[Mpa]
            'Xi1'% 接触体1泊松比
            'Xi2'% 接触体2泊松比
            'Rho1'%接触体1半径[mm]
            'Rho2'%接触体2半径[mm]

            };

        inputExpectedFields = {
            'Contact_Load' % 赫兹接触力[N]
            };

        outputExpectedFields = {
            'Contact_Max_Stress'% 最大接触应力[Mpa]
            'Contact_Half_Width'% 接触半宽[mm]
            'Relative_Rou'%综合曲率半径[mm]
            };

        baselineExpectedFields = {};

    end

    methods

        function obj = Hertz_Contact_Cyclinder2Cyclinder(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end

        function obj = solve(obj)
            %calculate outputs
            if obj.input.Contact_Load==0
                obj.output.Contact_Max_Stress=0;
            elseif obj.input.Contact_Load<0
                error('接触力不能为负')
            else
                obj.output.Relative_Rou = calculateRelative_Rou(obj);
                obj.output.Contact_Max_Stress = calculateContact_Max_Stress(obj);
                obj.output.Contact_Half_Width = calculateContact_Half_Width(obj);
            end
        end

        function PlotPressure(obj)
            %Plot Hertz Contact Stress
            x=linspace(-100,100,201)/100*obj.output.Contact_Half_Width;
            y=obj.output.Contact_Max_Stress/obj.output.Contact_Half_Width*...
                sqrt(obj.output.Contact_Half_Width.^2-x.^2);
            figure;
            plot(x,y);
            xlabel('Contact Width (mm)')
            ylabel('Contact Stress (Mpa)')
            title('Hertz Contact Stress Distribution')
        end
        function value = calculateRelative_Rou(obj)
            value = obj.params.Rho1.*obj.params.Rho2./(obj.params.Rho1+obj.params.Rho2);
        end

        function value = calculateContact_Max_Stress(obj)
            Temp_ZE=sqrt(1./(pi*((1-obj.params.Xi1^2)./obj.params.E1+(1-obj.params.Xi2^2)./obj.params.E2)));%材料弹性系数
            value=Temp_ZE.*sqrt(obj.input.Contact_Load./obj.params.Contact_Length./abs(obj.output.Relative_Rou));
        end

        function value = calculateContact_Half_Width(obj)
            Temp_value=sqrt(((1-obj.params.Xi1.^2)./obj.params.E1+(1-obj.params.Xi2^2)./obj.params.E2)/pi);
            value = sqrt(4.*obj.input.Contact_Load./obj.params.Contact_Length.*obj.output.Relative_Rou).*Temp_value;
        end
    end

end