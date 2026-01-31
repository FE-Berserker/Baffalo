% Test All Cases for Commonshaft Demo
clc
clear
close all

% Test all 13 cases
for flag = 1:13
    fprintf('\n========================================\n');
    fprintf('Testing Case %d...\n', flag);
    fprintf('========================================\n');
    try
        obj1=DemoCommmonshaft(flag);
        fprintf('Case %d: PASSED\n', flag);
    catch ME
        fprintf('Case %d: FAILED\n', flag);
        fprintf('Error: %s\n', ME.message);
        fprintf('Stack:\n');
        for i = 1:length(ME.stack)
            fprintf('  File: %s, Line: %d\n', ME.stack(i).file, ME.stack(i).line);
        end
    end
end

fprintf('\n========================================\n');
fprintf('All tests completed!\n');
fprintf('========================================\n');

function obj1=DemoCommmonshaft(flag)
switch flag
    case 1
        % Shaft 1
        inputshaft1.Length = 115;
        inputshaft1.ID = [0,0];
        inputshaft1.OD = [36,36];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 1: Single solid shaft\n');
    case 2
        % Shaft 2
        inputshaft1.Length = 120;
        inputshaft1.ID = [6,6];
        inputshaft1.OD = [36,36];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 2: Single hollow shaft\n');
    case 3
        % Shaft 3
        inputshaft1.Length = [29;53;77;115];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[22.5,22.5];[26.5,26.5];[29.5,29.5];[36,36]];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 3: Multi-section solid shaft\n');
    case 4
        % Shaft 4
        inputshaft1.Length = [29;53;71;77;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,6.6];[6.6,6.6];[0,0];[0,0]];
        inputshaft1.OD = [[22.5,22.5];[26.5,26.5];[29.5,29.5];[29.5,29.5];[36,36]];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 4: Hollow to solid transition shaft\n');
    case 5
        % Shaft 5
        inputshaft1.Length = [29;53;71;77;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,6.6];[6.6,6.6];[18.5,18.5];[18.5,18.5]];
        inputshaft1.OD = [[22.5,22.5];[26.5,26.5];[29.5,29.5];[29.5,29.5];[36,36]];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 5: Hollow with inner diameter step\n');
    case 6
        % Shaft 6
        inputshaft1.Length = [29;53;71;77;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,6.6];[6.6,6.6];[6.6,18.5];[18.5,18.5]];
        inputshaft1.OD = [[22.5,22.5];[26.5,26.5];[26.5,29.5];[29.5,29.5];[36,36]];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 6: Hollow with variable inner diameter\n');
    case 7
        % Shaft 7
        inputshaft1.Length = [7;8;29;53;71;77;107;108;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,6.6];[6.6,6.6]];
        inputshaft1.OD = [[22.5,22.5];[22.5,22.5];[22.5,22.5];[26.5,26.5];[26.5,29.5];[29.5,29.5];...
            [36,36];[36,36];[36,36]];
        inputshaft1.Meshsize=0.5;
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 7: Complex shaft with solid section\n');
    case 8
        % Shaft 8
        inputshaft1.Length = [32;35;320-35;320-32;320];
        inputshaft1.ID = [[0,0];[0,0];[0,0];[0,0];[0,0]];
        inputshaft1.OD = [[45,45];[43,43];[54,54];[43,43];[45,45]];
        paramsshaft1.Order = 1;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();

        Plot2D(obj1);
        Plot3D(obj1);
        fprintf('  - Shaft 8: Large shaft with outer diameter steps (Order 1)\n');
    case 9
        % Shaft 9 (same as shaft 7 with Order 2)
        inputshaft1.Length = [7;8;29;53;71;77;107;108;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,6.6];[6.6,6.6]];
        inputshaft1.OD = [[22.5,22.5];[22.5,22.5];[22.5,22.5];[26.5,26.5];[26.5,29.5];[29.5,29.5];...
            [36,36];[36,36];[36,36]];
        paramsshaft1.Order = 2;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();

        Plot2D(obj1);
        fprintf('  - Shaft 9: Order 2 solid mesh (skipping ANSYS)\n');
    case 10
        % Shaft 10 (beam model)
        inputshaft1.Length = [7;8;29;53;71;77;107;108;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,6.6];[6.6,6.6]];
        inputshaft1.OD = [[22.5,22.5];[22.5,22.5];[22.5,22.5];[26.5,26.5];[26.5,29.5];[29.5,29.5];...
            [36,36];[36,36];[36,36]];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        fprintf('  - Shaft 10: Beam model (skipping ANSYS)\n');
    case 11
        % Shaft 11 (deform face)
        inputShaft1.Length = [6.4;22;50;55;78;145];
        inputShaft1.ID = [[180,133];[40,40];[40,40];[40,40];[8.5,8.5];[20,20]];
        inputShaft1.OD = [[210,210];[210,130];[130,130];[89,89];[89,89];[65,65]];
        paramsShaft1 = struct();
        obj1 = shaft.Commonshaft(paramsShaft1, inputShaft1);
        obj1 = obj1.solve();
        f=@(r)sqrt(250^2-r.^2)+22-sqrt(250^2-65^2);
        obj1=DeformFace(obj1,102,f);
        fprintf('  - Shaft 11: Deform face test (skipping plot)\n');
    case 12
        % Shaft 12
        Shaft2_Height=243.7;
        Shaft2_Step_Height=20;
        inputShaft2.Length = [40;117.7;201.7;Shaft2_Height-Shaft2_Step_Height;Shaft2_Height];
        inputShaft2.OD = [[35,35];[42,42];[65,65];[90,90];[54,54]];
        inputShaft2.ID = [[10,10];[10,10];[10,10];[10,10];[10,10]];
        inputShaft2.Meshsize=15;
        paramsShaft2.E_Revolve = 60;
        obj1 = shaft.Commonshaft(paramsShaft2, inputShaft2);
        obj1 = obj1.solve();
        fprintf('  - Shaft 12: Large hollow shaft with custom mesh size (skipping plot)\n');
    case 13
        % Shaft 13 (STL output)
        inputshaft1.Length = 120;
        inputshaft1.ID = [6,6];
        inputshaft1.OD = [36,36];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        OutputSTL(obj1);
        fprintf('  - Shaft 13: STL output test (skipping plot and read)\n');
end
end
