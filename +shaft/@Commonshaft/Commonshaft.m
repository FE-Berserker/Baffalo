classdef Commonshaft < Component
    % Class Commonshaft
    % Author: Yu Xie
     
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Material' % Material, default is steel
            'N_Slice' % Number of Slice
            'Name' % Name of commonshaft
            'E_Revolve' % Spin number
            'Beam_N' %  Number of beam element rotate divisions
            'Order' % Solid element order
            'Echo' % Print         
            };
        
        inputExpectedFields = {
            'Length' %  Length of commonshaft [mm]
            'ID' % Shaft inner diameter [mm]
            'OD' % Shaft outer diameter [mm]
            'Meshsize' % Mesh size [mm]        
            };
        
        outputExpectedFields = {
            'Node'% Output Node
            'ID'% Output inner diameter
            'OD'% Output outer diameter
            'Surface'% Shaft section
            'SolidMesh'% Shaft 3D mesh
            'BeamMesh'%  Shaft beam mesh
            'Assembly'% Shaft solid mesh assembly
            'Assembly1'% Shaft Beam mehs assembly
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
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Commonshaft.pdf';
        end
        
        function obj = solve(obj)
            % Check input
            if mod(obj.params.E_Revolve,8)~=0
                obj.params.E_Revolve=ceil(obj.params.E_Revolve/8)*8;
            end

            % calculate outputs
            Total_Length=obj.input.Length(end,1);
            obj.output.Node=(0:1/obj.params.N_Slice:1)'*Total_Length;
            Temp_pos=[0;obj.input.Length];
            for i=1:obj.params.N_Slice
                Temp=Temp_pos-obj.output.Node(i,:);
                [row,~]=find(Temp<=0,1,'last');
                x=[Temp_pos(row,1),Temp_pos(row+1,1)];
                obj.output.ID(i,1)=interp1(x,obj.input.ID(row,:),...
                    obj.output.Node(i,1),'linear');
                obj.output.OD(i,1)=interp1(x,obj.input.OD(row,:),...
                    obj.output.Node(i,1),'linear');
            end
            obj.output.ID(obj.params.N_Slice+1,1)=obj.input.ID(end,2);
            obj.output.OD(obj.params.N_Slice+1,1)=obj.input.OD(end,2);
            obj=CreateS(obj);
            obj=OutputSolidModel(obj);
            obj=OutputBeamModel(obj);

            % Material setting
            if isempty(obj.params.Material)
                S=RMaterial('FEA');
                mat=GetMat(S,1);
                obj.params.Material=mat{1,1};
            end
            
            obj=OutputAss(obj);
            obj=OutputAss1(obj); 
        end

        function obj=CreateS(obj)
            % Create surface of shaft
            % Author : Xie Yu
            a=Point2D('Point Group1','Echo',0);
            x1=[0;obj.input.Length(1,1)];
            y1=[obj.input.OD(1,1)/2;obj.input.OD(1,2)/2];
            x2=[obj.input.Length(1,1);0];
            y2=[obj.input.ID(1,2)/2;obj.input.ID(1,1)/2];
            for i=2:numel(obj.input.Length)
                Temp1=[obj.input.Length(i-1,1);obj.input.Length(i,1)];
                x1=[x1;Temp1]; %#ok<AGROW> 
                Temp2=[obj.input.OD(i,1)/2;obj.input.OD(i,2)/2];
                y1=[y1;Temp2]; %#ok<AGROW> 
                Temp3=[obj.input.Length(i,1);obj.input.Length(i-1,1)];
                x2=[Temp3;x2]; %#ok<AGROW> 
                Temp4=[obj.input.ID(i,2)/2;obj.input.ID(i,1)/2];
                y2=[Temp4;y2]; %#ok<AGROW> 
            end
            x=[x1;x2];
            y=[y1;y2];
            a=AddPoint(a,x,y);
            a=CompressNpts(a,'all',1);
            xx=[x(end);x(1)];
            yy=[y(end);y(1)];
            a=AddPoint(a,xx,yy);
            b=Line2D('Line Group1','Echo',0);
            b=AddCurve(b,a,1);
            b=AddLine(b,a,2);
            obj.output.Surface=Surface2D(b,'Echo',0);
            %% Print
            if obj.params.Echo
                fprintf('Successfully create surface of shaft .\n');
            end

        end
        
        function Plot2D(obj)
            Plot(obj.output.Surface);
        end
        
    end
end