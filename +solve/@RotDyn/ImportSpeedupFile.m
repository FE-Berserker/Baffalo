function obj = ImportSpeedupFile(obj)
% Import speedup result file
% Author : Xie yu

KN=obj.input.KeyNode;

for i=1:size(KN,1)
    filename=strcat(num2str(KN(i,1)),'Uy.txt');
    obj.output.SpeedUp.Uy{i,1}= ImportFile(filename);
    filename=strcat(num2str(KN(i,1)),'Uz.txt');
    obj.output.SpeedUp.Uz{i,1}=  ImportFile(filename);
end

end


function U=ImportFile(filename)
%% 初始化变量。

startRow = 2;
endRow = inf;


%% 将数据列作为文本读取:
% 有关详细信息，请参阅 TEXTSCAN 文档。
formatSpec = '%11s%18s%s%[^\n\r]';

%% 打开文本文件。
fileID = fopen(filename,'r');

%% 根据格式读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% 关闭文本文件。
fclose(fileID);

%% 将包含数值文本的列内容转换为数值。
% 将非数值文本替换为 NaN。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3]
    % 将输入元胞数组中的文本转换为数值。已将非数值文本替换为 NaN。
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % 创建正则表达式以检测并删除非数值前缀和后缀。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;

            % 在非千位位置中检测到逗号。
            invalidThousandsSeparator = false;
            % if numbers.contains(',')
            %     thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
            %     if isempty(regexp(numbers, thousandsRegExp, 'once'))
            %         numbers = NaN;
            %         invalidThousandsSeparator = true;
            %     end
            % end
            % 将数值文本转换为数值。
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% 排除具有非数值单元格的行
I = ~all(cellfun(@(x) (isnumeric(x) || islogical(x)) && ~isnan(x),raw),2); % 查找具有非数值单元格的行
raw(I,:) = [];

raw(cell2mat(raw(:,1))>1e7,:)=[];
raw(1,:) = [];
%% 创建输出变量
% U = table;
U.Freq = cell2mat(raw(:, 1));
U.Real = cell2mat(raw(:, 2));
U.Imaginary = cell2mat(raw(:, 3));

end