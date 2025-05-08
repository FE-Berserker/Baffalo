clc
clear
close all
plotflag=true;
% Demo_Laminate
% 1. Compare to ANSYS ACP
% 2. UD laminate with 45°
% 3. Cross ply
% 4. Plot material coordinate laminate results
% 5. Calculate UD lamminate failure Criterion
% 6. Calculate lamminate [60,-60,0]s failure Criterion
% 7. Ply-level failure envelopes

flag=7;
DemoLaminate(flag);

function DemoLaminate(flag)
switch flag
    case 1
        S=RMaterial('Composite');
        mat=GetMat(S,5);
        type=4;
        switch type
            case 1
                % Symmetric layout 1
                inputStruct.Orient=[0,90,90,0]';
                inputStruct.Tply=repmat(0.15,4,1);
                inputStruct.Plymat=ones(4,1);
            case 2
                % Symmetric layout 2
                inputStruct.Orient=[30,45,0,0,30,45]';
                inputStruct.Tply=repmat(0.15,6,1);
                inputStruct.Plymat=ones(6,1);
            case 3
                % Antisymmetric layout 1
                inputStruct.Orient=[-45,30,-30,45]';
                inputStruct.Tply=repmat(0.15,4,1);
                inputStruct.Plymat=ones(4,1);
            case 4
                % Antisymmetric layout 2
                inputStruct.Orient=[45,-60,-30,30,60,-45]';
                inputStruct.Tply=repmat(0.15,6,1);
                inputStruct.Plymat=ones(6,1);
        end
        inputStruct.Load.Type  = [2, 2, 2, 2, 2, 2];
        inputStruct.Load.Value = [15, 0, 0, 0, 0, 0];
        % inputStruct.Load.Value = [0, 0, 0, 15, 0, 0];
        paramsStruct.Material=mat;
        L= plate.Laminate(paramsStruct, inputStruct);
        L=L.solve();
        PlotResult(L);
        PlotResult(L,'MC',1);
        PlotLaminateProperty(L);
    case 2
        S=RMaterial('Composite');
        mat=GetMat(S,22);
        inputStruct.Orient=45;
        inputStruct.Tply=0.15;
        inputStruct.Plymat=1;
        inputStruct.Load.Type  = [2, 2, 2, 2, 2, 2];
        inputStruct.Load.Value = [1, 0, 0, 0, 0, 0];
        paramsStruct.Material=mat;
        L= plate.Laminate(paramsStruct, inputStruct);
        L=L.solve();
        PlotResult(L);

    case 3
        S=RMaterial('Composite');
        mat=GetMat(S,21);
        type=3;
        switch type
            case 1
                 inputStruct.Orient=[0,90,90,0]';
            case 2
                inputStruct.Orient=[90,0,0,90]';
            case 3
                inputStruct.Orient=[0,0,90,90]';
        end
        
        inputStruct.Tply=repmat(0.15,4,1);
        inputStruct.Plymat=ones(4,1);
        inputStruct.Load.Type  = [2, 2, 2, 2, 2, 2];
        % inputStruct.Load.Value = [1, 0, 0, 0, 0, 0];
        inputStruct.Load.Value = [0, 0, 0, 1, 0, 0];
        paramsStruct.Material=mat;
        L= plate.Laminate(paramsStruct, inputStruct);
        L=L.solve();
        PlotResult(L);

    case 4
        S=RMaterial('Composite');
        mat=GetMat(S,21);
        inputStruct.Orient=[45,-45,-45,45]';
        inputStruct.Tply=repmat(0.15,4,1);
        inputStruct.Plymat=ones(4,1);
        inputStruct.Load.Type  = [2, 2, 2, 2, 2, 2];
        inputStruct.Load.Value = [0, 0, 0, 1, 0, 0];
        paramsStruct.Material=mat;
        L= plate.Laminate(paramsStruct, inputStruct);
        L=L.solve();
        PlotResult(L);
        PlotResult(L,'MC',1);
    case 5
        S=RMaterial('Composite');
        mat=GetMat(S,21);
        type=2;
        switch type
            case 1
                inputStruct.Orient=0;
                inputStruct.Tply=1;
                inputStruct.Plymat=1;
            case 2
                inputStruct.Orient=45;
                inputStruct.Tply=1;
                inputStruct.Plymat=1;
        end
        inputStruct.Load.Type  = [2, 2, 2, 2, 2, 2];
        inputStruct.Load.Value = [1000, 0, 0, 0, 0, 0];
        paramsStruct.Material=mat;
        paramsStruct.Criterion=7;% Change method to get different results
        L= plate.Laminate(paramsStruct, inputStruct);
        L=L.solve();
        PlotResult(L,'MC',1);
    case 6
        S=RMaterial('Composite');
        mat=GetMat(S,21);

        inputStruct.Orient=[60;-60;0;0;-60;60];
        inputStruct.Tply=repmat(0.15,6,1);
        inputStruct.Plymat=ones(6,1);

        inputStruct.Load.Type  = [2, 2, 2, 2, 2, 2];
        % inputStruct.Load.Value = [300, 0, 0, 0, 0, 0];
        inputStruct.Load.Value = [0, 300, 0, 0, 0, 0];
        paramsStruct.Material=mat;
        paramsStruct.Criterion=5;% Change method to get different results
        L= plate.Laminate(paramsStruct, inputStruct);
        L=L.solve();
        PlotResult(L,'MC',1);
    case 7
        S=RMaterial('Composite');
        mat=GetMat(S,21);
        Type=2;

        switch Type
            case 1
                inputStruct.Orient=0;
                inputStruct.Tply=1;
                inputStruct.Plymat=1;
            case 2
                inputStruct.Orient=[60;-60;0;0;-60;60];
                inputStruct.Tply=repmat(0.15,6,1);
                inputStruct.Plymat=ones(6,1);
        end
        paramsStruct.Material=mat;
        Env=NaN(37,6);
        for i=1:37
            theta=(i-1)*10;
            inputStruct.Load.Type  = [2, 2, 2, 2, 2, 2];
            inputStruct.Load.Value = [cos(theta/180*pi), sin(theta/180*pi), 0, 0, 0, 0];
            for j=1:6
                paramsStruct.Criterion=j;
                L= plate.Laminate(paramsStruct, inputStruct);
                L=L.solve();
                Env(i,j)=min(L.output.Safety.SFmin);
            end
        end
        % Plot Env
        x=0:360/36:360;
        Env=mat2cell(Env',ones(1,6));
        g=Rplot('x',x','y',Env,'Color',{'MaxStress','MaxStrain','TsaiHill','Hoffman','TasiWu','Hashin'});
        g=geom_radar(g);
        g=set_title(g,'Ply Eenvelopes');
        g=set_names(g,'column','Origin','color','Criterion');
        figure('Position',[100 100 800 400]);
        draw(g)

        
end
end
