function WriteSTL(obj)
%WRITESTL Write STL file of mesh
file=strcat(obj.Name,'.stl');
Fv.vertices=[obj.Vert,zeros(size(obj.Vert,1),1)];
Fv.faces=obj.Face;
if size(Fv.faces,1)==4
    error('can not ouput quad element to STL file')
else
    stlWrite(file,Fv);
end

end

