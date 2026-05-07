function CatiaOutput(obj)
% Output catia part
% Author : Xie Yu

filename=obj.Name;

% Init part
filename=strcat('.\',filename,'.catvbs');
fid=fopen(filename,'w');

sen=strcat('Language="VBSCRIPT"');
fprintf(fid,'%s\n',sen);

sen=strcat('Sub CATMain()');
fprintf(fid,'%s\n',sen);

sen=strcat('Set documents1 = CATIA.Documents');
fprintf(fid,'%s\n',sen);

sen=strcat('Set partDocument1 = documents1.Add("Part")');
fprintf(fid,'%s\n',sen);

% Get geometry part
sen=strcat('Set part1 = partDocument1.Part ');
fprintf(fid,'%s\n',sen);

% Output Sketches
for i=1:size(obj.Sketches,1)
    Sketchprint(obj.Sketches{i,1},fid,i)
end

% End sub
sen=strcat('End Sub');
fprintf(fid,'%s\n',sen);

fclose(fid);

end