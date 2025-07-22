classdef SingleGear < Component
    % Single gear
    % Author: Yu Xie
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Echo' % Print
            'Name'
            'Material'
            'Order'
            'h_fp' % �ݸ���ϵ��
            'rho_fp'% �ݸ��뾶ϵ��
            'h_ap' % �ݶ���ϵ��
            'Type' % 1.���ֻ�׼���� 2. �������ж�  3.�������ж�
            'Lsize1'% Shell mesh line esize
            'Lsize2'% Solid mesh line esize
            'MeshNTooth' % Shell mesh gear number 
            'NWidth' % Solid mesh gear width segment
            'Helix' % right, left
            'NMaster' % Number of master point
            };
        
        inputExpectedFields = {
            'mn' % ģ�� [mm]
            'alphan' % ѹ���� [��]
            'beta' % ������ [��]
            'ID' % �����ھ� [mm]
            'Z' % ����
            'b' % �ݿ� [mm]
            'x' % ��λϵ��    
            'Tool' % ���߲���
            };
        
        outputExpectedFields = {
            'xt' % �����λϵ��
            'mt' % ����ģ�� [mm]
            'alphat' % ����ѹ���� [��]
            'cp' % ��϶ϵ��
            'd' % �ֶ�Բֱ�� [mm]
            'db' % ��Բֱ�� [mm]
            'da' % �ݶ�Բֱ�� [mm]
            'df' % �ݸ�Բֱ�� [mm]
            'h' % �ݸ� [mm]
            'ha' % �ݶ��� [mm]
            'hf' % �ݸ��� [mm]
            'betaf' % �ֶ�Բ������ [��]
            'betab' % ��Բ������ [��]
            'Tool' % ���߲���
            'ToolCurve' % ��������
            'GearCurve' % ���ֳ���
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