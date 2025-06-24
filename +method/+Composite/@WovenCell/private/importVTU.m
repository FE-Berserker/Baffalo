function [Point,Cell,YarnIndex,YarnTangent,Location,SurfaceDistance,Orientation] = importVTU(FileName)
% Import texgen voxel file
% Author : Xie Yu
vtu = textscan(fopen(FileName,'r'),'%s','Delimiter','\n');
vtu = vtu{1,1};

for i=1:numel(vtu)
    if contains(vtu{i,1},'<DataArray type="Float32" NumberOfComponents="3" format="ascii">')
        if contains(vtu{i-1,1},'<Points>') == 1
            Point = sscanf(vtu{i,1}(65:end), '%f');
            Num=size(Point,1);
            Point=reshape(Point,[3,Num/3])';
        end
    end

    if contains(vtu{i,1},'<DataArray type="Int32" Name="connectivity" format="ascii">')
        if contains(vtu{i-1,1},'<Cells>') == 1
            Cell = sscanf(vtu{i,1}(60:end), '%d');
            Num=size(Cell,1);
            Cell=reshape(Cell,[8,Num/8])'+1;
        end
    end

    if contains(vtu{i,1},'<DataArray type="Int32" NumberOfComponents="1" format="ascii" Name="YarnIndex">')
        YarnIndex = sscanf(vtu{i,1}(80:end), '%d');
    end

    if contains(vtu{i,1},'<DataArray type="Float64" NumberOfComponents="3" format="ascii" Name="YarnTangent">')
        YarnTangent = sscanf(vtu{i,1}(84:end), '%f');
        Num=size(YarnTangent,1);
        YarnTangent=reshape(YarnTangent,[3,Num/3])';
    end

    if contains(vtu{i,1},'<DataArray type="Float64" NumberOfComponents="2" format="ascii" Name="Location">')
        Location = sscanf(vtu{i,1}(81:end), '%f');
        Num=size(Location,1);
        Location=reshape(Location,[2,Num/2])';
    end

    if contains(vtu{i,1},'<DataArray type="Float64" NumberOfComponents="1" format="ascii" Name="SurfaceDistance">')
        SurfaceDistance = sscanf(vtu{i,1}(88:end), '%f');
    end

    if contains(vtu{i,1},'<DataArray type="Float64" NumberOfComponents="3" format="ascii" Name="Orientation">')
        Orientation = sscanf(vtu{i,1}(84:end), '%f');
        Num=size(Orientation,1);
        Orientation=reshape(Orientation,[3,Num/3])';
    end
    
end


end