classdef Hertz_Contact_Ball2Ball < Component
    %% Hertz_Contact_Ball2Ball.m
    % ���ȽӴ�����ģ��
    % Author: Yu Xie, Feb 2023
   
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'E1'% �Ӵ���1����ģ��[Mpa]
            'E2'% �Ӵ���2����ģ��[Mpa]
            'Xi1'% �Ӵ���1���ɱ�
            'Xi2'% �Ӵ���2���ɱ�
            'Rho1'%�Ӵ���1�뾶[mm]
            'Rho2'%�Ӵ���2�뾶[mm]
            
            };
        
        inputExpectedFields = {
            'Contact_Load' % ���ȽӴ���[N]
            };
        
        outputExpectedFields = {
            'Contact_Max_Stress'% ���Ӵ�Ӧ��[Mpa]
            'Contact_Half_Width'% �Ӵ����[mm]
            'Relative_Rou'%�ۺ����ʰ뾶[mm]
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
                error('����뾶����С��0')
            else
                value = obj.params.Rho1*obj.params.Rho2/(obj.params.Rho1+obj.params.Rho2);
            end
        end
        
        function value = calculateContact_Max_Stress(obj)
            Temp_ZE=1/pi*(1/(((1-obj.params.Xi1^2)/obj.params.E1+(1-obj.params.Xi2^2)/obj.params.E2)))^(2/3);%���ϵ���ϵ��
            value=Temp_ZE*(6*obj.input.Contact_Load/(obj.output.Relative_Rou)^2)^(1/3);
        end
        
        function value = calculateContact_Half_Width(obj)
            Temp_value=((1-obj.params.Xi1^2)/obj.params.E1+(1-obj.params.Xi2^2)/obj.params.E2)^(1/3);
            value = (3/4*obj.input.Contact_Load*obj.output.Relative_Rou)^(1/3)*Temp_value;
        end
    end
    
end