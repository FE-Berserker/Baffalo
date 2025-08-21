clc
clear
close all
% Demo ShellGrid
% 1. Create ShellGrid Type 1
% 2. Create ShellGrid Type 2
% 3. Create ShellGrid Type 3
% 4. Create ShellGrid Type 4
flag=4;
DemoShellGrid(flag);

function DemoShellGrid(flag)
switch flag
    case 1
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[55,60];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[55,60];

        inputStruct.f=6800;
        inputStruct.span=30000;
        inputStruct.kn=24;
        inputStruct.nx=6;
        inputStruct.PP=2000/10^6;

        paramsStruct.Section=Section;
        obj= structure.ShellGrid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
    case 2
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[55,60];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[55,60];

        Section{3,1}.type="beam";
        Section{3,1}.subtype="CTUBE";
        Section{3,1}.data=[55,60];

        inputStruct.f=6800;
        inputStruct.span=30000;
        inputStruct.kn=24;
        inputStruct.nx=6;
        inputStruct.VP=2000/10^6;

        paramsStruct.Section=Section;
        paramsStruct.Type=2;
        obj= structure.ShellGrid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
    case 3
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[55,60];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[55,60];

        inputStruct.f=6800;
        inputStruct.span=30000;
        inputStruct.kn=24;
        inputStruct.nx=6;
        inputStruct.VP=2000/10^6;

        paramsStruct.Section=Section;
        paramsStruct.Type=3;
        obj= structure.ShellGrid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
    case 4
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[55,60];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[55,60];

        inputStruct.f=6800;
        inputStruct.span=30000;
        inputStruct.kn=8;
        inputStruct.nx=6;
        inputStruct.VP=2000/10^6;

        paramsStruct.Section=Section;
        paramsStruct.Type=4;
        obj= structure.ShellGrid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
end
end
