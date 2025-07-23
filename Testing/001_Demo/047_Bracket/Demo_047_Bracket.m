clc
clear
close all
% Demo Bracket
% 1. Create Bracket

flag=1;
DemoBracket(flag);

function DemoBracket(flag)
switch flag
    case 1
        Ang=45/180*pi;
        Height=489;
        ratio=2/3;
        dr=1880/2;
        L=Layer('Layer');
        L=AddCurve(L,[dr*cos(Ang/2),dr*sin(Ang/2),0;dr*cos(Ang/2),dr*sin(Ang/2),Height*ratio]);
        L=AddCurve(L,[dr*cos(Ang/2),dr*sin(Ang/2),Height*ratio;dr*cos(Ang/2),dr*sin(Ang/2),Height]);
        L=AddCurve(L,[dr*cos(-Ang/2),dr*sin(-Ang/2),0;dr*cos(-Ang/2),dr*sin(-Ang/2),Height*ratio]);
        L=AddCurve(L,[dr*cos(-Ang/2),dr*sin(-Ang/2),Height*ratio;dr*cos(-Ang/2),dr*sin(-Ang/2),Height]);
        L=AddCurve(L,[dr*cos(Ang/2),dr*sin(Ang/2),Height*ratio;dr*cos(-Ang/2),dr*sin(-Ang/2),Height*ratio]);

        Plot(L)
        % Section
        Section{1,1}.type="beam";
        Section{1,1}.subtype="HREC";
        Section{1,1}.data=[130,130,10,10,10,10];

        inputStruct.Layer=L;
        inputStruct.SectionNum=ones(5,1);
        inputStruct.Meshsize=30;
        paramsStruct.Section=Section;
        obj= structure.Bracket(paramsStruct, inputStruct);
        obj= obj.solve();

        Plot3D(obj,'BeamGeom',0)
        Plot3D(obj,'BeamGeom',1)
        ANSYS_Output(obj.output.Assembly);

end
end
