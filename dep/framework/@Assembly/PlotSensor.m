function PlotSensor(obj,Num,varargin)
% Plot Assembly sensor results in Paraview
% Author : Xie Yu
% p=inputParser;
% addParameter(p,'seperate',0);
% parse(p,varargin{:});
% opt=p.Results;

Type=obj.Sensor{Num,1}.Type;
filename=strcat(obj.Name,'_Sensor',num2str(Num),'.txt');
switch Type
    case "U"
        data=importdata(filename);
        U=data.data;
        Data.Ux=U(:,2);
        Data.Uy=U(:,3);
        Data.Uz=U(:,4);
        Data.Usum=U(:,5);
        Vector.Usum=U(:,2:4);
        VTKWriteSensor(obj,Num,'PointData',Data,'PointVector',Vector,...
            'Cnode',1)
    case "Etable"
        data=importdata(filename);
        VTKWriteSensor(obj,Num,'CellData',data.data);
    case "Stress"
        data=importdata(filename);
        S=data.data;
        Data.Sx=S(:,2);
        Data.Sy=S(:,3);
        Data.Sz=S(:,4);
        Data.Sxy=S(:,5);
        Data.Syz=S(:,6);
        Data.Sxz=S(:,7);
        Vector.S=S(:,2:4);

        VTKWriteSensor(obj,Num,'PointData',Data,'PointVector',Vector);
    case "Strain"
        data=ImportElementResult(filename);
        e=data.data;
        Data.ex=e(:,2);
        Data.ey=e(:,3);
        Data.ez=e(:,4);
        Data.exy=e(:,5);
        Data.eyz=e(:,6);
        Data.exz=e(:,7);
        Vector.e=e(:,2:4);
        VTKWriteSensor(obj,Num,'PointData',Data,'PointVector',Vector);
    case "FAIL"
        Data=ImportElementResult(filename);
        VTKWriteSensor(obj,Num,'CellData',Data);
end

% Load path
opts = delimitedTextImportOptions("NumVariables", 1);
opts.DataLines = [1, 2];
opts.VariableTypes = "string";
ParaViewPath = readmatrix("ParaViewPath.txt", opts);
command= strcat('"',ParaViewPath,'"',' --data="',obj.Name,'_Sensor',num2str(Num),'.vtk"');
system(command);

end