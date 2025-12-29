classdef SingleGear < Component
    % Single gear
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Echo' % Print
            'Name'
            'Material'
            'Order'
            'h_fp' % 齿根高系数
            'rho_fp'% 齿根半径系数
            'h_ap' % 齿顶高系数
            'Type' % 1.齿轮基准齿廓 2. 滚刀无切顶  3.滚刀含切顶
            'Lsize1'% Shell mesh line esize
            'Lsize2'% Solid mesh line esize
            'MeshNTooth' % Shell mesh gear number 
            'NWidth' % Solid mesh gear width segment
            'Helix' % right, left
            'NMaster' % Number of master point
            };
        
        inputExpectedFields = {
            'mn' % 模数 [mm]
            'alphan' % 压力角 [°]
            'beta' % 螺旋角 [°]
            'ID' % 齿轮内径 [mm]
            'Z' % 齿数
            'b' % 齿宽 [mm]
            'x' % 变位系数    
            'Tool' % 刀具参数
            };
        
        outputExpectedFields = {
            'xt' % 端面变位系数
            'mt' % 端面模数 [mm]
            'alphat' % 端面压力角 [°]
            'cp' % 顶隙系数
            'd' % 分度圆直径 [mm]
            'db' % 基圆直径 [mm]
            'da' % 齿顶圆直径 [mm]
            'df' % 齿根圆直径 [mm]
            'h' % 齿高 [mm]
            'ha' % 齿顶高 [mm]
            'hf' % 齿根高 [mm]
            'betaf' % 分度圆螺旋角 [°]
            'betab' % 基圆螺旋角 [°]
            'Tool' % 刀具参数
            'ToolCurve' % 刀具曲线
            'GearCurve' % 齿轮齿廓
            'ShellMesh' % Shell mesh with tooth
            'SolidMesh' % Solid mesh with tooth
            'Assembly' % Solid mesh assembly
            'Assembly1' % Shell mesh assembly
            'MasterPoint'
            };
        baselineExpectedFields = {}
        
        default_Name='SingleGear_1'
        default_Material=[];
        default_Order=1;
        default_Type=1;
        default_Echo=1;
        default_h_fp=1.25;
        default_rho_fp=0.38;
        default_h_ap=1;
        default_Lsize1=[128;32;16]
        default_Lsize2=[64;16;8]
        default_MeshNTooth=5;
        default_NWidth=10;
        default_jn=0;
        default_Helix='Right'
        default_NMaster=3;

    end
    methods
        
        function obj = SingleGear(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='SingleGear.pdf'; % Set help file name, put it in the folder "Document"
        end
        
        function obj = solve(obj)
            %calculate outputs
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            obj=CalGeometryParameter(obj);

            if isempty(obj.input.ID)
                obj.input.ID=obj.output.df-6*obj.input.mn;
            end
            
            obj=CreateTool(obj);
            obj=CreateGear(obj);
            Lsize=obj.params.Lsize1;
            obj.output.ShellMesh=OutputShellModel(obj,Lsize);
            obj=OutputAss1(obj); 
            obj=OutputSolidModel(obj);
            obj=OutputAss(obj);
                 
        end
        
        function obj=Plot2D(obj)
            Plot(obj.output.ShellMesh)
        end
        
    end
end