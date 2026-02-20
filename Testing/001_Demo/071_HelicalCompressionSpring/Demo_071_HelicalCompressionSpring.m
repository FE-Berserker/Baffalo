% Demo HelicalCompressionSpring
clc
clear
close all

% Demo Helical Compression Spring
% 1. Basic static load design (A228 music wire)
% 2. Dynamic load design with surge check
% 3. Different end types (open, square_ground)
% 4. Chrome-vanadium steel material
% 5. Shot peened spring for fatigue life
% 6. Compare different designs

flag=6;
DemoHelicalCompressionSpring(flag);

function DemoHelicalCompressionSpring(flag)
switch flag
    case 1
        % Case 1: Basic static load design (A228 music wire)
        % Design a compression spring for static application
        inputStruct1.WireDiameter = 2.5;       % (mm) Wire diameter d
        inputStruct1.MeanDiameter = 20;      % (mm) Mean coil diameter D
        inputStruct1.FreeLength = 60;         % (mm) Free length Lf
        inputStruct1.WorkingForce = 500;     % (N) Working load F
        inputStruct1.WorkingDeflection = 20;  % (mm) Working deflection y
        inputStruct1.LoadType = 'static';      % 'static' or 'dynamic'
        inputStruct1.EndType = 'open';        % 'open', 'open_ground', 'square', 'square_ground'
        inputStruct1.EndCondition = 'fixed_free'; % 'fixed_fixed' or 'fixed_free'

        % Use default material (A228 music wire)
        paramsStruct1 = struct();

        obj1 = connection.HelicalCompressionSpring(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();

    case 2
        % Case 2: Dynamic load design with surge check
        % Design a compression spring for dynamic application (e.g., valve spring)
        inputStruct1.WireDiameter = 2.0;       % (mm) Wire diameter d
        inputStruct1.MeanDiameter = 16;      % (mm) Mean coil diameter D
        inputStruct1.FreeLength = 45;         % (mm) Free length Lf
        inputStruct1.WorkingForce = 300;     % (N) Working load F
        inputStruct1.WorkingDeflection = 12;  % (mm) Working deflection y
        inputStruct1.LoadType = 'dynamic';     % 'static' or 'dynamic'
        inputStruct1.EndType = 'open_ground';  % 'open', 'open_ground', 'square', 'square_ground'
        inputStruct1.EndCondition = 'fixed_fixed'; % 'fixed_fixed' or 'fixed_free'
        inputStruct1.LoadingFreq = 50;        % (Hz) Loading frequency

        % Use default material (A228 music wire)
        paramsStruct1 = struct();

        obj1 = connection.HelicalCompressionSpring(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();

    case 3
        % Case 3: Different end types comparison
        % Compare springs with different end types (open vs square_ground)
        inputStruct1.WireDiameter = 2.5;
        inputStruct1.MeanDiameter = 20;
        inputStruct1.FreeLength = 60;
        inputStruct1.WorkingForce = 500;
        inputStruct1.WorkingDeflection = 20;
        inputStruct1.LoadType = 'static';
        inputStruct1.EndType = 'open';
        inputStruct1.EndCondition = 'fixed_free';

        paramsStruct1 = struct();

        obj1 = connection.HelicalCompressionSpring(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();

        % Compare with square_ground end type
        inputStruct2 = inputStruct1;
        inputStruct2.EndType = 'square_ground';

        obj2 = connection.HelicalCompressionSpring(paramsStruct1, inputStruct2);
        obj2 = obj2.solve();

        fprintf('\n--- Comparison ---\n');
        fprintf('Open end type:\n');
        fprintf('  Total coils: %.2f\n', obj1.output.TotalCoils);
        fprintf('  Active coils: %.2f\n', obj1.output.ActiveCoils);
        fprintf('  Solid length: %.2f mm\n', obj1.output.SolidLength);
        fprintf('Square ground end type:\n');
        fprintf('  Total coils: %.2f\n', obj2.output.TotalCoils);
        fprintf('  Active coils: %.2f\n', obj2.output.ActiveCoils);
        fprintf('  Solid length: %.2f mm\n', obj2.output.SolidLength);

    case 4
        % Case 4: Chrome-vanadium steel material
        % Design using A232 chrome-vanadium steel (high strength)
        inputStruct1.WireDiameter = 3.0;       % (mm) Wire diameter d
        inputStruct1.MeanDiameter = 25;      % (mm) Mean coil diameter D
        inputStruct1.FreeLength = 80;         % (mm) Free length Lf
        inputStruct1.WorkingForce = 1000;    % (N) Working load F
        inputStruct1.WorkingDeflection = 25;  % (mm) Working deflection y
        inputStruct1.LoadType = 'static';
        inputStruct1.EndType = 'open_ground';
        inputStruct1.EndCondition = 'fixed_free';

        % Use A232 chrome-vanadium steel
        paramsStruct1.MaterialGrade = 'A232';  % Chrome-vanadium steel

        obj1 = connection.HelicalCompressionSpring(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();

    case 5
        % Case 5: Shot peened spring for fatigue life
        % Design a spring for dynamic application with shot peening
        inputStruct1.WireDiameter = 2.5;       % (mm) Wire diameter d
        inputStruct1.MeanDiameter = 20;      % (mm) Mean coil diameter D
        inputStruct1.FreeLength = 60;         % (mm) Free length Lf
        inputStruct1.WorkingForce = 500;     % (N) Working load F
        inputStruct1.WorkingDeflection = 15;  % (mm) Working deflection y
        inputStruct1.LoadType = 'dynamic';     % 'static' or 'dynamic'
        inputStruct1.EndType = 'open';
        inputStruct1.EndCondition = 'fixed_free';
        inputStruct1.LoadingFreq = 30;        % (Hz) Loading frequency

        % Enable shot peening for improved fatigue strength
        paramsStruct1 = struct();
        paramsStruct1.IsShotPeened = true;   % Shot peening increases fatigue strength

        obj1 = connection.HelicalCompressionSpring(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();

    case 6
        % Case 6: Compare different spring designs
        % Compare springs with different design parameters

        % Design A: Small spring index (stiffer spring)
        inputStruct1.WireDiameter = 3.0;
        inputStruct1.MeanDiameter = 18;
        inputStruct1.FreeLength = 50;
        inputStruct1.WorkingForce = 800;
        inputStruct1.WorkingDeflection = 15;
        inputStruct1.LoadType = 'static';
        inputStruct1.EndType = 'open';
        inputStruct1.EndCondition = 'fixed_free';
        paramsStruct1 = struct();

        obj1 = connection.HelicalCompressionSpring(paramsStruct1, inputStruct1);
        obj1 = obj1.solve();

        % Design B: Medium spring index
        inputStruct2.WireDiameter = 2.5;
        inputStruct2.MeanDiameter = 25;
        inputStruct2.FreeLength = 60;
        inputStruct2.WorkingForce = 500;
        inputStruct2.WorkingDeflection = 20;
        inputStruct2.LoadType = 'static';
        inputStruct2.EndType = 'open_ground';
        inputStruct2.EndCondition = 'fixed_free';
        paramsStruct2 = struct();

        obj2 = connection.HelicalCompressionSpring(paramsStruct2, inputStruct2);
        obj2 = obj2.solve();

        % Design C: Large spring index (flexible spring)
        inputStruct3.WireDiameter = 2.0;
        inputStruct3.MeanDiameter = 30;
        inputStruct3.FreeLength = 70;
        inputStruct3.WorkingForce = 300;
        inputStruct3.WorkingDeflection = 25;
        inputStruct3.LoadType = 'static';
        inputStruct3.EndType = 'square';
        inputStruct3.EndCondition = 'fixed_free';
        paramsStruct3 = struct();

        obj3 = connection.HelicalCompressionSpring(paramsStruct3, inputStruct3);
        obj3 = obj3.solve();

        fprintf('\n=== Design Comparison ===\n');
        fprintf('\nDesign A (Stiff, C=%.1f):\n', obj1.output.SpringIndex);
        fprintf('  Spring Rate: %.3f N/mm\n', obj1.output.SpringRate);
        fprintf('  Max Stress: %.2f MPa\n', obj1.output.MaxShearStress);
        fprintf('  Static SF: %.2f\n', obj1.output.SafetyFactorStatic);

        fprintf('\nDesign B (Medium, C=%.1f):\n', obj2.output.SpringIndex);
        fprintf('  Spring Rate: %.3f N/mm\n', obj2.output.SpringRate);
        fprintf('  Max Stress: %.2f MPa\n', obj2.output.MaxShearStress);
        fprintf('  Static SF: %.2f\n', obj2.output.SafetyFactorStatic);

        fprintf('\nDesign C (Flexible, C=%.1f):\n', obj3.output.SpringIndex);
        fprintf('  Spring Rate: %.3f N/mm\n', obj3.output.SpringRate);
        fprintf('  Max Stress: %.2f MPa\n', obj3.output.MaxShearStress);
        fprintf('  Static SF: %.2f\n', obj3.output.SafetyFactorStatic);
end
end
