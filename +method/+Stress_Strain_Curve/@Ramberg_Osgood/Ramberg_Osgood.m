classdef Ramberg_Osgood < Component
    % Ramberg_Osgood Stess Strain Curve
    % Author: Yu Xie
   
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            };
        
        inputExpectedFields = {
            'E' % 材料弹性模量 [Mpa]
            'Ftu' % 材料拉伸强度 [Mpa]
            'Fty' % 材料屈服强度 [Mpa]
            'Epsilon' % 断裂延伸率
            
            };
        
        outputExpectedFields = {
            'Normal_Stress' % 名义应力 [Mpa]
            'Normal_Strain' % 名义应变
            'True_Stress' % 真实应力 [Mpa]
            'True_Strain' % 真实应变
            'n' % 参数
            };

        baselineExpectedFields = {
            };

    end
    methods
        
        function obj = Ramberg_Osgood(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Ramberg_Osgood.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            %calculate outputs
            obj.output.n=cal_n(obj);
            Temp1=(0:obj.input.Fty/5:obj.input.Fty/5*4)';
            Temp2=(obj.input.Fty/20*17:obj.input.Fty/20:obj.input.Fty)';
            Temp3=(obj.input.Fty+(obj.input.Ftu-obj.input.Fty)/10:(obj.input.Ftu-obj.input.Fty)/10:obj.input.Ftu)';
            obj.output.Normal_Stress=[Temp1;Temp2;Temp3];
            obj.output.Normal_Strain=obj.output.Normal_Stress/obj.input.E+0.002.*(obj.output.Normal_Stress./obj.input.Fty).^obj.output.n;
            obj.output.True_Stress=obj.output.Normal_Stress.*(1+obj.output.Normal_Strain);
            obj.output.True_Strain=log(1+obj.output.Normal_Strain);
        end

        function Value=cal_n(obj)
            Value=log(100*(obj.input.Epsilon-obj.input.Ftu/obj.input.E)/0.2)/log(obj.input.Ftu/obj.input.Fty);
        end

        function obj = plot(obj)
            plot(obj.output.Normal_Strain,obj.output.Normal_Stress);hold on
            plot(obj.output.True_Strain,obj.output.True_Stress);
            legend('Normal Stress','True Stress');
            xlabel('Strain')
            ylabel('Stress (Mpa)')
            title('Stress Strain Curve')

        end


    end
        

end