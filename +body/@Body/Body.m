classdef Body < Component
    % Class body
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material'% 材料属性，默认为铁
            'Name' %名称
            'Echo'
            };

        inputExpectedFields = {
            'Space' % 空间
            'Meshsize' %网格大小 [mm]
            };

        outputExpectedFields = {
            'Times' %雕刻次数
            'OriginSolidMesh'%原始模型
            'SolidMesh'
            'Assembly'% 3D网格
            };

        baselineExpectedFields = {};
        default_Name='Body1';
        default_Material=[];
        default_Echo=1;
    end
    methods

        function obj = Body(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Body.pdf';
        end

        function obj = solve(obj)
            %calculate space
            space=obj.input.Space;
            lx=space(1,1);
            ly=space(1,2);
            lz=space(1,3);

            x = linspace(-lx/2,lx/2,round(lx/obj.input.Meshsize)+1);
            y=linspace(-ly/2,ly/2,round(ly/obj.input.Meshsize)+1);
            z=linspace(-lz/2,lz/2,round(lz/obj.input.Meshsize)+1);

            mm1=Mesh(obj.params.Name);
            mm1=MeshTensorGrid(mm1,x,y,z);
            mm1= ComputeGeometryG(mm1);
            obj.output.SolidMesh=mm1;

            mm2=Mesh(strcat('Origin_',obj.params.Name));
            mm2.Face=mm1.Face;
            mm2.Vert=mm1.Vert;
            mm2.Cb=mm1.Cb;
            mm2.El=mm1.El;
            mm2.G=mm1.G;
            mm2.Meshoutput=mm1.Meshoutput;

            
            obj.output.OriginSolidMesh=mm2;
            % 材料设置
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end
        end

    end
end

