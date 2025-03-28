classdef WindturbineTower < Component
    % Class WindturbineTower
    % Author: Xie Yu
    
    properties
        %other cComponentTemplate specific properties...
    end

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Material' % Material properties，default is steel
            'N_Slice' % Rotate num
            'Degree' % Rotate degree [°]
            'Name' % Name
            'Echo' % Print
            'Order' % Element order
            'Offset' % Shell element offset
            };

        inputExpectedFields = {
            'Length' % Length of tower section
            'Diameter' % Diameter of windturbine tower
            'Thickness' % Thickness of plate
            'Meshsize' % Mesh size
            };

        outputExpectedFields = {
            'Surface' % WindturbineTower Section surface
            'ShellMesh'% WindturbineTower shell mesh
            'BeamMesh' % WindturbineTower beam mesh
            'Matrix'
            'Assembly'% Assembly of shell mesh
            'Assembly1'% Assembly of beam mesh
            };

        baselineExpectedFields = {};
        default_N_Slice=72;
        default_Name='WindturbineTower_1';
        default_Material=[];
        default_Degree=360 % Default rotate angle 360°
        default_Echo=1
        default_Order=1
        default_Offset="MID"
    end
    methods

        function obj = WindturbineTower(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='WindturbineTower.pdf';
        end

        function obj = solve(obj)
            % Check input
            row1=size(obj.input.Length);
            row2=size(obj.input.Thickness);
            row3=size(obj.input.Diameter);
            if or(row1~=row2,row1~=row3)
                error('Size of input is not equal !')
            end
            % Calculate outputs
            obj=CreateS(obj);
           
            % Material
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end

            obj=OutputShellModel(obj);
            obj=OutputBeamModel(obj);
            obj=OutputAss(obj);
            obj=OutputAss1(obj);
        end

        function obj=CreateS(obj)
            % Create surface of WindturbineTower
            % Author : Xie Yu
            switch obj.params.Offset
                case "MID"
                    OD=obj.input.Diameter+repmat(obj.input.Thickness,1,2);
                    ID=obj.input.Diameter-repmat(obj.input.Thickness,1,2);
                case "BOT"
                    OD=obj.input.Diameter+2*repmat(obj.input.Thickness,1,2);
                    ID=obj.input.Diameter;
                case "TOP"
                    OD=obj.input.Diameter;
                    ID=obj.input.Diameter-2*repmat(obj.input.Thickness,1,2);
            end
            Height=tril(ones(size(obj.input.Length,1)))*obj.input.Length;
            Height=[0;Height(1:end-1)];
            b=Line2D('Temp','Echo',0);
            H=[Height,Height+obj.input.Length];
            a=Point2D('Temp','Echo',0);
            a=AddPoint(a,[reshape(ID'/2,[],1);reshape(OD(end:-1:1,:)'/2,[],1)],...
                [reshape(H',[],1);reshape(H(end:-1:1,2:-1:1)',[],1)]);
            b=AddCurve(b,a,1);
            S=Surface2D(b,'Echo',0);
            obj.output.Surface=S;
            %% Print
            if obj.params.Echo
                fprintf('Successfully create surface of WindturbineTower .\n');
            end

        end

        function Plot2D(obj)
            Plot(obj.output.Surface,'equal',0);
        end

    end
end

