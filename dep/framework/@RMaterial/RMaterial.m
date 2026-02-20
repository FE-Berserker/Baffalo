classdef RMaterial<handle
    % RoTA Material class
    % Author : Xie Yu
    
    properties
        Sheet % Material sheet
        SheetName % Sheet Name
        Mat % Material Properity
        Material % Material row number (for selecting specific material)
        Echo % print
    end
    
    methods
        function obj = RMaterial(tablename,varargin)
            % default values
            p=inputParser;
            addParameter(p,'Echo',1);
            addParameter(p,'Material',[]);
            parse(p,varargin{:});
            opt=p.Results;

            obj.Echo=opt.Echo;
            obj.Material=opt.Material;

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
                case 'Lubricant'
                    Mat=load('Lubricant.mat');
                case 'Spring'
                    Mat=load('Spring.mat');
                case 'Spring_User'

            end
            obj.Sheet=Mat.Mat;
            obj.SheetName=tablename;

            % Handle Material property for Spring sheet
            if strcmp(tablename, 'Spring') && isempty(obj.Material)
                % Default to first material in Spring library
                obj.Material = 1;
                if obj.Echo
                    fprintf('Using default material: %s (row %d)\n', obj.Sheet.Name{1}, 1);
                end
            end

            if obj.Echo
                fprintf('Successfully get material database .\n');
            end
        end
    end
end

