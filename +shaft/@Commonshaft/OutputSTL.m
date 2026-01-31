function OutputSTL(obj)
% OutputSTL - 输出轴到STL文件
% 将轴的实体网格导出为STL格式文件，便于3D打印或其他CAD软件使用
% Author: Xie Yu

%% 获取实体网格
m=obj.output.SolidMesh;
m.Name=obj.params.Name;

%% 写入STL文件
STLWrite(m);

%% 打印信息
if obj.params.Echo
    fprintf('Successfully output STL file . \n');
end

end
