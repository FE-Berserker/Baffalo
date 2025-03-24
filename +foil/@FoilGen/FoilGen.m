classdef FoilGen < Component
    % Class Foilgen
    % Author: Xie Yu
    
    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name' % Name
            'Echo' % Print
            'Origin' % Origin point
            };

        inputExpectedFields = {
            'Foil' % Class foil
            'Dx' % delta x
            'Dy' % delta y
            'Dz' % delta z
            'Rotx' % rotx
            'Roty' % roty
            'Rotz' % rotz
            'Scale' % Scale factor
            'SizeZ' % Size along z direction
            };

        outputExpectedFields = {
            'Layer'
            'Mesh'% Foil mesh
            };

        baselineExpectedFields = {};
        default_Name='FoilGen_1';
        default_Echo=1
        default_Origin=[];
        default_SmoothFactor=0.01;
    end
    methods

        function obj = FoilGen(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='FoilGen.pdf';
        end

        function obj = solve(obj)
            % Check input
            if isempty(obj.input.Dz)
                error('Please input Dz !')
            end

            if isempty(obj.input.Foil)
                error('Please input 2D foil !')
            end

            if isempty(obj.input.SizeZ)
                Coor=obj.input.Foil;
                delta=sqrt((Coor(2:end,1)-Coor(1:end-1,1)).^2+(Coor(2:end,2)-Coor(1:end-1,2)).^2);
                obj.input.SizeZ=max(delta);
            end

            if isempty(obj.params.Origin)
                Coor=obj.input.Foil;
                obj.params.Origin=mean(Coor);
            end

            row=size(obj.input.Dz,1);

            if ~isempty(obj.input.Dx)
                Dx=obj.input.Dx;
            else
                Dx=zeros(row,1);
            end

            if ~isempty(obj.input.Dy)
                Dy=obj.input.Dy;
            else
                Dy=zeros(row,1);
            end
            
            Dz=obj.input.Dz;

            if ~isempty(obj.input.Rotx)
                Rotx=obj.input.Rotx;
            else
                Rotx=zeros(row,1);
            end

            if ~isempty(obj.input.Roty)
                Roty=obj.input.Roty;
            else
                Roty=zeros(row,1);
            end

            if ~isempty(obj.input.Rotz)
                Rotz=obj.input.Rotz;
            else
                Rotz=zeros(row,1);
            end

            if ~isempty(obj.input.Scale)
                ScaleFactor=obj.input.Scale;
            else
                ScaleFactor=ones(row,1);
            end

            % Calculate outputs
            l=Layer(obj.params.Name,'Echo',0);
            l=AddCurve(l,[obj.input.Foil,zeros(size(obj.input.Foil,1),1)]);
            nseg=ceil(obj.input.Dz/obj.input.SizeZ);

            for i=1:row
                l=Move(l,[Dx(i,1),Dy(i,1),Dz(i,1)],'Lines',1,'New',1);
                l=Rotate(l,[Rotx(i,1),Roty(i,1),Rotz(i,1)],'Line',i+1,'origin',[obj.params.Origin,0]+[Dx(i,1),Dy(i,1),Dz(i,1)]);
                l=Scale(l,ScaleFactor(i,1),'Lines',i+1,'origin',[obj.params.Origin,0]+[Dx(i,1),Dy(i,1),Dz(i,1)]);
            end
 
            V_cent=cell2mat(cellfun(@(x)mean(x.P),l.Lines,'UniformOutput',false));
            l=AddCurve(l,V_cent);

            controlParameter.n=sum(nseg);
            controlParameter.Method='HC';
            l=SweepLoft(l,(1:GetNLines(l)-1)',GetNLines(l),'PointSpacing',obj.input.SizeZ,'Smooth',controlParameter);

            % Parse
            obj.output.Layer=l;
            m=Mesh(obj.params.Name,'Echo',0);
            m.Vert=l.Meshes{1,1}.Vert;
            m.Face=l.Meshes{1,1}.Face;
            m.Cb=ones(size(m.Face,1),1);
            obj.output.Mesh=m;
            
            %% Print
            if obj.params.Echo
                fprintf('Successfully generate foil .\n');
            end

        end

        function Plot3D(obj)
            Plot(obj.output.Layer);
        end

    end
end

