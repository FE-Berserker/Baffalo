function Matprint(obj,fid)
% Material output to ANSYS
% Author : Xie Yu
m=GetNMaterial(obj);
for i=1:m
    % Basic data print
    if ~isempty(obj.Material{i,1}.table)
        n=size(obj.Material{i,1}.table,1);
        for j=1:n
            sen=strcat('MP,',obj.Material{i,1}.table(j,1),',',num2str(i),','...
                ,obj.Material{i,1}.table(j,2));
            fprintf(fid, '%s\n',sen);
        end
    end
    % TB data print
    if ~isempty(obj.Material{i,1}.TBlab)
         n=size(obj.Material{i,1}.TBlab,2);
         sen=strcat('TB,',obj.Material{i,1}.TBlab(1,1),',',num2str(i));
         if n>=2
             for j=2:n
                 sen=strcat(sen,',',obj.Material{i,1}.TBlab(1,j));
             end
         end
        
        fprintf(fid, '%s\n',sen);
        n=size(obj.Material{i,1}.TBtable,2);
        sen=strcat('TBDATA,1');
        for j=1:n
            sen=strcat(sen,',',num2str(obj.Material{i,1}.TBtable(1,j)));
        end
        fprintf(fid, '%s\n',sen);
    end
    % Failure criterion
    if isfield(obj.Material{i,1},"FC")
        n=size(obj.Material{i,1}.FC,1);
        for j=1:n
            sen=strcat('FC,',num2str(i),',',...
                obj.Material{i,1}.FCType,',',...
                obj.Material{i,1}.FC(j,1),',',...
                obj.Material{i,1}.FC(j,2));
            fprintf(fid, '%s\n',sen);
        end
    end
end
end