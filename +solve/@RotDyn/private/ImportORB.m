function ORB = ImportORB(filename, dataLines)
%IMPORTFILE 从文本文件中导入数据
%% 输入处理

% 如果不指定 dataLines，请定义默认范围
if nargin < 3
    dataLines = [5, Inf];
end

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables",7);

% 指定范围和分隔符
opts.DataLines = dataLines;
opts.Delimiter = " ";

% 指定列名称和类型
opts.VariableNames = ["Nodes", "A", "B", "PSI", "PHI", "YMAX", "ZMAX"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% 导入数据
ORB= readtable(filename, opts);

end