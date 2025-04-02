function [Data,Vector]=ReadSensor(obj,Num)
% Read sensor result
% Author : Xie Yu

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

end

end