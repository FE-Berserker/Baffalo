classdef Commonshaft < Component
    % Commonshaft - 通用轴类
    % 用于创建和分析阶梯轴（变截面轴）的模型
    % 支持实体模型和梁模型两种有限元分析方式
    % Author: Yu Xie

    properties (Hidden, Constant)

        % 参数字段定义
        paramsExpectedFields = {
            'Material' % 材料，默认为钢材
            'N_Slice' % 切片数量，用于沿轴向离散化
            'Name' % 轴的名称
            'E_Revolve' % 旋转划分数（圆周方向的分段数），必须是8的倍数
            'Beam_N' % 梁单元旋转划分（梁截面圆周方向的分段数）
            'Order' % 实体单元阶次：1=一阶，2=二阶
            'Echo' % 是否打印信息：0=不打印，1=打印
            };

        % 输入字段定义
        inputExpectedFields = {
            'Length' % 各段长度 [mm]，Nx2矩阵 [起始位置, 结束位置]
            'ID' % 各段内径 [mm]，Nx2矩阵 [起始内径, 结束内径]
            'OD' % 各段外径 [mm]，Nx2矩阵 [起始外径, 结束外径]
            'Meshsize' % 网格尺寸 [mm]，如果为空则自动计算
            };

        % 输出字段定义
        outputExpectedFields = {
            'Node' % 轴向节点位置
            'ID' % 各节点处的内径
            'OD' % 各节点处的外径
            'Surface' % 轴的2D截面
            'SolidMesh' % 轴的3D实体网格
            'BeamMesh' % 轴的梁网格
            'Assembly' % 实体模型装配
            'Assembly1' % 梁模型装配
            };
        baselineExpectedFields = {
            };
        
        default_N_Slice=100;
        default_Name='Commonshaft1';
        default_E_Revolve=40;
        default_Beam_N=16;
        default_Material=[];
        default_Echo=1;
        default_Order=1;
    end
    methods
        
        function obj = Commonshaft(paramsStruct,inputStruct)
            % 构造函数
            % Inputs:
            %   paramsStruct - 参数结构体
            %   inputStruct   - 输入结构体
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Commonshaft.pdf';
        end

        function obj = solve(obj)
            % 求解方法
            % 主要功能：
            %   1. 验证并修正输入参数
            %   2. 计算各节点的内外径
            %   3. 创建2D截面
            %   4. 生成实体网格和梁网格
            %   5. 设置材料并创建装配

            % 检查并修正旋转划分数（必须是8的倍数）
            if mod(obj.params.E_Revolve,8)~=0
                obj.params.E_Revolve=ceil(obj.params.E_Revolve/8)*8;
            end

            % 计算输出结果
            % 获取轴的总长度
            Total_Length=obj.input.Length(end,1);
            % 生成轴向节点位置（0到总长度）
            obj.output.Node=(0:1/obj.params.N_Slice:1)'*Total_Length;

            % 构建各段位置点
            Temp_pos=[0;obj.input.Length];

            % 插值计算各节点处的内外径
            for i=1:obj.params.N_Slice
                % 找到当前节点所在的段
                Temp=Temp_pos-obj.output.Node(i,:);
                [row,~]=find(Temp<=0,1,'last');
                x=[Temp_pos(row,1),Temp_pos(row+1,1)];
                % 线性插值计算内径
                obj.output.ID(i,1)=interp1(x,obj.input.ID(row,:),...
                    obj.output.Node(i,1),'linear');
                % 线性插值计算外径
                obj.output.OD(i,1)=interp1(x,obj.input.OD(row,:),...
                    obj.output.Node(i,1),'linear');
            end
            % 设置最后一个节点的内外径
            obj.output.ID(obj.params.N_Slice+1,1)=obj.input.ID(end,2);
            obj.output.OD(obj.params.N_Slice+1,1)=obj.input.OD(end,2);

            % 创建2D截面
            obj=CreateS(obj);
            % 生成实体模型网格
            obj=OutputSolidModel(obj);
            % 生成梁模型网格
            obj=OutputBeamModel(obj);

            % 设置材料（如果未指定则使用默认钢材）
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            % 创建实体模型装配
            obj=OutputAss(obj);
            % 创建梁模型装配
            obj=OutputAss1(obj);
        end

        function obj=CreateS(obj)
            % 创建轴的2D截面
            % 通过构建外轮廓和内轮廓点，形成闭合的轴截面
            % Author: Xie Yu

            % 创建点对象（外轮廓）
            a=Point2D('Point Group1','Echo',0);
            % 第一段外径点（从左到右）
            x1=[0;obj.input.Length(1,1)];
            y1=[obj.input.OD(1,1)/2;obj.input.OD(1,2)/2];
            % 第一段内径点（从右到左，形成闭合回路）
            x2=[obj.input.Length(1,1);0];
            y2=[obj.input.ID(1,2)/2;obj.input.ID(1,1)/2];

            % 构建所有段的外轮廓点
            for i=2:numel(obj.input.Length)
                % 外径：x从左到右增加，y为外径
                Temp1=[obj.input.Length(i-1,1);obj.input.Length(i,1)];
                x1=[x1;Temp1]; %#ok<AGROW>
                Temp2=[obj.input.OD(i,1)/2;obj.input.OD(i,2)/2];
                y1=[y1;Temp2]; %#ok<AGROW>
                % 内径：x从右到左减少，y为内径
                Temp3=[obj.input.Length(i,1);obj.input.Length(i-1,1)];
                x2=[Temp3;x2]; %#ok<AGROW>
                Temp4=[obj.input.ID(i,2)/2;obj.input.ID(i,1)/2];
                y2=[Temp4;y2]; %#ok<AGROW>
            end

            % 合并外轮廓和内轮廓点
            x=[x1;x2];
            y=[y1;y2];
            a=AddPoint(a,x,y);
            % 压缩重复点
            a=CompressNpts(a,'all',1);
            % 添加闭合点（连接最后一个点和第一个点）
            xx=[x(end);x(1)];
            yy=[y(end);y(1)];
            a=AddPoint(a,xx,yy);

            % 创建线对象并形成闭合曲线
            b=Line2D('Line Group1','Echo',0);
            b=AddCurve(b,a,1); % 外轮廓曲线
            b=AddLine(b,a,2);  % 内轮廓曲线

            % 创建2D面对象
            obj.output.Surface=Surface2D(b,'Echo',0);

            %% 打印信息
            if obj.params.Echo
                fprintf('Successfully create surface of shaft .\n');
            end

        end
        
        function Plot2D(obj)
            % 绘制2D截面图
            Plot(obj.output.Surface);
        end
        
    end
end