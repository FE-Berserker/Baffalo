classdef WormGear < Component
    % WormGear
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Echo' % Print
            'Name'
            'Material'% 1. Worm material 2. Wheel material
            'Order'
            'h_fp' % 齿根高系数
            'rho_fp'% 齿根半径系数
            'h_ap' % 齿顶高系数
            'Type' % 1.齿轮基准齿廓 2. 滚刀无切顶  3.滚刀含切顶
            'Lsize1'% Worm solid mesh line esize
            'Lsize2'% Wheel solid mesh line esize
            'NWidth1' % Worm solid mesh gear width segment
            'NWidth2' % Wheel solid mesh gear width segment
            'Helix' % Right, Left
            'H' % Required service life [h]
            'KA' % Application factor
            };
        
        inputExpectedFields = {
            'mx' % 轴向模数 [mm]
            'alphan' % 压力角 [°]
            'ID1' % 蜗杆内径 [mm]
            'ID2' % 涡轮内径 [mm]
            'Z1' % 蜗杆头数
            'Z2' % 蜗轮齿数
            'b1'
            'b2H' % 齿宽 [mm]
            'x' % 变位系数
            'a' % 中心距 [mm]
            'Tool' % 刀具参数
            'P1' % 蜗杆功率 [kW]
            'P2' % 蜗轮功率 [kW]
            'T1' % 蜗杆扭矩 [Nm]
            'T2' % 蜗轮扭矩 [Nm]
            'n1' % 蜗杆转速 [RPM]
            'n2' % 蜗轮转速 [RPM]
            'PV0'
            'PVLP'
            };
        
        outputExpectedFields = {  
            'i' % 速比
            'q' % 直径系数
            'gamma' % 导程角 [°]
            'pz' % 导程 [mm]
            'xt' % 端面变位系数
            'mt' % 端面模数 [mm]
            'mn' % 法向模数 [mm]
            'alphat' % 端面压力角 [°]
            'cp' % 顶隙系数
            'd1' % 蜗杆分度圆直径 [mm]
            'd2' % 蜗轮分度圆直径 [mm]
            'd2b' % 蜗轮基圆直径 [mm]
            'd2a' % 齿顶圆直径 [mm]
            'd2f' % 齿根圆直径 [mm]
            'h' % 齿高 [mm]
            'ha' % 齿顶高 [mm]
            'hf' % 齿根高 [mm]
            'Worm' % 蜗杆参数
            'WormCurve' % 蜗杆曲线
            'WheelCurve' % 蜗轮曲线
            'WheelSolidMesh' % Wheel solid mesh with tooth
            'WormSolidMesh' % Worm solid mesh with tooth
            'Surface'
            'SpringStiffness' % SpringStiffness
            'Assembly' % Solid mesh assembly
            'Assembly1' % Solid mesh assembly1

            };
        baselineExpectedFields = {}
        
        default_Name='WormGear_1'
        default_Material=[];
        default_Order=1;
        default_Type=1;
        default_Echo=1;
        default_h_fp=1.2;
        default_rho_fp=0.2;
        default_h_ap=1;
        default_Lsize1=[40;12;6]
        default_Lsize2=[32;8;4]
        default_NWidth1=40;
        default_NWidth2=10;
        default_Helix='Right'
        default_H=25000;
        default_KA=1;

    end
    methods
        
        function obj = WormGear(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='WormGear.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            %calculate outputs
            if isempty(obj.params.Material)
                S=RMaterial('Gear');
                mat=GetMat(S,[32;38]);
                obj.params.Material=mat;
            end

            if isempty(obj.input.x)
                obj.input.x=0;
            end

            a=obj.input.a;
            mx=obj.input.mx;
            Z1=obj.input.Z1;
            Z2=obj.input.Z2;

            d1=2*a-mx*Z2;
            gamma=atan(mx*Z1/d1)/pi*180;
            q=Z1/tan(gamma/180*pi);
            mn=mx*cos(gamma/180*pi);
            mt=mn/sin(gamma/180*pi);
            pz=pi*d1*tan(gamma/180*pi);
            i=(2*a-d1)/mx/Z1;

            if ~isempty(obj.input.n1)
                obj.input.n2=obj.input.n1/i;
            elseif ~isempty(obj.input.n2)
                obj.input.n1=obj.input.n2*i;
            else
                error('Please input speed !')
            end

            inputSingleGear.mn= mn;
            inputSingleGear.alphan = obj.input.alphan;
            inputSingleGear.Z=obj.input.Z2;
            inputSingleGear.b=obj.input.b2H;
            inputSingleGear.x=obj.input.x;
            inputSingleGear.beta=gamma;
            inputSingleGear.Tool=obj.input.Tool;
            inputSingleGear.ID=obj.input.ID2;
            paramsingleGear.Name = obj.params.Name;
            paramsingleGear.Echo=0;
            paramsingleGear.Material=obj.params.Material{2,1};
            paramsingleGear.Order=obj.params.Order;
            paramsingleGear.h_fp=obj.params.h_fp;
            paramsingleGear.rho_fp=obj.params.rho_fp;
            paramsingleGear.h_ap=obj.params.h_ap;
            paramsingleGear.Type=obj.params.Type;
            paramsingleGear.Lsize2=obj.params.Lsize2;
            paramsingleGear.NWidth=obj.params.NWidth2;
            paramsingleGear.Helix=obj.params.Helix;

            obj1=gear.SingleGear(paramsingleGear, inputSingleGear);
            obj1=obj1.solve();

            % Idle running power loss
            n1=obj.input.n1;
            if isempty(obj.input.PV0)
                PV0=0.89e-4*a*n1^(4/3)/1000;
                obj.input.PV0=PV0;
            end

            d2=obj1.output.d;

            if or(~isempty(obj.input.P1),~isempty(obj.input.T1))
                if ~isempty(obj.input.P1)
                    obj.input.T1=obj.input.P1*60/2/pi*1000/obj.input.n1;
                else
                    obj.input.P1=obj.input.T1/60*2*pi/1000*obj.input.n1;
                end
                T1=obj.input.T1;
                Ftm1=T1/d1*2000;

            elseif or(~isempty(obj.input.P2),~isempty(obj.input.T2))
                if ~isempty(obj.input.P2)
                    obj.input.T2=obj.input.P2*60/2/pi*1000/obj.input.n2;
                else
                    obj.input.P2=obj.input.T2/60*2*pi/1000*obj.input.n2;
                end
                T2=obj.input.T2;
                Ftm2=T2/d2*2000;
            else
                error('Please input power or torque!')
            end

            if isempty(obj.input.PVLP)
                PV0=0.89e-4*a*n1^(4/3)/1000;
                obj.input.PV0=PV0;
            end

            % Parse
            obj.output.i=i;
            obj.input.ID2=obj1.input.ID;
            obj.output.q=q;
            obj.output.gamma=gamma;
            obj.output.pz=pz;
            obj.output.xt=obj1.output.xt;
            obj.output.mt=mt;
            obj.output.mn=mn;
            obj.output.alphat=obj1.output.alphat;
            obj.output.cp=obj1.output.cp;
            obj.output.d2b=obj1.output.db;
            obj.output.d1=d1;
            obj.output.d2=d2;
            obj.output.d2a=obj1.output.da;
            obj.output.d2f=obj1.output.df;
            obj.output.h=obj1.output.h;
            obj.output.ha=obj1.output.ha;
            obj.output.hf=obj1.output.hf;
            obj.output.Worm=obj1.output.Tool;
            obj.output.WormCurve=obj1.output.ToolCurve;
            obj.output.WheelCurve=obj1.output.GearCurve;
            obj.output.WheelSolidMesh=obj1.output.SolidMesh;

            % Build worm gear surface
            obj=BuildSurface(obj);

            % Output worm solid mehs
            obj=OutputWormSolidModel(obj);

            % Ouput Assembly
            obj=OutputAss(obj);

            % Estimate Stiffness
            obj=EstimateStiff(obj);

            % Ouput Assembly
            obj=OutputAss1(obj);
           
        end
        
        function obj=Plot2D(obj)
            Plot(obj.output.Surface,'View',[0,90],'edge_alpha',0);     
        end
        
    end
end