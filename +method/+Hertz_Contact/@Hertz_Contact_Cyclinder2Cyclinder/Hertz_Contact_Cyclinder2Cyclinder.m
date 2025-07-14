classdef Hertz_Contact_Cyclinder2Cyclinder < Component
    %% Hertz_Contact.m
    % ���ȽӴ�����ģ��
    % Author: Yu Xie, Feb 2023

    properties (Hidden, Constant)

        paramsExpectedFields = {
            'Contact_Length'% ���ȽӴ�����[mm]
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
                error('�Ӵ�������Ϊ��')
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
            Temp_ZE=sqrt(1./(pi*((1-obj.params.Xi1^2)./obj.params.E1+(1-obj.params.Xi2^2)./obj.params.E2)));%���ϵ���ϵ��
            value=Temp_ZE.*sqrt(obj.input.Contact_Load./obj.params.Contact_Length./abs(obj.output.Relative_Rou));
        end

        function value = calculateContact_Half_Width(obj)
            Temp_value=sqrt(((1-obj.params.Xi1.^2)./obj.params.E1+(1-obj.params.Xi2^2)./obj.params.E2)/pi);
            value = sqrt(4.*obj.input.Contact_Load./obj.params.Contact_Length.*obj.output.Relative_Rou).*Temp_value;
        end
    end

end