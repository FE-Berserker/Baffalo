function data=ImportElementResult(filename)
% Import element result from ANSYS
% Author : Xie Yu
fileID = fopen(filename);
text = textscan(fileID,'%s','Delimiter','\n');
text=text{1,1};
numCommands = numel(text);
data=[];
k=0;
for i = 1:numCommands
    if strncmp(text{i,1},'ELEMENT', 7)
        k=k+1;
        j=1;
    end
    input = sscanf(text{i,1},'%f');
    if ~isempty(input)
        data(k,j)=input(end,1); %#ok<AGROW>
        j=j+1;
    end
end
fclose(fileID);
end