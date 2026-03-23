classdef SerpentineSpringDesign < Component
    %SerpentineSpringDesign Serpentine torsion spring analysis component
    %   Analyzes serpentine torsion spring performance based on geometry
    %   Calculates stiffness, deflection, stress, and generates CAD profiles
    %
    %   Author: Auto-generated from spring-design-tool
    %
    %   Reference: "An Energy-Dense Two-Part Torsion Spring Architecture and Design Tool"

    properties(Hidden, Constant)

        paramsExpectedFields = {
            'Name'              % Name of Component
            'Echo'              % Print calculation info
            'Material'          % Material type
            'DesignDeflDeg'  % Design deflection [deg], optional
            'NumControlPoints'  % Number of control points
            'MinTipRadius'      % Minimum tip radius [m]
            'NumFlexures'       % Number of flexures [-]
            'NumPins' % Number of pins [-]
            'PinsRadius' % Pinsradfius [mm] 
            'Step'  % Curve discretization step [mm]
            'RootRadius'        % Root radius [mm]
            'TipRadius'         % Tip radius [mm]
            'run_time'
            'Gap' % Tip to cam Gap [mm]
            'Meshsize'
            'N_Slice'
            'Order'
            
            };

        inputExpectedFields = {
            'OuterRadius'       % Outer radius [mm]
            'Thickness'         % Spring thickness [mm]
            'K' % (Nm/rad) desired stiffness
            };

        outputExpectedFields = {
            'RootRadius'        % Root radius [mm]
            'ContactRadius'     % Contact/Tip radius [mm]
            'NumberFlexures'    % Number of flexures [-]
            'NumberPins'        % Number of pins [-]
            'PinRadius'         % Pin radius [mm]
            'DesiredDeflection' % Desired deflection [deg]
            'RunTime'           % Optimization run time [s]
            'StepSize'          % Curve discretization step [mm]
            'NumControlPoints'  % Number of control points [-]
            'TipCamGap'         % Gap between tip and cam [mm]
            'MinTipRadius'      % Minimum tip ball radius [mm]
            'AllowableDeflection'% Allowable deflection [deg]
            'FlexureCloseness'  % Minimum distance between flexures [mm]
            % Profile coordinates [mm]
            'ProfileRaw'        % Raw flexure profile [mm]
            'ProfilePattern'    % Single flexure pattern profile [mm]
            'ProfileWedge'      % Wedge profile (outer + inner + outer) [mm]
            'ProfileInner'      % Full inner circumference profile [mm]
            'ProfileOuter'      % Full outer circumference profile [mm]
            'ProfileCam'        % Cam profile [mm]
            'ProfileCamRaw'     % Raw cam profile before fillets [mm]
            'Surface' % Surface of Spring
            'SolidMesh'
            'Assembly'
            };

        baselineExpectedFields = {
            };

        % Default values for params
        default_Name='SerpentineSpringDesign_1';
        default_Echo=true;
        default_Material=[];
        default_NumControlPoints=[];
        default_MinTipRadius=[];
        default_DesignDeflDeg=[];       
        default_NumFlexures=[];
        default_NumPins=[];
        default_run_time=[];
        default_Step=[];
        default_RootRadius=[];
        default_TipRadius=[];
        default_PinsRadius=[];
        default_Gap=[];
        default_Meshsize=[];
        default_N_Slice=3;
        default_Order=1;
    end

    methods

        function obj = SerpentineSpringDesign(paramsStruct,inputStruct,varargin)
            obj = obj@Component(paramsStruct,inputStruct,varargin);
            obj.documentname='SerpentineSpringDesign.pdf';
        end



        function obj = solve(obj)
            % Check input is Null
            Check(obj);

            %% Material properties initialization
            if isempty(obj.params.Material)
                S=RMaterial('Basic');
                mat=GetMat(S,22);
                obj.params.Material=mat{1,1};
            end

            rad_out = 1e-3*obj.input.OuterRadius;
            z_thick = 1e-3*obj.input.Thickness;
            k=obj.input.K;

            design_stress = 1e6*mat{1, 1}.FKM.ReN*0.85; % 85% of yield stress

            if isnan(design_stress)
                warning('No design_stress defined!')
            end

            E = 1e6*mat{1, 1}.E;

            num_flex=obj.params.NumFlexures;         % [-]
            rad_root=obj.params.RootRadius*1e-3;     % [mm]
            rad_tip=obj.params.TipRadius*1e-3;       % [mm]
            run_time=obj.params.run_time;
            step=1e-3*obj.params.Step;
            n_ctrl_p=obj.params.NumControlPoints;
            pins_num = obj.params.NumPins;
            pins_rad = 1e-3*obj.params.PinsRadius;
            defl_des = obj.params.DesignDeflDeg;
            gap = 1e-3*obj.params.Gap;
            min_ball_rad = 1e-3*obj.params.MinTipRadius;

            [Profiles,ReturnVals] = serp_setup(rad_out,z_thick,k,design_stress,E,rad_root,rad_tip,num_flex,pins_num,pins_rad,defl_des,run_time,step,n_ctrl_p,gap,min_ball_rad);

            %% Store outputs
            obj.output.RootRadius = ReturnVals.RootRadius * 1000;           % [mm]
            obj.output.ContactRadius = ReturnVals.ContactRadius * 1000;     % [mm]
            obj.output.NumberFlexures = ReturnVals.NumberFlexures;          % [-]
            obj.output.NumberPins = ReturnVals.NumberPins;                  % [-]
            obj.output.PinRadius = ReturnVals.PinRadius * 1000;             % [mm]
            obj.output.DesiredDeflection = ReturnVals.DesiredDeflection;    % [deg]
            obj.output.RunTime = ReturnVals.RunTime;                        % [s]
            obj.output.StepSize = ReturnVals.StepSize * 1000;               % [mm]
            obj.output.NumControlPoints = ReturnVals.NumControlPoints;      % [-]
            obj.output.TipCamGap = ReturnVals.TipCamGap * 1000;             % [mm]
            obj.output.MinTipRadius = ReturnVals.MinTipRadius * 1000;       % [mm]
            obj.output.AllowableDeflection = ReturnVals.AllowableDeflection;% [deg]
            obj.output.FlexureCloseness = ReturnVals.FlexureCloseness * 1000;% [mm]

            %% Store profiles
            obj.output.ProfileRaw = Profiles.raw;                           % Raw flexure profile
            obj.output.ProfilePattern = Profiles.pattern;                   % Single flexure pattern
            obj.output.ProfileWedge = Profiles.wedge;                       % Wedge profile
            obj.output.ProfileInner = Profiles.inner;                       % Full inner circumference
            obj.output.ProfileOuter = Profiles.outer;                       % Full outer circumference
            obj.output.ProfileCam = Profiles.cam_profile;                   % Cam profile
            obj.output.ProfileCamRaw = Profiles.cam_raw;                    % Raw cam profile

            %% Create section
            obj=OutputSurface(obj);
            obj=OutputSolidModel(obj);
            obj = OutputAss(obj);

            %% Print
            if obj.params.Echo
                fprintf('[%s] Serpentine Spring Analysis completed.\n',obj.params.Name);
                fprintf('  Stiffness: %.2f Nm/rad\n',k);
                fprintf('  Allowable Deflection: %.2f deg\n',ReturnVals.AllowableDeflection);
                fprintf('  Design Deflection: %.2f deg\n',ReturnVals.DesiredDeflection);
                fprintf('  Max Stress: %.2f MPa\n',design_stress/1e6);
                fprintf('  Number of Flexures: %d\n',ReturnVals.NumberFlexures);
                fprintf('  Tip Ball Radius: %.3f mm\n',ReturnVals.MinTipRadius*1e3);
            end
        end
    end
end