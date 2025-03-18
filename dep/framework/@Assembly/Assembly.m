classdef Assembly< handle & matlab.mixin.Copyable
    % Assembly Create Assembly object 
    % Author: Xie Yu
    
    properties
        Name % Name of Assembly
        Echo % print
    end
    
    properties
        Id % Part num
        Part % Parts in Assembly
        Summary % Summary information
        T_Ref % Reference Temperatures, default is 20℃
        Table % Table
        Boundary % Boundary of Assembly
        BeamPreload % BeamPreload
        Load  % Load of Assembly
        Displacement % Displacement of Assembly
        SF % Surface load
        Cnode % Connection node used to connect or apply boundary/load
        Cnode_Mat % Cnode material ANSYS(Mass21)
        Connection % Connection between different part
        Master % Master node for RBE3 or RBE2
        NodeMass % Addtional node mass
        Slaver
        Spring
        Bearing
        LUTBearing
        Section
        Material
        V % Nodes of the Assembly
        BcSupportList
        BcPrescribeList
        BcDisplacementList
        ET % Element type
        Group % A group of series part
        CS % Coordinate system
        Temperature % Part temperature     
        EndRelease
        EndReleaseList
        Sensor % Sensor for post analysis
        Sensor1 % Sensor for post26 analysis
        Solu % Solution type
        ContactPair % Contact pair
        SubStrM % Sub Structure Master Node
        IStress % Intial stress
        CutBoundary % Submodel cutboundary
        Joint % MPC 184
    end

    properties
        % plot settings
        fontSize
        faceAlpha1
        marker
        markerSize
        lineWidth
    end

    methods
        function obj = Assembly(Name,varargin)
            % default values
            obj.Name = Name;
            p=inputParser;
            addParameter(p,'Echo',1);
            addParameter(p,'T_Ref',20);
            parse(p,varargin{:});
            opt=p.Results;
    
            obj.Summary.Total_El=0; % Total number of elements
            obj.Summary.Total_Node=0; % Total number of nodes
            obj.Summary.Total_Cnode=0; % Total number of cnodes
            obj.Summary.Total_Master=0; % Total number of master
            obj.Summary.Total_Slaver=0; % Total number of slave
            obj.Summary.Total_Connection=0; % Total number of connections
            obj.Summary.Total_Section=0; % Total number of section
            obj.Summary.Total_Part=0; % Total number of part
            obj.Summary.Total_Load=0; % Total number of load
            obj.Summary.Total_Displacement=0; % Total number of displacement
            obj.Summary.Total_Boundary=0; % Total number of boundary
            obj.Summary.Total_ET=0; % Total number of element type
            obj.Summary.Total_Sensor=0; % Total number of sensor
            obj.Summary.Total_IStress=0; % Total number of intial stress
            obj.Summary.Total_SF=0; % Total number of SF
            obj.Summary.Total_Contact=0; % Total number of contact pair
            obj.Summary.Total_CS=0; % Total number of coordinate system
            obj.Summary.Total_NodeMass=0; % Total number of NodeMass
            obj.Summary.Total_EndReleease=0;% Total endrelease of Assembly
            obj.Summary.Total_BeamPreload=0; % Total number of beampreload
            obj.Summary.Total_Joint=0; % Total number of Joint

            obj.Echo = opt.Echo;
            obj.T_Ref=opt.T_Ref;

            obj.Id=0;
            obj.SubStrM.Node=[];
            obj.SubStrM.Type=[];
            obj.CutBoundary=[];

            obj.fontSize=20;
            obj.faceAlpha1=0.8;
            obj.markerSize=40;
            obj.lineWidth=3;
            obj.BcSupportList=[];
            obj.EndReleaseList=[];
            obj.BcPrescribeList=[];
            obj.Cnode_Mat=[];
            obj.Sensor=[];
            obj.Solu=[];
            obj.NodeMass=[];
            obj.BeamPreload=[];


            if obj.Echo
                fprintf('Creating Assembly object ...\n');
            end

        end

    end
end

