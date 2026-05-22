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
if ~isempty(obj.Sketches)
    sen=strcat('Set hybridBodies1 = part1.HybridBodies');
    fprintf(fid,'%s\n',sen);

    sen=strcat('Set hybridBody1 = hybridBodies1.Item("几何图形集.1")');
    fprintf(fid,'%s\n',sen);

    for i=1:size(obj.Sketches,1)
        npArray=Sketchprint(obj.Sketches{i,1},fid,i,npArray);
    end
end

% Output bodys
if ~isempty(obj.Body)
    sen=strcat('Set bodies1 = part1.Bodies');
    fprintf(fid,'%s\n',sen);

    sen=strcat('Set body1 = bodies1.Item("零件几何体")');
    fprintf(fid,'%s\n',sen);

    sen=strcat('part1.InWorkObject = body1');
    fprintf(fid,'%s\n',sen);
    

    for i=1:size(obj.Body,1)
        Bodyprint(obj.Body{i,1},fid,i);
    end
end



% End sub
sen=strcat('End Sub');
fprintf(fid,'%s\n',sen);

fclose(fid);


%% Print
if opt.Echo
    fprintf('Successfully output to Catia . \n');
end
end