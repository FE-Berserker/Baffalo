classdef CylindricalRollerBearing < Component
    % 滚子轴承类,无内外圈
    % Modify_Method=0 无修形
    % Modify_Method=1 ISO 16281默认修形方法
    % Modify_Method=2 相切圆弧
    % Modify_Method=3

    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % 材料属性，默认为铁
            'N_Slice' % 切片数量
            'Name' % 名称
            'Echo'
            'Modify_Method' % 滚子修形方法
            'Modify_Opt' % 滚子修形参数
            'ROTX' % 旋转角度
            'allowable' % 最大许用接触应力 [Mpa]
            'e' % 威布尔斜率
            'c' %常数c
            'h' % 常数h
            'bm' % ISO bm系数
            'Stiffness_Method' % 滚子刚度计算方法 0: ISO 16281 1: Palmgren 2: 罗继伟
            'isInnerRing' % 内圈是否存在
            'isOuterRing' % 外圈是否存在
            'isInnerRid' % 内圈挡边是否存在
            'isOuterRid' % 外圈挡边是否存在
            'Pd0'% 轴承配合 [mm] +表示游隙 -表示预紧
            'T_Ref'% 参考温度
            'Temp'% 轴承温差
            'U'%内外圈配合
            'Dil'% 轴内径 [mm]
            'DaA'% 轴承座外径 [mm]
            'eps'% 定义残差限值
            'max_iter'% 最大迭代次数

            };
        
        inputExpectedFields = {
            'Z' % 滚子数量 [mm]
            'L' % 滚子长度 [mm]
            'r' % 滚子倒角 [mm]
            'Di' % 轴承内径 [mm]
            'Do' % 轴承外径 [mm]
            'Dpw'% 轴承分度圆直径 [mm]
            'Dw' % 轴承滚子直径 [mm]
            'T' % 轴承宽度 [mm]
            'C' % 外圈宽度 [mm]
            'B' % 内圈宽度 [mm]
            'D1' % 外圈挡边直径 [mm]
            'd1' % 内圈挡边直径 [mm]
            'i' % 滚子列数
            'Fy' % 轴承y方向力 [N]
            'Fz' % 轴承z方向力 [N]
            'Uy' % 轴承y方向变形 [mm]
            'Uz' % 轴承z方向变形 [mm]
            };
        
        outputExpectedFields = {
            'Roller_point'% 滚子节点
            'Base_Stiffness'
            'Roller_Stiffness' % 滚子刚度
            'Spring_Stiffness1'% 滚子弹簧刚度 [N/mm]
            'Spring_Stiffness2'% 滚子弹簧刚度 [N/mm] to ANSYS
            'Lwe' % 滚子有效计算长度 [mm]
            'Co'% 计算C0 [N]
            'Cr'% 计算Cr [N]
            'Delta_y'% 轮廓修形量 [mm]
            'Surface'% 轴承截面
            'Assembly' % 装配体
            'Roller_Force' % 轴承滚子反力 [N]
            'Roller_Delta' % 轴承滚子位移 [mm]
            'Bearing_Force' % 轴承反力 [N]
            'Bearing_Displacement' % 轴承位移 [mm]
            'Pd'%轴承游隙 [mm]
            'Modify_Par'% 滚子修形参数，如果指定了修形参数，输出参数即和输入一致
            };
        
        baselineExpectedFields = {};
        default_N_Slice=105;
        default_Name='Cylindrical_Roller_Bearing1'
        default_Echo=1
        default_Modify_Method=1;% 默认滚子按照对数修形
        default_Modify_Opt=[];% 默认根据力的大小计算修形
        default_allowable=4000;
        default_Stiffness_Method=0;
        default_ROTX=0;
        default_e=9/8;
        default_c=31/3;
        default_h=7/3;
        default_bm=1.3;
        default_isInnerRing=1;
        default_isOuterRing=1;
        default_isInnerRid=[0,0];
        default_isOuterRid=[0,0];
        default_Material=[];
        default_Pd0=0;
        default_Temp=[20,20];% 外圈温度，内圈温度
        default_T_Ref=20;
        default_U=[0,0]% 默认内圈和外圈配合为0
        default_Dil=0;
        default_DaA=[];
        default_eps=1e-3;
        default_max_iter=1000;
    end
    methods
        
        function obj = CylindricalRollerBearing(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='CylindricalRollerBearing.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            %calculate outputs
            obj.output.Lwe=obj.input.L-2*obj.input.r;
            obj.output.Surface=CreateS(obj);
            obj.output.Co=Cal_Co(obj);
            obj.output.Cr=Cal_Cr(obj);

            Temp_step2=obj.output.Lwe/obj.params.N_Slice;
            obj.output.Roller_point.x1=(-obj.output.Lwe/2+Temp_step2/2:Temp_step2:obj.output.Lwe/2-Temp_step2/2);
            obj.output.Roller_point.y1=ones(1,obj.params.N_Slice)*obj.input.Dpw/2-obj.input.Dw/2;
            obj.output.Roller_point.x2=(-obj.output.Lwe/2+Temp_step2/2:Temp_step2:obj.output.Lwe/2-Temp_step2/2);
            obj.output.Roller_point.y2=ones(1,obj.params.N_Slice)*obj.input.Dpw/2+obj.input.Dw/2;

            [Pd,Pd_0,Pd_T,Pd_f] = Cal_Pd(obj);
            obj.output.Pd=[Pd,Pd_0,Pd_T,Pd_f];

            obj.output.Base_Stiffness=Cal_Base_Stiffness(obj);

            if or(~isempty(obj.input.Uy),~isempty(obj.input.Uz))
                [Roller_Delta,Matrix,Bearing_Displacement] = Cal_Roller_U(obj);%计算滚子位移
                obj.output.Base_Stiffness=Cal_Base_Stiffness(obj);
                [Delta_y,obj.output.Modify_Par]=Cal_Modify(obj,Roller_Delta,obj.params.Modify_Method,obj.params.Modify_Opt);%计算修形量
                [Slice_Stiffness,Roller_Stiffness]=Cal_Roller_Stiffness(obj,Delta_y);
                Roller_Force=Cal_Roller_F(obj,Roller_Stiffness,Roller_Delta);%计算滚子反力
                Bearing_Force=Roller_Force'*Matrix;
            elseif or(~isempty(obj.input.Fy),~isempty(obj.input.Fz))
                if isempty(obj.input.Fy)
                    Fy=0;
                else
                    Fy=obj.input.Fy;
                end
                if isempty(obj.input.Fz)
                    Fz=0;
                else
                    Fz=obj.input.Fz;
                end
                sol_tol=norm([0,Fy,Fz],2);
                var_iter=1;
                if Fy>=0
                    obj.input.Uy=interp1(-obj.output.Base_Stiffness(:,2),-obj.output.Base_Stiffness(:,1),Fy/obj.input.Z);
                else
                    obj.input.Uy=interp1(obj.output.Base_Stiffness(:,2),obj.output.Base_Stiffness(:,1),Fy/obj.input.Z);
                end
                if Fz>=0
                    obj.input.Uz=interp1(-obj.output.Base_Stiffness(:,2),-obj.output.Base_Stiffness(:,1),Fz/obj.input.Z);
                else
                    obj.input.Uz=interp1(obj.output.Base_Stiffness(:,2),obj.output.Base_Stiffness(:,1),Fz/obj.input.Z);
                end

                Step_Uy=obj.input.Uy*5;
                Step_Uz=obj.input.Uz*5;
                while abs(sol_tol) > obj.params.eps && var_iter < obj.params.max_iter

                    [Roller_Delta,Matrix,Bearing_Displacement] = Cal_Roller_U(obj);%计算滚子位移
                    obj.output.Base_Stiffness=Cal_Base_Stiffness(obj);
                    [Delta_y,obj.output.Modify_Par]=Cal_Modify(obj,Roller_Delta,obj.params.Modify_Method,obj.params.Modify_Opt);%计算修形量
                    [Slice_Stiffness,Roller_Stiffness]=Cal_Roller_Stiffness(obj,Delta_y);
                    Roller_Force=Cal_Roller_F(obj,Roller_Stiffness,Roller_Delta);%计算滚子反力
                    Bearing_Force=Roller_Force'*Matrix;


                    var_iter=var_iter+1;
                    sol_tol=norm(Bearing_Force-[Fy,Fz],2);

                    obj.input.Uy=(obj.input.Uy+Step_Uy)*((abs(Fy)-abs(Bearing_Force(1)))>0)...
                        +(obj.input.Uy-Step_Uy)*((abs(Fy)-abs(Bearing_Force(1)))<=0);
                    obj.input.Uz=(obj.input.Uz+Step_Uz)*((abs(Fz)-abs(Bearing_Force(2)))>0)...
                        +(obj.input.Uz-Step_Uz)*((abs(Fz)-abs(Bearing_Force(2)))<=0);

                    Step_Uy=Step_Uy*((Fy-Bearing_Force(1))>0)...
                        +Step_Uy/2*((Fy-Bearing_Force(1))<=0);
                    Step_Uz=Step_Uz*((Fz-Bearing_Force(2))>0)...
                        +Step_Uz/2*((Fz-Bearing_Force(2))<=0);
                end
            else
                obj.input.Uy=0;
                obj.input.Uz=0;
                [Roller_Delta,Matrix,Bearing_Displacement] = Cal_Roller_U(obj);%计算滚子位移
                obj.output.Base_Stiffness=Cal_Base_Stiffness(obj);
                [Delta_y,obj.output.Modify_Par]=Cal_Modify(obj,Roller_Delta,obj.params.Modify_Method,obj.params.Modify_Opt);%计算修形量
                [Slice_Stiffness,Roller_Stiffness]=Cal_Roller_Stiffness(obj,Delta_y);
                Roller_Force=Cal_Roller_F(obj,Roller_Stiffness,Roller_Delta);%计算滚子反力
                Bearing_Force=Roller_Force'*Matrix;

            end

            obj.output.Roller_Stiffness=Roller_Stiffness;
            obj.output.Spring_Stiffness1=Slice_Stiffness;
            obj.output.Roller_Force=Roller_Force;
            obj.output.Delta_y=Delta_y;
            obj.output.Roller_Delta=Roller_Delta;
            obj.output.Bearing_Force=Bearing_Force;
            obj.output.Bearing_Displacement=Bearing_Displacement;
            obj.output.Spring_Stiffness2=Cal_Spring_Stiffness(obj);


            % 材料设置
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            obj=OutputAss(obj);
        end
    end
end