function OutputSTL(obj)
% OutputSTL - 输出壳体STL文件
% 将实体网格导出为STL格式文件
% Author: Xie Yu
%
% 注意：以下参数为可选（当前已注释）
%   'faceno' - 指定要导出的面编号
%   'face_normal' - 是否显示面法向量

%% 获取实体网格
m=obj.output.SolidMesh;
m.Name=obj.params.Name;

%% 写入STL文件
STLWrite(m);
end