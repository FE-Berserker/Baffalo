clc
clear
close all
% Demo
% 1. Create PadEye
% 2. Output to Catia

flag=2;
DemoPadEye(flag);

function DemoPadEye(flag)
switch flag
    case 1
        %% Parameters
        l = 200;        % Base length
        C = 20;         % Base thickness
        R = 50;         % Eye outer radius
        B = 100;        % Eye center height from base bottom
        xc = l - R;     % Horizontal distance from left base to eye center

        %% Create points (Commonplate convention: hole center at origin)
        a = Point2D('PadEye_points');

        % Bottom base line: (R-l, -B) -> (R, -B)
        a = AddPoint(a, [R - l; R], [-B; -B]);
        % Right base line: (R, -B) -> (R, -(B-C))
        a = AddPoint(a, [R; R], [-B; -(B - C)]);
        % Right side: (R, -(B-C)) -> (R, 0)
        a = AddPoint(a, [R; R], [-(B - C); 0]);
        % Eye / hole center
        a = AddPoint(a, 0, 0);
        % Left taper: tangent point on eye -> top-left base corner
        % Calculate angle
        alpha = 270 - atan(xc/(B - C))/pi*180 - acos(R/sqrt(xc^2 + (B - C)^2))/pi*180;
        a = AddPoint(a, [R*cos(alpha/180*pi); R - l], [R*sin(alpha/180*pi); -(B - C)]);
        % Left base line: (R-l, -(B-C)) -> (R-l, -B)
        a = AddPoint(a, [R - l; R - l], [-(B - C); -B]);

        %% Create outline (outer contour)
        b = Line2D('PadEye_outline');
        b = AddLine(b, a, 1);                                % Bottom base
        b = AddLine(b, a, 2);                                % Right base
        b = AddLine(b, a, 3);                                % Right side
        b = AddCircle(b, R, a, 4, 'sang', 0, 'ang', alpha);  % Top arc
        b = AddLine(b, a, 5);                                % Left taper
        b = AddLine(b, a, 6);                                % Left base

        %% Plot outline
        Plot(b,'equal',1);

        %% Create PadEye object
        paramsStruct.Name = 'PadEye1';
        paramsStruct.Echo = 1;
        paramsStruct.Material = [];
        paramsStruct.Order = 1;
        paramsStruct.Offset = 'Mid';
        paramsStruct.N_Slice = 3;

        inputStruct.Outline = b;
        inputStruct.HoleDia = 50;
        inputStruct.Meshsize = 5;
        inputStruct.Thickness = 20;

        obj = connection.PadEye(paramsStruct, inputStruct);
        obj = obj.solve();

        %% Plot PadEye results
        Plot2D(obj);
        Plot3D(obj);

    case 2
        %% Parameters
        l = 200;        % Base length
        C = 20;         % Base thickness
        R = 50;         % Eye outer radius
        B = 100;        % Eye center height from base bottom
        xc = l - R;     % Horizontal distance from left base to eye center

        %% Create points (Commonplate convention: hole center at origin)
        a = Point2D('PadEye_points');

        % Bottom base line: (R-l, -B) -> (R, -B)
        a = AddPoint(a, [R - l; R], [-B; -B]);
        % Right base line: (R, -B) -> (R, -(B-C))
        a = AddPoint(a, [R; R], [-B; -(B - C)]);
        % Right side: (R, -(B-C)) -> (R, 0)
        a = AddPoint(a, [R; R], [-(B - C); 0]);
        % Eye / hole center
        a = AddPoint(a, 0, 0);
        % Left taper: tangent point on eye -> top-left base corner
        % Calculate angle
        alpha = 270 - atan(xc/(B - C))/pi*180 - acos(R/sqrt(xc^2 + (B - C)^2))/pi*180;
        a = AddPoint(a, [R*cos(alpha/180*pi); R - l], [R*sin(alpha/180*pi); -(B - C)]);
        % Left base line: (R-l, -(B-C)) -> (R-l, -B)
        a = AddPoint(a, [R - l; R - l], [-(B - C); -B]);

        %% Create outline (outer contour)
        b = Line2D('PadEye_outline');
        b = AddLine(b, a, 1);                                % Bottom base
        b = AddLine(b, a, 2);                                % Right base
        b = AddLine(b, a, 3);                                % Right side
        b = AddCircle(b, R, a, 4, 'sang', 0, 'ang', alpha);  % Top arc
        b = AddLine(b, a, 5);                                % Left taper
        b = AddLine(b, a, 6);                                % Left base

        %% Create PadEye object
        paramsStruct.Name = 'PadEye1';
        paramsStruct.Echo = 1;
        paramsStruct.Material = [];
        paramsStruct.Order = 1;
        paramsStruct.Offset = 'Mid';
        paramsStruct.N_Slice = 3;

        inputStruct.Outline = b;
        inputStruct.HoleDia = 50;
        inputStruct.Meshsize = 5;
        inputStruct.Thickness = 20;

        obj = connection.PadEye(paramsStruct, inputStruct);
        obj = obj.solve();

        %% Plot PadEye results
        Plot3D(obj);

        %% Output catia
        OutputCatiaPart(obj);

end
end