function OutputSTL(obj)
% Output commonshaft to STL file
% Author : Xie Yu
m=obj.output.SolidMesh;
m.Name=obj.params.Name;
 STLWrite(m);

 %% Print
if obj.params.Echo
    fprintf('Successfully output STL file . \n');
end

end