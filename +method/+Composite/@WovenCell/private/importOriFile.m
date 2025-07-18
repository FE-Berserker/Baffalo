function [Ori1,Ori2]=importOriFile(FileName, dataLines)
% Load ori data
% Generated by Matlab

% 如果不指定 dataLines，请定义默认范围
if nargin < 2
    dataLines = [8, Inf];
end

%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 7);

% 指定范围和分隔符
opts.DataLines = dataLines;
opts.Delimiter = ",";

% 指定列名称和类型
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];

% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% 指定变量属性
opts = setvaropts(opts, ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7"], "ThousandsSeparator", ",");

% 导入数据
data = readtable(FileName, opts);

%% 转换为输出类型
data = table2array(data);

Ori1=data(:,2:4);
Ori2=data(:,5:7);
end