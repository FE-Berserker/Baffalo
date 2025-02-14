function obj=Union(obj,meshno)
% Union the mesh in Layer
% Author : Xie Yu

% Output to STL file
for i=1:size(meshno,1)
    m=Mesh(strcat('Temp',num2str(i)));
    m.Face=obj.Meshes{meshno(i,1),1}.Face;
    m.Vert=obj.Meshes{meshno(i,1),1}.Vert;
    STLWrite(m);
end

% Union in openSCAD
S=scadStructure('file_name', 'New', 'autosave', false); % initiate main structure
for i=1:size(meshno,1)
S1=scadStructure('file_name', 'Part', 'autosave', false); % initiate main structure
S1 = Import(S1, strcat('Temp',num2str(i),'.stl'));
S=S+S1;
end
% S.OpenGUI();
S.SaveAs(); % saving structure as stl, it's possible choose another file format
% load in Layer
obj=STLRead(obj,'New.STL');
% Clean workplace
for i=1:size(meshno,1)
    delete(strcat('Temp',num2str(i),'.stl'))
end
delete(strcat('New.stl'))
end

