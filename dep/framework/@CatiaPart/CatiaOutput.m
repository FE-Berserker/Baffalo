function CatiaOutput(obj,varargin)
% Output catia part
% Author : Xie Yu
p=inputParser;
addParameter(p,'Echo',1);
parse(p,varargin{:});
opt=p.Results;

filename=obj.Name;
npArray=0;

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
    npAppay=Sketchprint(obj.Sketches{i,1},fid,i,npArray);
end

% Output bodys

% End sub
sen=strcat('End Sub');
fprintf(fid,'%s\n',sen);

fclose(fid);


%% Print
if opt.Echo
    fprintf('Successfully output to Catia . \n');
end
end