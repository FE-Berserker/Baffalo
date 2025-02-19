classdef RMaterial<handle
    % RoTA Material class
    % Author : Xie Yu
    
    properties
        Sheet % Material sheet
        SheetName % Sheet Name
        Mat % Material Properity
        Echo % print
    end
    
    methods
        function obj = RMaterial(tablename,varargin)
            % default values
            p=inputParser;
            addParameter(p,'Echo',1);
            parse(p,varargin{:});
            opt=p.Results;

            obj.Echo=opt.Echo;

            obj.SheetName=tablename;
            switch obj.SheetName
                case 'Basic'
                    Mat=load('Basic.mat');
                case 'Basic_User'
                case 'Gear'
                    Mat=load('Gear.mat');
                case 'Gear_User'
                case 'Bolt'
                    Mat=load('Bolt.mat');
                case 'Bolt_User'
                case 'Composite'
                    Mat=load('Composite.mat');
                case 'Composite_User'
                case 'Magnetic'
                    Mat=load('Mag.mat');
                case 'Magnetic_User'
                case 'FEA'
                    Mat=load('FEA.mat');
            end
            obj.Sheet=Mat.Mat;
            obj.SheetName=tablename;

            if obj.Echo
                fprintf('Successfully get material database .\n');
            end
        end
    end
end

