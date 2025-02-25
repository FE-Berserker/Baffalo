% Demo Commonshaft
clc
clear
close all
plotFlag = true;
% setBaffaloPath
% 1 shaft1
% 2 shaft2
% 3 shaft3
% 4 shaft4
% 5 shaft5
% 6 shaft6
% 7 shaft7
% 8 Shaft8
% 9 OutputSoliodModel to ANSYS
% 10 OutputBeamModel to ANSYS
% 11 Deform face
% 12 Plot Face No
% 13 Output STL

flag=12;
obj1=DemoCommmonshaft(flag);

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
    case 9
        % Shaft 7
        inputshaft1.Length = [7;8;29;53;71;77;107;108;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,6.6];[6.6,6.6]];
        inputshaft1.OD = [[22.5,22.5];[22.5,22.5];[22.5,22.5];[26.5,26.5];[26.5,29.5];[29.5,29.5];...
            [36,36];[36,36];[36,36]];
        paramsshaft1.Order = 2;
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        
        Plot2D(obj1);
        Plot3D(obj1);
        %% Assembly
        m=obj1.output.SolidMesh;
        Ass=Assembly('Shaft_Assembly');
        Ass=AddPart(Ass,m.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',302);
        Bound1=[1,1,1,0,0,0];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Load
        Ass=AddLoad(Ass,1,'No',305);
        Load1=[0,-1e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        Plot(Ass,'boundary',1,'load',1);
        % Material
        mat.Name='Steel';
        mat.table=["DENS",7.85e-9;"EX",210000;"NUXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Element type
        if paramsshaft1.Order==1
            ET.name='185';
        else
            ET.name='186';
        end
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Ass=AddSensor(Ass,'Stress',1);
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        %% Output to ANSYS
        ANSYS_Output(Ass);
        ANSYSSolve(Ass)
        PlotSensor(Ass,1)

    case 10
        % Shaft 7
        inputshaft1.Length = [7;8;29;53;71;77;107;108;115];
        inputshaft1.ID = [[6.6,6.6];[6.6,0];[0,0];[0,0];[0,0];[0,0];[0,0];[0,6.6];[6.6,6.6]];
        inputshaft1.OD = [[22.5,22.5];[22.5,22.5];[22.5,22.5];[26.5,26.5];[26.5,29.5];[29.5,29.5];...
            [36,36];[36,36];[36,36]];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        %% Add assembly
        Ass=Assembly('Common_shaft_BeamModel');
        Ass=AddPart(Ass,obj1.output.BeamMesh.Meshoutput);
        % Boundary
        Ass=AddBoundary(Ass,1,'No',1);
        Bound1=[1,1,1,1,1,1];
        Ass=SetBoundaryType(Ass,1,Bound1);
        % Material
        mat.table=["EX",2.1e5;"PRXY",0.3];
        Ass=AddMaterial(Ass,mat);
        Ass=SetMaterial(Ass,1,1);
        % Add load
        Ass=AddLoad(Ass,1,'No',101);
        Load1=[0,-1e4,0,0,0,0];
        Ass=SetLoad(Ass,1,Load1);
        % Element type
        ET.name='188';
        ET.opt=[];
        ET.R=[];
        Ass=AddET(Ass,ET);
        Ass=SetET(Ass,1,1);
        Ass=BeamK(Ass,1);
        % Section
        Section=obj1.output.BeamMesh.Section;
        Ass=DividePart(Ass,1,mat2cell((1:size(Section,1))',ones(1,size(Section,1))));
        for i=1:size(Section,1)
            Ass=AddSection(Ass,Section{i,1});
            Ass=SetSection(Ass,i,i);
        end
        Plot(Ass,'boundary',1,'load',1,'load_scale',0.1);
        %% Output to ANSYS
        Ass=AddSensor(Ass,'U',1);
        opt.ANTYPE=0;
        Ass=AddSolu(Ass,opt);
        %% Output to ANSYS
        ANSYS_Output(Ass);
        ANSYSSolve(Ass)
        PlotSensor(Ass,1)
    case 11
        inputShaft1.Length = [6.4;22;50;55;78;145];
        inputShaft1.ID = [[180,133];[40,40];[40,40];[40,40];[8.5,8.5];[20,20]];
        inputShaft1.OD = [[210,210];[210,130];[130,130];[89,89];[89,89];[65,65]];
        paramsShaft1 = struct();
        obj1 = shaft.Commonshaft(paramsShaft1, inputShaft1);
        obj1 = obj1.solve();
        Plot3D(obj1,'faceno',102);
        f=@(r)sqrt(250^2-r.^2)+22-sqrt(250^2-65^2);
        obj1=DeformFace(obj1,102,f);
        Plot3D(obj1);
    case 12
        Shaft2_Height=243.7;
        Shaft2_Step_Height=20;
        inputShaft2.Length = [40;117.7;201.7;Shaft2_Height-Shaft2_Step_Height;Shaft2_Height];
        inputShaft2.OD = [[35,35];[42,42];[65,65];[90,90];[54,54]];
        inputShaft2.ID = [[10,10];[10,10];[10,10];[10,10];[10,10]];
        inputShaft2.Meshsize=15;
        paramsShaft2.E_Revolve = 60;
        obj1 = shaft.Commonshaft(paramsShaft2, inputShaft2);
        obj1 = obj1.solve();
        Plot3D(obj1,'faceno',101);
    case 13
        % Shaft 2
        inputshaft1.Length = 120;
        inputshaft1.ID = [6,6];
        inputshaft1.OD = [36,36];
        paramsshaft1 = struct();
        obj1 = shaft.Commonshaft(paramsshaft1, inputshaft1);
        obj1 = obj1.solve();
        Plot2D(obj1);
        Plot3D(obj1);
        OutputSTL(obj1)
        % Load stl file
        L=Layer('test');
        Name=strcat(obj1.params.Name,'.stl');
        L=STLRead(L,Name);
        Plot(L);
end
end