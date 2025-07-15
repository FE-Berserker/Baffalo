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
flag=7;
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
    
end
end