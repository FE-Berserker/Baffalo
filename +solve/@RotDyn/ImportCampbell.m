function obj=ImportCampbell(obj,filename,NMode)
% Import Campbell results
% Author : Xie Yu
%% Intial

NSpeed=size(obj.input.Speed,2);
if NSpeed>6
    a=floor(NSpeed/6);
    b=mod(NSpeed,6);
else
    a=0;
    b=0;
end

if NSpeed<=6
    formatSpec1 = '%6f%5C';
    for i=1:NSpeed
        formatSpec1 = strcat(formatSpec1,'%15f');
    end
    formatSpec1 = strcat(formatSpec1,'%[^\n\r]');
else
    formatSpec1 = '%6f%5C%15f%15f%15f%15f%15f%15f%[^\n\r]';
    if b>0
        formatSpec2 = '%6f%5C';
        for i=1:b
            formatSpec2 = strcat(formatSpec2,'%15f');
        end
        formatSpec2 = strcat(formatSpec2,'%[^\n\r]');
    end
end


%% Open file
fileID = fopen(filename,'r');
%% Data read
for i=1:1
    Temp=textscan(fileID, '%[^\n\r]', 1, 'WhiteSpace', '', 'ReturnOnError', false);
    while Temp{1,1}{1,1}(1:11)~="  Spin(rpm)"
        Temp=textscan(fileID, '%[^\n\r]', 1, 'WhiteSpace', '', 'ReturnOnError', false);
    end
    dataArray= textscan(fileID, formatSpec1,NMode, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray=dataArray(1,1:end-1);
end

if a>1
    for i=2:a
        Temp=textscan(fileID, '%[^\n\r]', 1, 'WhiteSpace', '', 'ReturnOnError', false);
        while Temp{1,1}{1,1}(1:11)~="  Spin(rpm)"
            Temp=textscan(fileID, '%[^\n\r]', 1, 'WhiteSpace', '', 'ReturnOnError', false);
        end
        dataArray1 = textscan(fileID, formatSpec1, NMode, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
        dataArray=[dataArray,dataArray1(1,3:end-1)];
    end
end

if b>0
    Temp=textscan(fileID, '%[^\n\r]', 1, 'WhiteSpace', '', 'ReturnOnError', false);
    while Temp{1,1}{1,1}(1:11)~="  Spin(rpm)"
        Temp=textscan(fileID, '%[^\n\r]', 1, 'WhiteSpace', '', 'ReturnOnError', false);
    end
    dataArray1 = textscan(fileID, formatSpec2, NMode, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray=[dataArray,dataArray1(1,3:end-1)]; 
end
%% Close file
fclose(fileID);

%% Parse
VariableNames = {'Num', 'Status'};
Numvar=size(obj.input.Speed,2)+2;
for i=3:Numvar
    VariableNames =[VariableNames,strcat('rpm',num2str(i-2))]; %#ok<AGROW> 
end

Num=dataArray{1};
Status=dataArray{2};
Campbell = table(Num,Status,dataArray{3:end},'VariableNames',VariableNames);
obj.output.Campbell=Campbell;
end