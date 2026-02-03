classdef RectangularRubberStack < Component
    % RectangularRubberStack - 矩形橡胶堆设计组件
    % Author: Xie Yu
    % Date: 2026-02-02
    %
    % 功能:
    %   - 矩形橡胶堆垂向刚度计算
    %   - 矩形橡胶堆水平方向刚度计算（剪切+弯曲）
    %   - 形状系数和稳定性约束校核
    %   - 刚度安全系数校核

    properties(Hidden, Constant)

        % Input 预期字段
        inputExpectedFields = {
            'Kz_target'      % 目标垂向刚度 (N/mm)
            'Kx_target'      % 目标x向水平总刚度 (N/mm)
            'Ky_target'      % 目标y向水平总刚度 (N/mm)
            'Fz_max'         % 最大垂向载荷 (N)
            'Fx_max'         % 最大x向水平力 (N)
            'Fy_max'         % 最大y向水平力 (N)
            'n'              % 橡胶层数
            'a'              % 矩形橡胶长边 (mm)
            'b'              % 矩形橡胶短边 (mm)
            'h'              % 每层橡胶原有高度 (mm)
            't_plate_mid'    % 中间隔层钢板厚度 (mm)
            't_plate_end'    % 端板厚度 (mm)
            'a_max'          % 长边最大允许尺寸 (mm)
            'b_max'          % 短边最大允许尺寸 (mm)
            };

        % Output 预期字段
        outputExpectedFields = {
            'Ac'             % 橡胶承载面积 (mm²)
            'S'              % 形状因子 (面积比)
            'mu1'            % 垂向形状系数
            'Kz_calc'        % 计算垂向总刚度 (N/mm)
            'Jx'             % x向剪切形状系数
            'Jy'             % y向剪切形状系数
            'Kx_shear'       % x向剪切刚度 (N/mm)
            'Ky_shear'       % y向剪切刚度 (N/mm)
            't'              % 橡胶堆计算高度 (mm)
            'Krx'            % x向回转半径 (mm)
            'Kry'            % y向回转半径 (mm)
            'G_prime'        % x向橡胶计算剪切模数 (MPa)
            'G_double_prime' % y向橡胶计算剪切模数 (MPa)
            'xb'             % x向弯曲挠度 (mm)
            'yb'             % y向弯曲挠度 (mm)
            'Kbx'            % x向弯曲刚度 (N/mm)
            'Kby'            % y向弯曲刚度 (N/mm)
            'Kx_total'       % x向水平总刚度 (N/mm)
            'Ky_total'       % y向水平总刚度 (N/mm)
            'H0'             % 橡胶堆自由高度 (mm)
            'compression_strain' % 压缩应变
            'Assembly'       % FEM装配模型
            'RubberProperty' % 橡胶材料属性
            };

        % Params 预期字段
        paramsExpectedFields = {
            'HS'             % 橡胶硬度
            'Material'       % 平板材料属性
            'Name'           % 矩形橡胶堆设计组件名称
            'Echo'           % 是否输出计算过程
            'Ratio'          % 橡胶层的收缩率，按照厚度计算
            };

        % Baseline 预期字段
        baselineExpectedFields = {
            'min_Kz_ratio'          % 垂向刚度安全系数最低要求
            'min_Kx_ratio'          % x向水平刚度安全系数最低要求
            'min_Ky_ratio'          % y向水平刚度安全系数最低要求
            'max_compression_strain'% 最大允许压缩应变
            'max_h_to_a_ratio'      % 最大h/a比值约束
            };

        % Params 默认值
        default_HS = 60;                  % 邵氏硬度
        default_Echo = 1;
        default_Material = [];
        default_Name = 'RectangularRubberStack_1'
        default_Ratio=0.5

        % Baseline 默认值
        base_min_Kz_ratio = 1.0;
        base_min_Kx_ratio = 1.0;
        base_min_Ky_ratio = 1.0;
        base_max_compression_strain = 0.15;    % 最大压缩应变15%
        base_max_h_to_a_ratio = 0.2;            % h <= a/5

    end

    methods

        function obj = RectangularRubberStack(paramsStruct, inputStruct, varargin)
            % 构造函数
            obj = obj@Component(paramsStruct, inputStruct, varargin);
            obj.documentname = 'RectangularRubberStack.pdf';
        end

        function obj = solve(obj)

            % 检出输入

            Check(obj);

            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            % 核心计算方法

            if obj.params.Echo
                disp('==========================================');
                disp('  矩形橡胶堆设计计算开始');
                disp('==========================================');
                disp(' ');
            end

            % 0. 使用RubberProperty计算材料属性
            if obj.params.Echo
                disp('--- 橡胶材料属性计算 ---');
            end
            rubberProp = method.Rubber.RubberProperty(...
                struct('Echo', obj.params.Echo, 'Name', 'RectangularRubberStack_RubberProperty'), ...
                struct('HS', obj.params.HS));
            rubberProp = rubberProp.solve();
            % 将计算得到的E和G存储到output中供后续使用
            obj.output.RubberProperty=rubberProp;

            if obj.params.Echo
                fprintf('  橡胶硬度 HS = %d\n', obj.params.HS);
                fprintf('  杨氏弹性模数 E = %.2f MPa\n', rubberProp.output.E);
                fprintf('  剪切模数 G = %.2f MPa\n\n', rubberProp.output.G);
            end

            % 1. 垂向刚度计算
            obj = obj.calculateVerticalStiffness();

            % 2. 水平方向刚度计算
            obj = obj.calculateHorizontalStiffness();

            % 3. 稳定性校核
            obj = obj.checkStability();

            % 4. 刚度安全系数计算
            obj = obj.calculateStiffnessSafetyFactors();

            % 5. 创建装配模型
            obj = obj.OutputAss();

            if obj.params.Echo
                disp('==========================================');
                disp('  计算完成');
                disp('==========================================');
                disp(' ');
            end
        end

        function obj = calculateVerticalStiffness(obj)
            % 计算垂向刚度
            % 单位: 长度mm, 应力MPa(N/mm²), 刚度N/mm

            if obj.params.Echo
                disp('--- 垂向刚度计算 ---');
            end

            % 1. 计算橡胶承载面积 (mm²)
            Ac = obj.input.a * obj.input.b;
            obj.output.Ac = Ac;

            % 2. 计算面积比（形状因子）
            % S = Ac / (2*(a+b)*h)
            S = Ac / (2 * (obj.input.a + obj.input.b) * obj.input.h);
            obj.output.S = S;

            % 3. 计算垂向形状系数
            mu1 = 1 + 2.2 * S^2;
            obj.output.mu1 = mu1;

            % 4. 计算垂向总刚度 (N/mm)
            % Kz = Ac * mu1 * E / (n * h)
            % E单位MPa(N/mm²), Ac单位mm², h单位mm -> Kz单位N/mm
            E=obj.output.RubberProperty.output.E;
            Kz_calc = (Ac * mu1 * E) / (obj.input.n * obj.input.h);
            obj.output.Kz_calc = Kz_calc;

            % 5. 计算自由高度（用于稳定性校核）(mm)
            % H0 = n * h + (n-1) * t_plate_mid + 2*t_plate_end
            % 实际上需要根据钢板数量计算，这里简化处理
            obj.output.H0 = obj.input.n * obj.input.h +...
                (obj.input.n-1) * obj.input.t_plate_mid+...
                2*obj.input.t_plate_end;

            if obj.params.Echo
                fprintf('  承载面积 Ac = %.2f mm²\n', Ac);
                fprintf('  形状因子 S = %.4f\n', S);
                fprintf('  垂向形状系数 μ1 = %.4f\n', mu1);
                fprintf('  杨氏弹性模数 E = %.2f MPa\n', E);
                fprintf('  计算垂向刚度 Kz = %.2f N/mm\n\n', Kz_calc);
            end
        end

        function obj = calculateHorizontalStiffness(obj)
            % 计算水平方向刚度（剪切+弯曲串联）

            if obj.params.Echo
                disp('--- 水平方向刚度计算 ---');
            end

            % 1. 剪切刚度计算
            obj = obj.calculateShearStiffness();

            % 2. 弯曲刚度计算
            obj = obj.calculateBendingStiffness();

            % 3. 水平总刚度计算（剪切与弯曲刚度串联）
            % K_total = K_shear * K_bend / (K_shear + K_bend)
            Kx_total = (obj.output.Kx_shear * obj.output.Kbx) / ...
                       (obj.output.Kx_shear + obj.output.Kbx);
            Ky_total = (obj.output.Ky_shear * obj.output.Kby) / ...
                       (obj.output.Ky_shear + obj.output.Kby);

            obj.output.Kx_total = Kx_total;
            obj.output.Ky_total = Ky_total;

            if obj.params.Echo
                fprintf('  x向水平总刚度 Kx = %.2f N/mm\n', Kx_total);
                fprintf('  y向水平总刚度 Ky = %.2f N/mm\n\n', Ky_total);
            end
        end

        function obj = calculateShearStiffness(obj)
            % 计算剪切刚度
            % 单位: 长度mm, 应力MPa(N/mm²), 刚度N/mm

            Ac = obj.output.Ac;
            h = obj.input.h;
            n = obj.input.n;
            G = obj.output.RubberProperty.output.G;
            a = obj.input.a;
            b = obj.input.b;

            % x向剪切刚度 (N/mm)
            % J(x) = 1 / (1 + 0.29 * (h/a)^2)
            Jx = 1 / (1 + 0.29 * (h/a)^2);
            Kx_shear = (Ac * Jx * G) / (n * h);
            obj.output.Jx = Jx;
            obj.output.Kx_shear = Kx_shear;

            % y向剪切刚度 (N/mm)
            % J(y) = 1 / (1 + 0.29 * (h/b)^2)
            Jy = 1 / (1 + 0.29 * (h/b)^2);
            Ky_shear = (Ac * Jy * G) / (n * h);
            obj.output.Jy = Jy;
            obj.output.Ky_shear = Ky_shear;

            if obj.params.Echo
                fprintf('  剪切刚度计算:\n');
                fprintf('    剪切模数 G = %.2f MPa\n', G);
                fprintf('    x向剪切形状系数 Jx = %.4f\n', Jx);
                fprintf('    x向剪切刚度 Kx_shear = %.2f N/mm\n', Kx_shear);
                fprintf('    y向剪切形状系数 Jy = %.4f\n', Jy);
                fprintf('    y向剪切刚度 Ky_shear = %.2f N/mm\n', Ky_shear);
            end
        end

        function obj = calculateBendingStiffness(obj)
            % 计算弯曲刚度
            % 单位: 长度mm, 应力MPa(N/mm²), 刚度N/mm

            Ac = obj.output.Ac;
            h = obj.input.h;
            n = obj.input.n;
            G = obj.output.RubberProperty.output.G;
            a = obj.input.a;
            b = obj.input.b;
            Fx = obj.input.Fx_max;
            Fy = obj.input.Fy_max;

            % 1. 计算橡胶堆计算高度 (mm)
            % t = h * n + 0.3 * 钢板总厚度
            t_plate_total = (obj.input.n-1) * obj.input.t_plate_mid + 2 * obj.input.t_plate_end;
            t = h * n + 0.3 * t_plate_total;
            obj.output.t = t;

            % 2. 计算回转半径 (mm)
            Krx = sqrt(a^2 / 12);
            Kry = sqrt(b^2 / 12);
            obj.output.Krx = Krx;
            obj.output.Kry = Kry;

            % 3. 计算橡胶计算剪切模数 (MPa)
            G_prime = G / (1 + t^2 / (36 * Krx^2));
            G_double_prime = G / (1 + t^2 / (36 * Kry^2));
            obj.output.G_prime = G_prime;
            obj.output.G_double_prime = G_double_prime;

            % 4. 计算弯曲挠度 (mm)
            xb = (Fx * t^3) / (36 * Ac * G_prime * Krx^2);
            yb = (Fy * t^3) / (36 * Ac * G_double_prime * Kry^2);
            obj.output.xb = xb;
            obj.output.yb = yb;

            % 5. 计算弯曲刚度 (N/mm)
            Kbx = Fx / xb;
            Kby = Fy / yb;
            obj.output.Kbx = Kbx;
            obj.output.Kby = Kby;

            if obj.params.Echo
                fprintf('  弯曲刚度计算:\n');
                fprintf('    计算高度 t = %.2f mm\n', t);
                fprintf('    x向回转半径 Krx = %.2f mm\n', Krx);
                fprintf('    y向回转半径 Kry = %.2f mm\n', Kry);
                fprintf('    x向计算剪切模数 G'' = %.2f MPa\n', G_prime);
                fprintf('    y向计算剪切模数 G'''' = %.2f MPa\n', G_double_prime);
                fprintf('    x向弯曲刚度 Kbx = %.2f N/mm\n', Kbx);
                fprintf('    y向弯曲刚度 Kby = %.2f N/mm\n', Kby);
            end
        end

        function obj = checkStability(obj)
            % 稳定性校核

            if obj.params.Echo
                disp('--- 稳定性校核 ---');
            end

            % 1. 压缩应变校核
            Fz = obj.input.Fz_max;
            Kz = obj.output.Kz_calc;
            H0 = obj.output.H0;

            if Kz > 0
                delta_z = Fz / Kz;
                compression_strain = delta_z / H0;
                obj.output.compression_strain = compression_strain;
            else
                compression_strain = 0;
                obj.output.compression_strain = 0;
            end

            % 2. h/a比值校核
            h_to_a_ratio = obj.input.h / obj.input.a;

            if obj.params.Echo
                fprintf('  压缩应变: %.2f%%\n', compression_strain * 100);
                fprintf('  允许最大压缩应变: %.2f%%\n', obj.baseline.max_compression_strain * 100);
                fprintf('  h/a比值: %.2f\n', h_to_a_ratio);
                fprintf('  允许最大h/a比值: %.2f\n', obj.baseline.max_h_to_a_ratio);
                fprintf('\n');
            end
        end

        function obj = calculateStiffnessSafetyFactors(obj)
            % 计算刚度安全系数

            if obj.params.Echo
                disp('--- 刚度安全系数计算 ---');
            end

            % 1. 垂向刚度安全系数
            if obj.input.Kz_target > 0
                Kz_ratio = obj.output.Kz_calc / obj.input.Kz_target;
                obj.capacity.Kz_ratio = Kz_ratio;
            else
                Kz_ratio = 0;
                obj.capacity.Kz_ratio = 0;
            end

            % 2. x向水平刚度安全系数
            if obj.input.Kx_target > 0
                Kx_ratio = obj.output.Kx_total / obj.input.Kx_target;
                obj.capacity.Kx_ratio = Kx_ratio;
            else
                Kx_ratio = 0;
                obj.capacity.Kx_ratio = 0;
            end

            % 3. y向水平刚度安全系数
            if obj.input.Ky_target > 0
                Ky_ratio = obj.output.Ky_total / obj.input.Ky_target;
                obj.capacity.Ky_ratio = Ky_ratio;
            else
                Ky_ratio = 0;
                obj.capacity.Ky_ratio = 0;
            end

            % 4. 存储压缩应变和h/a比值用于校核
            obj.capacity.compression_strain = obj.output.compression_strain;
            obj.capacity.h_to_a_ratio = obj.input.h / obj.input.a;

            if obj.params.Echo
                fprintf('  垂向刚度安全系数: %.2f (要求: %.2f)\n', ...
                        Kz_ratio, obj.baseline.min_Kz_ratio);
                fprintf('  x向水平刚度安全系数: %.2f (要求: %.2f)\n', ...
                        Kx_ratio, obj.baseline.min_Kx_ratio);
                fprintf('  y向水平刚度安全系数: %.2f (要求: %.2f)\n', ...
                        Ky_ratio, obj.baseline.min_Ky_ratio);
                fprintf('\n');
            end
        end

        function obj = OutputAss(obj)
            % 创建FEM装配模型
            % 参考Commonplate.OutputAss和AssemblyModule.m

            if obj.params.Echo
                disp('--- 创建装配模型 ---');
            end

            % 创建装配对象
            Ass = Assembly(obj.params.Name, 'Echo', 0);

            % 定义矩形轮廓 [长a, 宽b]
            a = obj.input.a;
            b = obj.input.b;

            % 创建Point2D对象
            points = Point2D('Rectangle Points');

            % 添加四个顶点
            % 底边：从左下到右下
            points = AddPoint(points, [-a/2; a/2], [-b/2; -b/2]);
            % 右边：从右下到右上
            points = AddPoint(points, [a/2; a/2], [-b/2; b/2]);
            % 顶边：从右上到左上
            points = AddPoint(points, [a/2; -a/2], [b/2; b/2]);
            % 左边：从左上到左下
            points = AddPoint(points, [-a/2; -a/2], [b/2; -b/2]);

            % 创建Line2D对象
            L = Line2D('RectangleOutline');

            % 添加四条边
            L = L.AddLine(points, 1);  % 底边
            L = L.AddLine(points, 2);  % 右边
            L = L.AddLine(points, 3);  % 顶边
            L = L.AddLine(points, 4);  % 左边

            % 获取材料属性
            % 橡胶材料
            RubberProperty.Name = obj.output.RubberProperty.params.Name;
            RubberProperty.Dens = obj.output.RubberProperty.output.Dens;
            RubberProperty.E = obj.output.RubberProperty.output.E;
            RubberProperty.v = obj.output.RubberProperty.output.v;
            RubberProperty.G = obj.output.RubberProperty.output.G;
            RubberProperty.a = obj.output.RubberProperty.output.a;
            RubberProperty.MR_Parameter = obj.output.RubberProperty.output.MR_Parameter;            

            % 板材材料
            steelMat=obj.params.Material;

            % 当前z位置（从底部开始堆叠）
            z_pos = 0;

            % 设置网格尺寸
            meshsize = min(a, b) / 10;

            %% 1. 创建底部端板
            plateParams.Meshsize = meshsize;
            plateParams.Order = 1;
            plateParams.Echo = 0;
            plateParams.Material = steelMat;

            plateInput.Outline = L;
            plateInput.Hole = [];  % 无孔
            plateInput.Thickness = obj.input.t_plate_end;
            plateInput.Meshsize = meshsize;

            bottomPlate = plate.Commonplate(plateParams, plateInput);
            bottomPlate = bottomPlate.solve();
            position = [0, 0, z_pos, 0, 0, 0];
            Ass = AddPart(Ass, bottomPlate.output.SolidMesh.Meshoutput, 'position', position);

            % 更新z位置
            z_pos = z_pos + obj.input.t_plate_end;

            %% 2. 创建橡胶层和中间钢板
            % 2.1 橡胶层
            rubberParams.Meshsize = meshsize;
            rubberParams.Order = 1;
            rubberParams.Echo = 0;
            rubberParams.N_Slice=5;
            rubberParams.Material = RubberProperty;

            rubberInput.Outline = L;
            rubberInput.Hole = [];
            rubberInput.Thickness = obj.input.h;
            rubberInput.Meshsize = meshsize;

            rubberLayer = plate.Commonplate(rubberParams, rubberInput);
            rubberLayer = rubberLayer.solve();

            Ratio=obj.params.Ratio;
            k=4*Ratio/obj.input.h;

            NumVert=size(rubberLayer.output.SolidMesh.Vert,1);
            Temp=NumVert/(rubberLayer.params.N_Slice+1);

            VV=rubberLayer.output.SolidMesh.Vert;

            for i=2:rubberLayer.params.N_Slice
                zz=rubberLayer.output.SolidMesh.Vert(Temp*(i-1)+1,3);
                xx=abs(zz-rubberLayer.input.Thickness/2);
                delta=obj.input.h*Ratio-k*xx^2;
                rr1=(a-delta*2)/a;
                rr2=(b-delta*2)/b;
                VV(Temp*(i-1)+1:Temp*i,1)=rr1*VV(Temp*(i-1)+1:Temp*i,1);
                VV(Temp*(i-1)+1:Temp*i,2)=rr2*VV(Temp*(i-1)+1:Temp*i,2);
            end

            rubberLayer.output.SolidMesh.Vert=VV;
            rubberLayer.output.SolidMesh.Meshoutput.nodes=VV;
          
            % 橡胶层变形
            % rubberLayer = Deform(rubberLayer,Ratio);

            % 2.2 中间钢板（如果是最后一层则不添加，后续添加顶部端板）
            plateInput.Thickness = obj.input.t_plate_mid;
            midPlate = plate.Commonplate(plateParams, plateInput);
            midPlate = midPlate.solve();

            for i = 1:obj.input.n

                position = [0, 0, z_pos, 0, 0, 0];
                Ass = AddPart(Ass, rubberLayer.output.SolidMesh.Meshoutput, 'position', position);

                % 更新z位置
                z_pos = z_pos + obj.input.h;

                if i < obj.input.n

                    position = [0, 0, z_pos, 0, 0, 0];
                    Ass = AddPart(Ass, midPlate.output.SolidMesh.Meshoutput, 'position', position);

                    % 更新z位置
                    z_pos = z_pos + obj.input.t_plate_mid;
                end
            end

            %% 3. 创建顶部端板
            plateInput.Thickness = obj.input.t_plate_end;
            topPlate = plate.Commonplate(plateParams, plateInput);
            topPlate = topPlate.solve();
            position = [0, 0, z_pos, 0, 0, 0];
            Ass = AddPart(Ass, topPlate.output.SolidMesh.Meshoutput, 'position', position);

            %% 设置单元类型
            % Order=1时使用185单元（一次四面体）
            ET1.name = '185'; ET1.opt = []; ET1.R = [];
            Ass = AddET(Ass, ET1);

            % 设置接触单元
            ET2.name='173';ET2.opt=[5,3;9,1;10,2;12,5];ET2.R=[]; 
            Ass=AddET(Ass,ET2);
    
            ET3.name='170';ET3.opt=[];ET3.R=[];
            Ass=AddET(Ass,ET3);

            %% 设置材料
            % 橡胶材料
            mat1.Name = RubberProperty.Name;
            mat1.table=["DENS",RubberProperty.Dens;...
                "EX",RubberProperty.E;...
                "NUXY",RubberProperty.v;...
                "GXY",RubberProperty.G;...
                "ALPX",RubberProperty.a];

            mat1.TBlab=["HYPER",1,0,"MOONEY"];
            mat1.TBtable=[RubberProperty.MR_Parameter(1,1),RubberProperty.MR_Parameter(1,2)];

            Ass = AddMaterial(Ass, mat1);

            % 板材材料
            mat2.Name = steelMat.Name;
            mat2.table = ["DENS", steelMat.Dens; "EX", steelMat.E; "NUXY", steelMat.v];
            Ass = AddMaterial(Ass, mat2);

            % 接触材料
            mat3.table=["MU",0.15];
            Ass=AddMaterial(Ass,mat3);

            % 设置材料到各部件
            % 底部端板 - 钢 (Part 1)
            Ass = SetMaterial(Ass, 1, 2);

            % 橡胶层和钢板
            part_num = 2;
            for i = 1:obj.input.n
                % 橡胶层
                Ass = SetMaterial(Ass, part_num, 1);
                part_num = part_num + 1;

                % 中间钢板（最后一层没有中间钢板）
                if i < obj.input.n
                    Ass = SetMaterial(Ass, part_num, 2);
                    part_num = part_num + 1;
                end
            end

            % 顶部端板 - 钢
            Ass = SetMaterial(Ass, part_num, 2);

            %% 设置单元类型到各部件
            for i = 1:GetNPart(Ass)
                Ass = SetET(Ass, i, 1);
            end

            %% 设置接触
            Acc_ET=GetNET(Ass);
            
            for i=1:part_num-1
                ConNum=GetNContactPair(Ass)+1;
                Ass=AddCon(Ass,i,3);
                Ass=AddTar(Ass,ConNum,i+1,2);
                Ass=SetConMaterial(Ass,ConNum,3);
                Ass=SetConET(Ass,ConNum,Acc_ET-1);
                Ass=SetTarET(Ass,ConNum,Acc_ET);
            end

            %% 保存装配对象
            obj.output.Assembly = Ass;

            if obj.params.Echo
                fprintf('  成功创建装配模型，共 %d 个部件\n', GetNPart(Ass));
                fprintf('  部件包括: %d层橡胶 + %d块钢板\n\n', ...
                        obj.input.n, obj.input.n + 1);
            end
        end

        function checkSafety(obj)
            % 安全校核 - 检查是否满足安全要求

            warnings = {};

            % 1. 垂向刚度安全校核
            if obj.capacity.Kz_ratio < obj.baseline.min_Kz_ratio
                msg = sprintf('垂向刚度安全系数 %.2f 小于要求 %.2f', ...
                            obj.capacity.Kz_ratio, obj.baseline.min_Kz_ratio);
                warnings{end+1} = msg;
            end

            % 2. x向水平刚度安全校核
            if obj.capacity.Kx_ratio < obj.baseline.min_Kx_ratio
                msg = sprintf('x向水平刚度安全系数 %.2f 小于要求 %.2f', ...
                            obj.capacity.Kx_ratio, obj.baseline.min_Kx_ratio);
                warnings{end+1} = msg;
            end

            % 3. y向水平刚度安全校核
            if obj.capacity.Ky_ratio < obj.baseline.min_Ky_ratio
                msg = sprintf('y向水平刚度安全系数 %.2f 小于要求 %.2f', ...
                            obj.capacity.Ky_ratio, obj.baseline.min_Ky_ratio);
                warnings{end+1} = msg;
            end

            % 4. 压缩应变校核
            if obj.capacity.compression_strain > obj.baseline.max_compression_strain
                msg = sprintf('压缩应变 %.2f%% 超过最大允许值 %.2f%%', ...
                            obj.capacity.compression_strain * 100, ...
                            obj.baseline.max_compression_strain * 100);
                warnings{end+1} = msg;
            end

            % 5. h/a比值校核
            if obj.capacity.h_to_a_ratio > obj.baseline.max_h_to_a_ratio
                msg = sprintf('h/a比值 %.2f 超过最大允许值 %.2f', ...
                            obj.capacity.h_to_a_ratio, ...
                            obj.baseline.max_h_to_a_ratio);
                warnings{end+1} = msg;
            end

            % 输出校核结果
            disp(' ');
            disp('==========================================');
            disp('  安全校核结果');
            disp('==========================================');
            if ~isempty(warnings)
                fprintf('  发现 %d 个警告:\n\n', length(warnings));
                for i = 1:length(warnings)
                    fprintf('  警告 %d: %s\n', i, warnings{i});
                end
            else
                disp('  ✓ 所有必要的安全校核均通过');
                fprintf('  垂向刚度安全系数: %.2f >= %.2f\n', ...
                        obj.capacity.Kz_ratio, obj.baseline.min_Kz_ratio);
                fprintf('  x向水平刚度安全系数: %.2f >= %.2f\n', ...
                        obj.capacity.Kx_ratio, obj.baseline.min_Kx_ratio);
                fprintf('  y向水平刚度安全系数: %.2f >= %.2f\n', ...
                        obj.capacity.Ky_ratio, obj.baseline.min_Ky_ratio);
            end
            disp('==========================================');
            disp(' ');
        end

        function InteractiveUI(obj)
            % 覆盖基类的InteractiveUI
            obj.InteractiveUI@Component();
        end

    end

    methods (Hidden)

        function PlotCapacity(obj, varargin)
            % 绘制容量与基准对比图（增强版）

            p = inputParser;
            addParameter(p,'ylim',[0,5]);
            parse(p,varargin{:});
            opt=p.Results;

            % 创建图形窗口
            figure('Position',[100 100 1200 800]);

            % 子图1: 刚度对比
            subplot(2,2,1);
            obj.plotStiffnessComparison();

            % 子图2: 安全系数对比
            subplot(2,2,2);
            obj.plotSafetyComparison();

            % 子图3: 稳定性检查
            subplot(2,2,3);
            obj.plotStabilityCheck();

            % 子图4: 刚度分解（x向）
            subplot(2,2,4);
            obj.plotStiffnessDecomposition();

            sgtitle('Rectangular Rubber Stack Analysis');
        end

        function plotStiffnessComparison(obj)
            % 绘制刚度对比图
            % 刚度单位: N/mm

            labels = {'垂向', 'x向水平', 'y向水平'};
            calc_values = [obj.output.Kz_calc, obj.output.Kx_total, obj.output.Ky_total];
            target_values = [obj.input.Kz_target, obj.input.Kx_target, obj.input.Ky_target];

            % 绘制条形图 (转换为kN/mm)
            x = 1:length(labels);
            b1 = bar(x, calc_values / 1000, 'BarWidth', 0.4);
            hold on;
            b2 = bar(x + 0.4, target_values / 1000, 'BarWidth', 0.4, 'FaceColor', [0.8 0.2 0.2]);

            % 判断是否满足要求
            colors = calc_values >= target_values;
            for i = 1:length(colors)
                if colors(i)
                    b1.CData(i,:) = [0.2 0.8 0.2];  % 绿色
                else
                    b1.CData(i,:) = [0.8 0.2 0.2];  % 红色
                end
            end
            b1.FaceColor = 'flat';

            hold off;

            grid on;
            set(gca, 'XTick', x + 0.2);
            set(gca, 'XTickLabel', labels);
            ylabel('刚度 (kN/mm)');
            title('刚度对比');
            legend({'计算值', '目标值'});
        end

        function plotSafetyComparison(obj)
            % 绘制安全系数对比图

            labels = {'垂向Kz', 'x向Kx', 'y向Ky'};
            capacity_values = [obj.capacity.Kz_ratio, obj.capacity.Kx_ratio, obj.capacity.Ky_ratio];
            baseline_values = [obj.baseline.min_Kz_ratio, obj.baseline.min_Kx_ratio, obj.baseline.min_Ky_ratio];

            % 绘制条形图
            x = 1:length(labels);
            b1 = bar(x, capacity_values, 'BarWidth', 0.4);
            hold on;
            b2 = bar(x + 0.4, baseline_values, 'BarWidth', 0.4, 'FaceColor', [0.8 0.2 0.2]);

            % 判断是否满足要求
            colors = capacity_values >= baseline_values;
            for i = 1:length(colors)
                if colors(i)
                    b1.CData(i,:) = [0.2 0.8 0.2];  % 绿色
                else
                    b1.CData(i,:) = [0.8 0.2 0.2];  % 红色
                end
            end
            b1.FaceColor = 'flat';

            hold off;

            grid on;
            set(gca, 'XTick', x + 0.2);
            set(gca, 'XTickLabel', labels);
            ylabel('安全系数');
            title('安全系数对比');
            legend({'Capacity', 'Baseline'});
        end

        function plotStabilityCheck(obj)
            % 绘制稳定性检查图

            labels = {'压缩应变', 'h/a比值'};
            capacity_values = [obj.capacity.compression_strain, obj.capacity.h_to_a_ratio];
            baseline_values = [obj.baseline.max_compression_strain, obj.baseline.max_h_to_a_ratio];

            % 绘制条形图
            x = 1:length(labels);
            b1 = bar(x, capacity_values, 'BarWidth', 0.4);
            hold on;
            b2 = bar(x + 0.4, baseline_values, 'BarWidth', 0.4, 'FaceColor', [0.8 0.2 0.2]);

            % 判断是否满足要求（稳定性要求 capacity <= baseline）
            colors = capacity_values <= baseline_values;
            for i = 1:length(colors)
                if colors(i)
                    b1.CData(i,:) = [0.2 0.8 0.2];  % 绿色
                else
                    b1.CData(i,:) = [0.8 0.2 0.2];  % 红色
                end
            end
            b1.FaceColor = 'flat';

            hold off;

            grid on;
            set(gca, 'XTick', x + 0.2);
            set(gca, 'XTickLabel', labels);
            ylabel('数值');
            title('稳定性检查');
            legend({'实际值', '最大允许值'});
        end

        function plotStiffnessDecomposition(obj)
            % 绘制刚度分解图（x向）
            % 刚度单位: N/mm

            labels = {'剪切刚度', '弯曲刚度', '总刚度'};
            values = [obj.output.Kx_shear, obj.output.Kbx, obj.output.Kx_total];

            % 绘制条形图 (转换为kN/mm)
            bar(values / 1000);
            grid on;
            set(gca, 'XTickLabel', labels);
            ylabel('刚度 (kN/mm)');
            title('x向刚度分解');
        end

  

    end
end
