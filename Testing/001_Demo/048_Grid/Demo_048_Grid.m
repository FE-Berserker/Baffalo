clc
clear
close all
% Demo Grid
% 1. Create Grid Type 1
% 2. Create Grid Type 2
% 3. Create Grid Type 3
% 4. Create Grid Type 4
% 5. Output STL file
flag=5;
DemoGrid(flag);

function DemoGrid(flag)
switch flag
    case 1
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[34,40];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[34,40];

        Section{3,1}.type="beam";
        Section{3,1}.subtype="CTUBE";
        Section{3,1}.data=[34,40];

        Section{4,1}.type="beam";
        Section{4,1}.subtype="CTUBE";
        Section{4,1}.data=[34,40];

        inputStruct.lx=1000;
        inputStruct.ly=1200;
        inputStruct.lz=-1000;
        inputStruct.nx=7;
        inputStruct.ny=9;
        inputStruct.Load=200;

        paramsStruct.Section=Section;
        obj= structure.Grid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
    case 2
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[34,40];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[34,40];

        Section{3,1}.type="beam";
        Section{3,1}.subtype="CTUBE";
        Section{3,1}.data=[34,40];

        Section{4,1}.type="beam";
        Section{4,1}.subtype="CTUBE";
        Section{4,1}.data=[34,40];

        inputStruct.lx=1000;
        inputStruct.ly=1200;
        inputStruct.lz=-1000;
        inputStruct.nx=6;
        inputStruct.ny=10;
        inputStruct.Load=200;

        paramsStruct.Section=Section;
        paramsStruct.Type=2;
        paramsStruct.LoadPosition=2;
        obj= structure.Grid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
    case 3
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[34,40];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[34,40];

        Section{3,1}.type="beam";
        Section{3,1}.subtype="CTUBE";
        Section{3,1}.data=[34,40];

        inputStruct.lx=1000;
        inputStruct.ly=1200;
        inputStruct.lz=-1000;
        inputStruct.nx=6;
        inputStruct.ny=6;
        inputStruct.Load=200;

        paramsStruct.Section=Section;
        paramsStruct.Type=3;
        paramsStruct.LoadPosition=2;
        obj= structure.Grid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
    case 4
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[34,40];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[34,40];

        Section{3,1}.type="beam";
        Section{3,1}.subtype="CTUBE";
        Section{3,1}.data=[34,40];

        inputStruct.lx=1000;
        inputStruct.ly=1200;
        inputStruct.lz=-1000;
        inputStruct.nx=6;
        inputStruct.ny=6;
        inputStruct.Load=200;

        paramsStruct.Section=Section;
        paramsStruct.Type=4;
        paramsStruct.LoadPosition=2;
        obj= structure.Grid(paramsStruct, inputStruct);
        obj= obj.solve();

        ANSYS_Output(obj.output.Assembly);
        Plot3D(obj,'BeamGeom',1,'boundary',1,'load',1,'load_scale',0.3,'endrelease',1)
    case 5
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="CTUBE";
        Section{1,1}.data=[34,40];

        Section{2,1}.type="beam";
        Section{2,1}.subtype="CTUBE";
        Section{2,1}.data=[34,40];

        Section{3,1}.type="beam";
        Section{3,1}.subtype="CTUBE";
        Section{3,1}.data=[34,40];

        Section{4,1}.type="beam";
        Section{4,1}.subtype="CTUBE";
        Section{4,1}.data=[34,40];

        inputStruct.lx=1000;
        inputStruct.ly=1200;
        inputStruct.lz=-1000;
        inputStruct.nx=7;
        inputStruct.ny=9;
        inputStruct.Load=200;
        paramsStruct.JointType=1;
        paramsStruct.Section=Section;
        obj= structure.Grid(paramsStruct, inputStruct);
        obj= obj.solve();
        OutputSTL(obj)

        l1=Layer('Layer1');
        l1=STLRead(l1,strcat(obj.params.Name,'.stl'));
        Plot(l1);

end
end
