classdef Rainflow_Counting < Component
    %% Rainflow_Counting.m
    % 雨流计数法
    % Author: Yu Xie, Feb 2023
      
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Ne'% SN曲线拐点处次数
            'Me'% SN曲线第一段斜率
            };
        
        inputExpectedFields = {
            'Timeseries' % 时间序列
            'N_partition'% 载荷分段
            'Frequency' % 频率 [Hz]
            };
        
        outputExpectedFields = {
            'Markov_Matrix'% Markov矩阵
            'Markov_Matrix_list'% Markov序列
            'Equivalent_load_stress'%等效疲劳载荷或者应力
            };
        
        baselineExpectedFields = {};

        default_Ne=5e6;
        default_Me=3;
        
    end
    
    methods
        
        function obj = Rainflow_Counting(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Rainflow_Counting.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            %calculate outputs
            obj.output.Markov_Matrix = calculateMarkov_Matrix(obj);
            obj.output.Markov_Matrix_list = calculateMarkov_Matrix_list(obj);
            obj.output.Equivalent_load_stress = calculateEquivalent_load_stress(obj);
        end
        
        function obj=plotMarkov_2D(obj)
            %Plot Markov
            [x,y] = meshgrid(obj.output.Markov_Matrix(1,2:end),obj.output.Markov_Matrix(2:end,1)');
            z=obj.output.Markov_Matrix(2:end,2:end);
            figure;
            contourf(x,y,z,obj.input.N_partition, 'LineColor','none');
            colormap('jet');
            colorbar;
            xlabel('Range')
            ylabel('Mean')
            title('Markov Matrix')
        end
        
        function obj=plotMarkov_3D(obj)
            %Plot Markov
            [x,y] = meshgrid(obj.output.Markov_Matrix(1,2:end),obj.output.Markov_Matrix(2:end,1)');
            z=obj.output.Markov_Matrix(2:end,2:end);
            figure;
            surf(x,y,z);
            colormap('jet');
            xlim([obj.output.Markov_Matrix(1,2),obj.output.Markov_Matrix(1,end)]);
            ylim([obj.output.Markov_Matrix(2,1),obj.output.Markov_Matrix(end,1)]);
            %colorbar;
            xlabel('Range')
            ylabel('Mean')
            title('Markov Matrix')
        end
        
        function value = calculateMarkov_Matrix(obj)
            Temp =rainflow(obj.input.Timeseries);
            Temp(:,1)=Temp(:,1).*obj.input.Frequency;
            Max_Range=max(Temp(:,2));Min_Range=min(Temp(:,2));
            Max_Mean=max(Temp(:,3));Min_Mean=min(Temp(:,3));
            Range_Step=(Max_Range-Min_Range)/obj.input.N_partition;
            Mean_Step=(Max_Mean-Min_Mean)/obj.input.N_partition;
            value=zeros(obj.input.N_partition+1,obj.input.N_partition+1);
            Temp_Cyc=zeros(obj.input.N_partition,obj.input.N_partition);
            Temp_Range=linspace(Min_Range+Range_Step/2,Max_Range-Range_Step/2,obj.input.N_partition);
            Temp_Mean=linspace(Min_Mean+Mean_Step/2,Max_Mean-Mean_Step/2,obj.input.N_partition);
            for i=1:numel(Temp(:,1))
                Temp1=Temp_Range-Temp(i,2);
                Temp2=Temp_Mean-Temp(i,3);
                [~,col1]=find(abs(Temp1)<=0.5*Range_Step+1e-6);
                [~,col2]=find(abs(Temp2)<=0.5*Mean_Step+1e-6);
                col1=col1(1,1);col2=col2(1,1);
                Temp_Cyc(col2,col1)=Temp_Cyc(col2,col1)+Temp(i,1);
            end
            value(1,2:end)=Temp_Range;
            value(2:end,1)=Temp_Mean';
            value(2:end,2:end)=Temp_Cyc';
        end
        
        function value = calculateMarkov_Matrix_list(obj)
            Range=obj.output.Markov_Matrix(1,2:end)';
            Cycle=sum(obj.output.Markov_Matrix(2:end,2:end))';
            value=table(Range,Cycle);
        end
        
        function value = calculateEquivalent_load_stress(obj)
            Temp =rainflow(obj.input.Timeseries);
            Damage=Temp(:,2).^obj.params.Me.*Temp(:,1).*obj.input.Frequency/obj.params.Ne;
            value=(sum(Damage)).^(1./obj.params.Me);
        end
    end
end