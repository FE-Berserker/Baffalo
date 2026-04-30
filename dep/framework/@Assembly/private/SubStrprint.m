function SubStrprint(obj,fid)
% print SubStr to ANSYS
% Author: Xie Yu
CheckSubStr(obj)

m1=GetNET(obj);

for i=1:size(obj.SubStr,1)
    % Print element type
    Sen=strcat('ET,',num2str(m1+i),',MATRIX50');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat('TYPE,',num2str(m1+i));
    fprintf(fid, '%s\n',Sen);
    Sen=strcat('REAL,',num2str(m1+i));
    fprintf(fid, '%s\n',Sen);
    % Print SubStr
    Name=obj.SubStr{i,1}.Name;
    Sen=strcat('SE,',Name);
    fprintf(fid, '%s\n',Sen);
end

end