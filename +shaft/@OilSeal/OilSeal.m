classdef OilSeal < Component
    % 骨架油封类
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Name' % 名称
            'Pressure' %油封唇口径向压力 [Mpa]
            'Rou' % 润滑油密度 [t/mm3]
            'Vis' % 润滑油运动粘度 [mm2/s]
            'Method' % Method=1 AGMA ISO 14179-1 Method=2 NOK                    
            };
        
        inputExpectedFields = {
            'Length' % 油封长度 [mm]
            'ID' % 油封内径 [mm]
            'OD' % 油封外径 [mm]
            'Rot_Speed' % 轴转速 [rpm]
            'Fr' % 唇口径向力
            };
        
        outputExpectedFields = {
            'Node'% 输出Node
            'ID'% 输出内径
            'OD'% 输出外径
            'Ts'% 油封摩擦扭矩 [Nmm]
            'Line_Velocity' % 油封线速度 [mm/s]
            'f'% 唇口摩擦系数
            'G' % 参数G
            'T2' % 唇口温升
            };
        baselineExpectedFields = {
            };
        
        statesExpectedFields = {};
        default_Name='Oilsea_1l';
        default_Pressure=0.03;
        default_Vis=40;
        default_Rou=0.9e-9;
        default_Method=1;
        
    end
    methods
        
        function obj = OilSeal(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='OilSeal.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            obj=cal_velocity(obj);
            switch obj.params.Method
                case 1
                    obj=cal_torque1(obj);
                case 2
                    obj=cal_torque2(obj);
            end
            obj=cal_T2(obj);

        end
        
        function obj=plot2D(obj)
            A=Point2D('Point1','Echo',0);
            x=0;y=0;
            A=AddPoint(A,x,y);
            B1=Line2D('r1','Echo',0);
            B2=Line2D('r2','Echo',0);
            B1=AddCircle(B1,obj.input.OD/2,A,1);
            B2=AddCircle(B2,obj.input.ID/2,A,1);
            C=Surface2D(B1);
            C=AddHole(C,B2);
            Plot(C,'color',[0 0 0]);
        end
        

        function obj=cal_velocity(obj)
            obj.output.Line_Velocity=obj.input.Rot_Speed/60*2*pi*obj.input.ID/2;
        end

        function obj=cal_torque1(obj)
            obj.output.Ts=2.429*obj.input.ID;
        end

        function obj=cal_torque2(obj)
            if obj.input.Rot_Speed>1500
                error('Exceed the RPM limit')
            end
            if isempty(obj.input.Fr)
                obj.input.Fr=obj.params.Pressure*pi*obj.input.ID*2;
            end
            obj.output.G=cal_G(obj);
            Temp=obj.output.G^(1/3);
            obj.output.f=0.15.*(Temp<0.029)+(51.11*(Temp-0.0029)+0.15).*(Temp>=0.0029);
            obj.output.Ts=obj.output.f*obj.input.ID/2*obj.input.Fr;
        end

        function value=cal_G(obj)
            v=obj.input.Rot_Speed/60*obj.input.ID/2*2*pi;
            Dynamic_Vis=obj.params.Rou*obj.params.Vis;
            Temp=1/(obj.params.Pressure*pi*obj.input.ID)/10;
            value=v*Dynamic_Vis*Temp;
        end

        function obj=cal_T2(obj)
            x=[500;1500;3000;6000];
            a=[0.4146;1.285;1.815;1.972];
            b=[0.5785;0.477;0.4927;0.6023];
            aa=interp1(x,a,obj.input.Rot_Speed,'spline');
            bb=interp1(x,b,obj.input.Rot_Speed,'spline');
            obj.output.T2=aa*obj.input.ID^bb;
        end
        
    end
end