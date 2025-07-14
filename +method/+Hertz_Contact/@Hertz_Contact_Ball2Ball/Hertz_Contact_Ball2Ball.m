classdef Hertz_Contact_Ball2Ball < Component
    %% Hertz_Contact_Ball2Ball.m
    % 赫兹接触基本模型
    % Author: Yu Xie, Feb 2023
   
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
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
        
        baselineExpectedFields = {
            };
        
    end
    
    methods
        
        function obj = Hertz_Contact_Ball2Ball(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end
        
        function obj = solve(obj)
            %calculate outputs
            obj.output.Relative_Rou = calculateRelative_Rou(obj);
            obj.output.Contact_Max_Stress = calculateContact_Max_Stress(obj);
            obj.output.Contact_Half_Width = calculateContact_Half_Width(obj);
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
        
        function PlotPressure3D(obj)
            %Plot Hertz Contact Stress
            step=obj.output.Contact_Half_Width/50;
            [x,y] = meshgrid(-obj.output.Contact_Half_Width*2:step:obj.output.Contact_Half_Width*2);
            z=obj.output.Contact_Max_Stress*...
                sqrt((1-x.^2/obj.output.Contact_Half_Width.^2-y.^2/obj.output.Contact_Half_Width.^2)...
                .*((1-x.^2/obj.output.Contact_Half_Width.^2-y.^2/obj.output.Contact_Half_Width.^2)>=0));
            figure;
            surf(x,y,z);
            colormap('jet');
            xlabel('Contact Width (mm)'); ylabel('Contact Width (mm)'); zlabel('Contact Stress (Mpa)'); 
            title('3D Hertz Contact Stress Distribution')
        end
        function value = calculateRelative_Rou(obj)
            if or(obj.params.Rho1,obj.params.Rho2)<=0
                error('球体半径不能小于0')
            else
                value = obj.params.Rho1*obj.params.Rho2/(obj.params.Rho1+obj.params.Rho2);
            end
        end
        
        function value = calculateContact_Max_Stress(obj)
            Temp_ZE=1/pi*(1/(((1-obj.params.Xi1^2)/obj.params.E1+(1-obj.params.Xi2^2)/obj.params.E2)))^(2/3);%材料弹性系数
            value=Temp_ZE*(6*obj.input.Contact_Load/(obj.output.Relative_Rou)^2)^(1/3);
        end
        
        function value = calculateContact_Half_Width(obj)
            Temp_value=((1-obj.params.Xi1^2)/obj.params.E1+(1-obj.params.Xi2^2)/obj.params.E2)^(1/3);
            value = (3/4*obj.input.Contact_Load*obj.output.Relative_Rou)^(1/3)*Temp_value;
        end
    end
    
end