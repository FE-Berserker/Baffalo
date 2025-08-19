classdef Roller_Substress_Cal < gGroup
    % Roller_Substress_Cal.m
    % Author: Yu Xie, Feb 2013
    
    properties (Constant, Hidden)
        paramsExpectedFields = {
            'Bearing_ID' % 轴承内径 [mm]
            'Bearing_OD' % 轴承外径 [mm]
            'Bearing_RD' % 轴承滚子直径 [mm]
            'ID_Contact_Length'% 内圈有效接触长度[mm]
            'OD_Contact_Length'% 外圈有效接触长度[mm]
            'Roller_E'% 滚子弹性模量[Mpa]
            'Ring_E'% 内外圈弹性模量[Mpa]
            'Roller_Xi'% 滚子泊松比
            'Ring_Xi'% 内外圈泊松比
            'Mu' % 摩擦系数
            };
        
        inputExpectedFields = {
            'Bearing_Roller_Force' % 轴承滚子力 [mm]
            'Cal_Depth' % 计算深度
            };
        
        outputExpectedFields = {
            'IR_Sub_Tau_xy' % 内圈次表面剪应力 [Mpa]
            'IR_Sub_Tau_max'% 内圈次表面最大剪应力 [Mpa]
            'IR_Sub_Sigma_1' % 内圈次表面第一主应力 [Mpa]
            'IR_Layer_Tau_xy' % 内圈分层次表面正交剪应力 [Mpa]
            'IR_Layer_Tau_max' % 内圈分层次表面最大剪应力 [Mpa]
            'IR_Layer_Sigma_1' % 内圈分层次表面最大主应力 [Mpa]
            'IR_Contact_Stress' % 内圈接触应力 [Mpa]
            'IR_Half_Width' % 内圈接触半宽 [mm]
            'OR_Sub_Tau_xy' % 外圈次表面剪应力 [Mpa]
            'OR_Sub_Tau_max'% 外圈次表面最大剪应力 [Mpa]
            'OR_Sub_Sigma_1' % 内圈次表面第一主应力 [Mpa]
            'OR_Layer_Tau_xy' % 外圈分层次表面正交剪应力 [Mpa]
            'OR_Layer_Tau_max' % 外圈分层次表面最大剪应力 [Mpa]
            'OR_Layer_Sigma_1' % 外圈分层次表面最大主应力 [Mpa]
            'OR_Contact_Stress' % 外圈接触应力 [Mpa]
            'OR_Half_Width' % 外圈接触半宽 [mm]
            
            };
        
        statesExpectedFields = {
            };
        
        default_Roller_E = 2.06e5;
        default_Ring_E = 2.06e5;
        default_Roller_Xi = 0.3;
        default_Ring_Xi = 0.3;
        default_Mu = 0;
        
    end
    
    methods
        function obj = Roller_Substress_Cal(paramsStruct, inputStruct)
            
            obj = obj@gGroup(paramsStruct,inputStruct);
            paramsStruct1.Contact_Length=obj.params.ID_Contact_Length;
            paramsStruct1.E1=obj.params.Roller_E;
            paramsStruct1.E2=obj.params.Ring_E;
            paramsStruct1.Xi1=obj.params.Roller_Xi;
            paramsStruct1.Xi2=obj.params.Ring_Xi;
            paramsStruct1.Rho1=obj.params.Bearing_ID/2;
            paramsStruct1.Rho2=obj.params.Bearing_RD/2;
            inputStruct1.Contact_Load=obj.input.Bearing_Roller_Force;
            
            paramsStruct2.Contact_Length=obj.params.OD_Contact_Length;
            paramsStruct2.E1=obj.params.Roller_E;
            paramsStruct2.E2=obj.params.Ring_E;
            paramsStruct2.Xi1=obj.params.Roller_Xi;
            paramsStruct2.Xi2=obj.params.Ring_Xi;
            paramsStruct2.Rho1=obj.params.Bearing_OD/2;
            paramsStruct2.Rho2=obj.params.Bearing_RD/2;
            inputStruct2.Contact_Load=obj.input.Bearing_Roller_Force;
            
            obj.components{1} = method.Hertz_Contact.Hertz_Contact_Cyclinder2Cyclinder(paramsStruct1, inputStruct1);
            obj.components{1}=obj.components{1}.solve();
            obj.components{2} = method.Hertz_Contact.Hertz_Contact_Cyclinder2Cyclinder(paramsStruct2, inputStruct2);
            obj.components{2}=obj.components{2}.solve();
            
            inputStruct3.Contact_Max_Stress=obj.components{1}.output.Contact_Max_Stress;
            inputStruct3.Contact_Half_Width=obj.components{1}.output.Contact_Half_Width;
            inputStruct3.Relative_Rou=obj.components{1}.output.Relative_Rou;
            inputStruct3.Cal_Depth=obj.input.Cal_Depth;
            inputStruct3.Mu=obj.params.Mu;
            paramsStruct3=struct();
            
            inputStruct4.Contact_Max_Stress=obj.components{2}.output.Contact_Max_Stress;
            inputStruct4.Contact_Half_Width=obj.components{2}.output.Contact_Half_Width;
            inputStruct4.Relative_Rou=obj.components{2}.output.Relative_Rou;
            inputStruct4.Cal_Depth=obj.input.Cal_Depth;
            inputStruct4.Mu=obj.params.Mu;
            paramsStruct4=struct();
            
            obj.components{3} = method.Hertz_Contact.Sub_Surface_Stress(paramsStruct3, inputStruct3);
            obj.components{3}=obj.components{3}.solve();
            obj.components{4} = method.Hertz_Contact.Sub_Surface_Stress(paramsStruct4, inputStruct4);
            obj.components{4}=obj.components{4}.solve();
            
            inputStruct5.Sigma_x=obj.components{3}.output.Sub_Sigma_x;
            inputStruct5.Sigma_y=obj.components{3}.output.Sub_Sigma_y;
            inputStruct5.Sigma_z=0;
            inputStruct5.Tau_xy=obj.components{3}.output.Sub_Tau_xy;
            inputStruct5.Tau_yz=0;
            inputStruct5.Tau_xz=0;
            paramsStruct5=struct();
            
            inputStruct6.Sigma_x=obj.components{4}.output.Sub_Sigma_x;
            inputStruct6.Sigma_y=obj.components{4}.output.Sub_Sigma_y;
            inputStruct6.Sigma_z=0;
            inputStruct6.Tau_xy=obj.components{4}.output.Sub_Tau_xy;
            inputStruct6.Tau_yz=0;
            inputStruct6.Tau_xz=0;
            paramsStruct6=struct();
            
            obj.components{5} = method.Strength_Criterion.Mohr_Circle(paramsStruct5, inputStruct5);
            obj.components{5}=obj.components{5}.solve();
            obj.components{6} = method.Strength_Criterion.Mohr_Circle(paramsStruct6, inputStruct6);
            obj.components{6}=obj.components{6}.solve();
            
            obj.componentExecutionFlag{1} = 'beginningOnly';
            obj.componentExecutionFlag{2} = 'beginningOnly';
            obj.componentExecutionFlag{3} = 'beginningOnly';
            obj.componentExecutionFlag{4} = 'beginningOnly';
            obj.componentExecutionFlag{5} = 'beginningOnly';
            obj.componentExecutionFlag{6} = 'beginningOnly';
        end
        
        function obj = calculateResidual(obj)
            obj.residual = NaN;
        end
        
        function obj = calculateOutput(obj)
            obj.output.IR_Contact_Stress = obj.components{1}.output.Contact_Max_Stress;
            obj.output.IR_Half_Width = obj.components{1}.output.Contact_Half_Width;
            obj.output.IR_Sub_Tau_xy=obj.components{3}.output.Sub_Tau_xy;
            obj.output.IR_Sub_Tau_max=(obj.components{5}.output.Sigma_1-obj.components{5}.output.Sigma_2)/2;
            obj.output.IR_Sub_Sigma_1=obj.components{5}.output.Sigma_1;
            obj.output.IR_Layer_Tau_xy=max(obj.output.IR_Sub_Tau_xy,[],2)-min(obj.output.IR_Sub_Tau_xy,[],2);
            obj.output.IR_Layer_Tau_max=max(obj.output.IR_Sub_Tau_max,[],2);
            obj.output.IR_Layer_Sigma_1=max(obj.output.IR_Sub_Sigma_1,[],2);
            
            obj.output.OR_Contact_Stress = obj.components{2}.output.Contact_Max_Stress;
            obj.output.OR_Half_Width = obj.components{2}.output.Contact_Half_Width;
            obj.output.OR_Sub_Tau_xy=obj.components{4}.output.Sub_Tau_xy;
            obj.output.OR_Sub_Tau_max=(obj.components{6}.output.Sigma_1-obj.components{6}.output.Sigma_2)/2;
            obj.output.OR_Layer_Tau_xy=max(obj.output.OR_Sub_Tau_xy,[],2)-min(obj.output.OR_Sub_Tau_xy,[],2);
            obj.output.OR_Layer_Tau_max=max(obj.output.OR_Sub_Tau_max,[],2);
            obj.output.OR_Sub_Sigma_1=obj.components{6}.output.Sigma_1;
            obj.output.OR_Layer_Sigma_1=max(obj.output.OR_Sub_Sigma_1,[],2);
        end
        
        function componentObj = connect(~,componentObj,~)
            switch class(componentObj)
                case 'method.Hertz_Contact.Hertz_Contact_Cyclinder2Cyclinder'
                    %input passed at instantiation
                case 'method.Hertz_Contact.Sub_Surface_Stress'
                    %input passed at instantiation
                case 'method.Strength_Criterion.Mohr_Circle'
                    %input passed at instantiation
            end
        end
        
        function obj=plotIR_Sub_Stress_2D(obj)
            x=-(0:obj.input.Cal_Depth/obj.components{3}.params.N_Partition_Depth:obj.input.Cal_Depth)';
            y1=obj.output.IR_Layer_Sigma_1;
            y2=obj.output.IR_Layer_Tau_xy;
            y3=obj.output.IR_Layer_Tau_max;
            figure;
            plot(y1,x,'DisplayName','\sigma_1');hold on
            plot(y2,x,'DisplayName','\tau_1');hold on
            plot(y3,x,'DisplayName','\tau_m_a_x');
            
            legend('Location','best')
            xlabel('Stress (Mpa)')
            ylabel('Depth (mm)')
            title('Inner Ring Sub Stress')
        end
        
        function obj=plotOR_Sub_Stress_2D(obj)
            x=-(0:obj.input.Cal_Depth/obj.components{4}.params.N_Partition_Depth:obj.input.Cal_Depth)';
            y1=obj.output.OR_Layer_Sigma_1;
            y2=obj.output.OR_Layer_Tau_xy;
            y3=obj.output.OR_Layer_Tau_max;
            figure;
            plot(y1,x,'DisplayName','\sigma_1');hold on
            plot(y2,x,'DisplayName','\tau_1');hold on
            plot(y3,x,'DisplayName','\tau_m_a_x');
            
            legend('Location','best')
            xlabel('Stress (Mpa)')
            ylabel('Depth (mm)')
            title('Outter Ring Sub Stress')
        end
        
        function obj=plotIR_Sub_Tau_xy_2D(obj)
            
            %Plot
            [x,y] = meshgrid((-obj.output.IR_Half_Width:obj.output.IR_Half_Width/obj.components{3}.params.N_Partition_Width*2:obj.output.IR_Half_Width),...
                (0:-obj.input.Cal_Depth/obj.components{3}.params.N_Partition_Depth:-obj.input.Cal_Depth));
            z=obj.output.IR_Sub_Tau_xy(:,round(obj.components{3}.params.N_Partition_Width/2):1:round(obj.components{3}.params.N_Partition_Width/2*3));
            figure;
            contourf(x,y,z,'LineColor','none');
            colormap('jet');
            xlim([-obj.output.IR_Half_Width,obj.output.IR_Half_Width]);
            ylim([-obj.input.Cal_Depth,0]);
            colormap('jet');
            colorbar;
            xlabel('Width (mm)')
            ylabel('\tau_x_y (Mpa)')
            title('Inner Ring Sub \tau_x_y')
        end
        
        function obj=plotIR_Sub_Sigma_1_2D(obj)
            
            %Plot
            [x,y] = meshgrid((-obj.output.IR_Half_Width:obj.output.IR_Half_Width/obj.components{3}.params.N_Partition_Width*2:obj.output.IR_Half_Width),...
                (0:-obj.input.Cal_Depth/obj.components{3}.params.N_Partition_Depth:-obj.input.Cal_Depth));
            z=obj.output.IR_Sub_Sigma_1(:,round(obj.components{3}.params.N_Partition_Width/2):1:round(obj.components{3}.params.N_Partition_Width/2*3));
            figure;
            contourf(x,y,z,'LineColor','none');
            colormap('jet');
            xlim([-obj.output.IR_Half_Width,obj.output.IR_Half_Width]);
            ylim([-obj.input.Cal_Depth,0]);
            colormap('jet');
            colorbar;
            xlabel('Width (mm)')
            ylabel('\sigma_1 (Mpa)')
            title('Inner Ring Sub \sigma_1')
        end
        
        function obj=plotIR_Sub_Tau_max_2D(obj)
            
            %Plot
            [x,y] = meshgrid((-obj.output.IR_Half_Width:obj.output.IR_Half_Width/obj.components{3}.params.N_Partition_Width*2:obj.output.IR_Half_Width),...
                (0:-obj.input.Cal_Depth/obj.components{3}.params.N_Partition_Depth:-obj.input.Cal_Depth));
            z=obj.output.IR_Sub_Tau_max(:,round(obj.components{3}.params.N_Partition_Width/2):1:round(obj.components{3}.params.N_Partition_Width/2*3));
            figure;
            contourf(x,y,z,'LineColor','none');
            colormap('jet');
            xlim([-obj.output.IR_Half_Width,obj.output.IR_Half_Width]);
            ylim([-obj.input.Cal_Depth,0]);
            colormap('jet');
            colorbar;
            xlabel('Width (mm)')
            ylabel('\tau_max (Mpa)')
            title('Inner Ring Sub \tau_max')
        end
        
        
        
        function obj=plotOR_Sub_Tau_xy_2D(obj)
            
            %Plot
            [x,y] = meshgrid((-obj.output.OR_Half_Width:obj.output.OR_Half_Width/obj.components{4}.params.N_Partition_Width*2:obj.output.OR_Half_Width),...
                (0:-obj.input.Cal_Depth/obj.components{4}.params.N_Partition_Depth:-obj.input.Cal_Depth));
            z=obj.output.OR_Sub_Tau_xy(:,round(obj.components{4}.params.N_Partition_Width/2):1:round(obj.components{4}.params.N_Partition_Width/2*3));
            figure;
            contourf(x,y,z,'LineColor','none');
            colormap('jet');
            xlim([-obj.output.OR_Half_Width,obj.output.OR_Half_Width]);
            ylim([-obj.input.Cal_Depth,0]);
            colormap('jet');
            colorbar;
            xlabel('Width (mm)')
            ylabel('\tau_x_y (Mpa)')
            title('Outer Ring Sub \tau_x_y')
        end
        
        function obj=plotOR_Sub_Sigma_1_2D(obj)
            
            %Plot
            [x,y] = meshgrid((-obj.output.OR_Half_Width:obj.output.OR_Half_Width/obj.components{4}.params.N_Partition_Width*2:obj.output.OR_Half_Width),...
                (0:-obj.input.Cal_Depth/obj.components{4}.params.N_Partition_Depth:-obj.input.Cal_Depth));
            z=obj.output.IR_Sub_Sigma_1(:,round(obj.components{4}.params.N_Partition_Width/2):1:round(obj.components{4}.params.N_Partition_Width/2*3));
            figure;
            contourf(x,y,z,'LineColor','none');
            colormap('jet');
            xlim([-obj.output.OR_Half_Width,obj.output.OR_Half_Width]);
            ylim([-obj.input.Cal_Depth,0]);
            colormap('jet');
            colorbar;
            xlabel('Width (mm)')
            ylabel('\sigma_1 (Mpa)')
            title('Outer Ring Sub \sigma_1')
        end
        
        function obj=plotOR_Sub_Tau_max_2D(obj)
            
            %Plot
            [x,y] = meshgrid((-obj.output.OR_Half_Width:obj.output.OR_Half_Width/obj.components{4}.params.N_Partition_Width*2:obj.output.OR_Half_Width),...
                (0:-obj.input.Cal_Depth/obj.components{4}.params.N_Partition_Depth:-obj.input.Cal_Depth));
            z=obj.output.OR_Sub_Tau_max(:,round(obj.components{4}.params.N_Partition_Width/2):1:round(obj.components{4}.params.N_Partition_Width/2*3));
            figure;
            contourf(x,y,z,'LineColor','none');
            colormap('jet');
            xlim([-obj.output.OR_Half_Width,obj.output.OR_Half_Width]);
            ylim([-obj.input.Cal_Depth,0]);
            colormap('jet');
            colorbar;
            xlabel('Width (mm)')
            ylabel('\tau_max (Mpa)')
            title('Outer Ring Sub \tau_max')
        end
    end
end