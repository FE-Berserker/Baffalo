classdef Laminate < Component
    % Laminate plate
    % Author: Xie Yu
    
    properties (Hidden, Constant)
        
        paramsExpectedFields = {
            'Name' % Name of Laminate
            'Echo' % Print
            'Criterion' % Failure criterion
            'Material' % Composite material properties
            };
        
        inputExpectedFields = {
            'Orient' % Ply orientation [°]
            'Plymat' % Ply Material Number
            'Tply' % Unit [mm]
            'Load'
            %Type=0 -- Problem number counter
            %Type=2 -- Applied loading type identifier (force/moment resultants)
            %Type=1 -- Applied loading type identifier (midplane strains/curvatures)
            };
        
        outputExpectedFields = {
            'Plymat' % Ply material properties
            'Safety' % Safety result (MoS,Safety factor)
            'LamResult'
            'Geometry'
            };
        
        baselineExpectedFields = {
            'SF1' % Laminate extreme safety factor baseline
            }

        default_Name='Laminate_1'
        default_Echo=1;
        default_Material=[];
        default_Criterion=0; 
        %1——Max stress;2——Max strain;3——Tsai-Hill;...
        % 4——Hoffman;5——Tsai-Wu;6——Hashin;...
        % 7——Puck 
        base_SF1=1;% Laminate extreme safety factor 
    end
    methods
        
        function obj = Laminate(paramsStruct,inputStruct)
            obj = obj@Component(paramsStruct,inputStruct);
            obj.documentname='Laminate.pdf';
        end
        
        function obj = solve(obj)
            if isempty(obj.params.Material)
                error('Material is not defined !')
            end

            Orient=obj.input.Orient';
            Plymat=obj.params.Material(obj.input.Plymat)';
            Tply=obj.input.Tply';
            Load=obj.input.Load';
            % Load.DT=0;
            Load.NM=2;
            Load.EK=1;
            LamResults =[];

            [Geometry, LamResults] = CLT(Orient,Plymat,Tply, Load, LamResults);

            %% Print
            if obj.params.Echo
                fprintf('Successfully add calculate laminate results .\n');
                fprintf('A Matrix :.\n');
                disp(LamResults.A);
                fprintf('B Matrix :.\n');
                disp(LamResults.B);
                fprintf('D Matrix :.\n');
                disp(LamResults.D);
                fprintf('Laminate effective properties :.\n');
                fprintf('Ex Ey Nuxy Gxy Alpha_x Alpha_y Alpha_xy.\n');
                disp(num2str([LamResults.EX,LamResults.EY,...
                    LamResults.NuXY,LamResults.GXY,...
                    LamResults.AlphX,LamResults.AlphY]));
            end
            % Parse
            obj.output.Geometry=Geometry;
            %% Print
            if obj.params.Echo
                fprintf('Successfully add output geometry .\n');
            end

            % Calculate local fields for micromechanics
            % LamResults = LamMicroFields(Geometry, Load, plyprops, LamResults);

            % if obj.params.Echo
            %     fprintf('Successfully Calculate local field for micromechanics .\n');
            % end

            % Check for turning off some failure criteria
            % [LamResults, plyprops] = CalcLamMargins(Plymat, Geometry, Load, LamResults);
            if obj.params.Criterion~=0
                obj=CalcLamMargins(obj,Plymat,LamResults,Geometry);
                if obj.params.Echo
                    fprintf('Successfully Calculate Laminate safety .\n');
                    fprintf('Laminate min MoS :\n');
                    disp(obj.output.Safety.MoSmin)
                    fprintf('Laminate min SF :\n');
                    disp(obj.output.Safety.SFmin)
                end
            end

            % Parse
            obj.output.LamResult=LamResults;
            obj.output.Plymat=Plymat';
        end

        function PlotResult(obj,varargin)
            p=inputParser;
            addParameter(p,'MC',0);% Material coordinate
            parse(p,varargin{:});
            opt=p.Results;
            switch opt.MC
                case 0
                    Stress=obj.output.LamResult.stress;
                    Z=repmat(obj.output.Geometry.LayerZ,3,1);
                    C1={'\sigma_x','\sigma_y','\tau_{xy}'};
                case 1
                    Stress=obj.output.LamResult.MCstress;
                    Z=repmat(obj.output.Geometry.LayerZ,3,1);
                    C1={'MC\sigma_x','MC\sigma_y','MC\tau_{xy}'};
            end

            g=Rplot('x',Stress,'y',Z,'color',C1); 
            g=geom_line(g);
            g=set_names(g,'x',"Stress (Mpa)",'y','Thickness (mm)','color','Stress');
            g=set_title(g,'Laminate Stress');

            figure('Position',[100 100 800 800]);
            draw(g);
        end
    end
end