classdef Mohr_Circle < Component
    % 3D-Stresses using Mohr's Method
    %% Morh_Circle.m
    % 莫尔圆
    % Author: Yu Xie, Feb 2023

    properties (Hidden, Constant)

        paramsExpectedFields = {

        };

        inputExpectedFields = {
            'Sigma_x' % x方向应力 [Mpa]
            'Sigma_y' % y方向应力 [Mpa]
            'Sigma_z' % z方向应力 [Mpa]
            'Tau_xy' % xy方向剪力 [Mpa]
            'Tau_yz' % yz方向剪力 [Mpa]
            'Tau_xz' % xz方向剪力 [Mpa]

            };

        outputExpectedFields = {
            'Sigma_1' % 第一主应力 [Mpa]
            'Sigma_2' % 第二主应力 [Mpa]
            'Sigma_3' % 第三主应力 [Mpa]
            'Tau_13'  % (sigma_1-sigma_3)/2 [Mpa]
            'Tau_12' % (sigma_1-sigma_2)/2 [Mpa]
            'Tau_23' % (sigma_2-sigma_3)/2 [Mpa]
            };

        baselineExpectedFields = {
            };
    end

    methods
        function obj = Mohr_Circle(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
        end

        function obj = solve(obj)
            sigma_x=obj.input.Sigma_x;
            sigma_y=obj.input.Sigma_y;
            sigma_z=obj.input.Sigma_z;
            tau_xy=obj.input.Tau_xy;
            tau_yz=obj.input.Tau_yz;
            tau_xz=obj.input.Tau_xz;
            %coefficients of Mohr's circle
            [m,n]=size(sigma_x);
            a=ones(m,n);
            b=sigma_x+sigma_y+sigma_z;
            c=sigma_x.*sigma_y+sigma_x.*sigma_z+sigma_y.*sigma_z...
                -tau_xy.^2-tau_yz.^2-tau_xz.^2;
            d=sigma_x.*sigma_y.*sigma_z+2*tau_xy.*tau_yz.*tau_xz...
                -sigma_x.*tau_yz.^2-sigma_y.*tau_xz.^2-sigma_z.*tau_xy.^2;
            %Find Principle stresses
            Temp=mat2cell([reshape(a,m*n,1),reshape(b,m*n,1),reshape(c,m*n,1),reshape(d,m*n,1)],ones(1,m*n));
            normal_stresses=cellfun(@roots,Temp,'UniformOutput',false);
            ordered_normal_stresses=cellfun(@(x)sort(x,'descend'),normal_stresses,'UniformOutput',false);
            ordered_normal_stresses=real(cell2mat(ordered_normal_stresses'));
            obj.output.Sigma_1= reshape(ordered_normal_stresses(1,:)',m,n);
            obj.output.Sigma_2= reshape(ordered_normal_stresses(2,:)',m,n);
            obj.output.Sigma_3= reshape(ordered_normal_stresses(3,:)',m,n);
            obj.output.Tau_13= (obj.output.Sigma_1-obj.output.Sigma_3)/2;
            obj.output.Tau_12 = (obj.output.Sigma_1-obj.output.Sigma_2)/2;
            obj.output.Tau_23= (obj.output.Sigma_2-obj.output.Sigma_3)/2;

        end

        function PlotMohrCircle(obj)
            [m,n]=size(obj.output.Sigma_1);
            if m>1||n>1
                error('画的图太多')
            end
            %Plotting the 3-D Mohr's Circle
            angles=0:0.01:2*pi;
            center1=[(obj.output.Sigma_1+obj.output.Sigma_3)/2 0];
            center2=[(obj.output.Sigma_1+obj.output.Sigma_2)/2 0];
            center3=[(obj.output.Sigma_2+obj.output.Sigma_3)/2 0];
            cirlce1=[center1(1)+obj.output.Tau_13*cos(angles') center1(2)+obj.output.Tau_13*sin(angles')];
            cirlce2=[center2(1)+obj.output.Tau_12*cos(angles') center2(2)+obj.output.Tau_12*sin(angles')];
            cirlce3=[center3(1)+obj.output.Tau_23*cos(angles') center3(2)+obj.output.Tau_23*sin(angles')];

            plot(cirlce1(:,1),cirlce1(:,2),'b',cirlce2(:,1),cirlce2(:,2),'g',...
                cirlce3(:,1),cirlce3(:,2),'r');axis equal;grid on;
            %ANNOTATIONS
            if obj.output.Sigma_1>0
                text(obj.output.Sigma_1*1.01,0,'\sigma_1','fontsize',15);
            else
                text(obj.output.Sigma_1*0.95,0,'\sigma_1','fontsize',15)
            end
            if obj.output.Sigma_2>0
                text(obj.output.Sigma_2*1.1,0,'\sigma_2','fontsize',15)
            else
                text(obj.output.Sigma_2*0.99,0,'\sigma_2','fontsize',15)
            end
            if obj.output.Sigma_3>0
                text(obj.output.Sigma_3*1.1,0,'\sigma_3','fontsize',15);
            else
                text(obj.output.Sigma_3*0.99,0,'\sigma_3','fontsize',15);
            end

            text(center1(1),obj.output.Tau_13*0.9,'\tau_1','fontsize',15)
            text(center2(1),obj.output.Tau_12*0.9,'\tau_2','fontsize',15)
            text(center3(1),obj.output.Tau_23*0.9,'\tau_3','fontsize',15);
            xlabel('Normal Stress, \sigma','fontsize',15);
            ylabel('Shear Stess, \tau','fontsize',15)
        end
    end
end