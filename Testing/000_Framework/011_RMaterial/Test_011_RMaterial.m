clc
clear
close all
% Test object RMaterial
%% 1 Basic material
%% 2 Composite material
%% 3 Gear Material
%% 4 Bolt Material
%% 5 FEA Material, Add Material and delete material
%% 6 Magnetic
%% 7 Add Composite Material template
%% 8 Spring Material
%% 9 PlotMatDB - Plot material database
flag=9;
testRMaterial(flag);
function testRMaterial(flag)
switch flag
    case 1
        S=RMaterial('Basic');
        APP(S);
        mat=GetMat(S,10);
    case 2
        S=RMaterial('Composite');
        APP(S);
        mat=GetMat(S,[29;30;31]);
        disp(mat);   
    case 3
        S=RMaterial('Gear');
        APP(S);
    case 4
        S=RMaterial('Bolt');
        APP(S);
        
    case 5
        S=RMaterial('FEA');
        disp(S.Sheet)
        mat=GetMat(S,1);
        disp(mat{1,1})
        % Add material
        M.Name="Temp";
        M.Density=7.2e-9;
        M.v=0.28;
        M.E=1.1e5;
        M.a=1.1e-5;
        S=AddMat(S,M);
        % Reload RMaterial
        SNew=RMaterial('FEA');
        disp(SNew.Sheet)
        SNew=DeleteMat(SNew,size(SNew.Sheet,1));
        disp(SNew.Sheet)

    case 6
        S=RMaterial('Magnetic');
        mat=GetMat(S,2);
    case 7
        S=RMaterial('Composite');
        mat=GetMat(S,2);
        disp(mat{1,1});
        % Add Material
        M=mat{1,1};
        M.Name='Epoxy_s';
        M.allowables.F1t=64.4;
        M.allowables.F4=118.2;
        M.allowables.F5=118.2;
        M.allowables.F6=118.2;
        M.DataSource='Introduction to Composite Materials Design';
        M.Type='Matrix';
        S=AddMat(S,M);
        mat=GetMat(S,size(S.Sheet,1));
        disp(mat{1,1});
    case 8
        S=RMaterial('Spring');
        disp(S.Sheet);
        % Get single material
        mat=GetMat(S,1);
        disp(mat{1,1});
        % Get multiple materials
        mats=GetMat(S,[1;2;3]);
        disp('Multiple spring materials:');
        for i=1:length(mats)
            disp(['Material ' num2str(i) ': ' mats{i}.Name]);
            disp(['  ASTM: ' mats{i}.ASTM]);
            disp(['  SAE: ' mats{i}.SAE]);
            disp(['  E = ' num2str(mats{i}.E) ' Pa']);
            disp(['  G = ' num2str(mats{i}.G) ' Pa']);
            disp(['  A = ' num2str(mats{i}.A)]);
            disp(['  b = ' num2str(mats{i}.b)]);
        end

    case 9
        % Test PlotMatDB with direct parameters
        disp('Test 9.1: PlotMatDB with direct parameters (Composite - E1 vs E2)');
        S = RMaterial('Composite');
        PlotMatDB(S, 'XField', 'E1', 'YField', 'E2');

        % Test with different material sheet
        disp('Test 9.2: PlotMatDB with Spring material');
        S = RMaterial('Spring');
        PlotMatDB(S, 'XField', 'E', 'YField', 'G');

        % Test with Basic material
        disp('Test 9.3: PlotMatDB with Basic material');
        S = RMaterial('Basic');
        PlotMatDB(S, 'XField', 'Density', 'YField', 'E');

        % Test interactive mode (commented out to avoid blocking automated tests)
        % disp('Test 9.4: Interactive mode (uncomment to test)');
        % S = RMaterial('');
        % PlotMatDB(S);

        % Test with Unit parameter
        disp('Test 9.5: PlotMatDB with Unit=2 (SI units)');
        S = RMaterial('Composite');
        PlotMatDB(S, 'XField', 'E1', 'YField', 'E2', 'Unit', 2);

end
end