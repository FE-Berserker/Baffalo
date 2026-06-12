function CatiaOutput(obj,varargin)
% Output catia assembly
% Author : Xie Yu
p=inputParser;
addParameter(p,'Echo',1);
parse(p,varargin{:});
opt=p.Results;

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


sen=strcat('Set productDocument1 = documents1.Add("Product")');
fprintf(fid,'%s\n',sen);

sen=strcat('Set product1 = productDocument1.Product');
fprintf(fid,'%s\n',sen);

sen=strcat('Set products1 = product1.Products');
fprintf(fid,'%s\n',sen);

FileNamePool=cell(size(obj.Part,1),1);
% % Output part
if ~isempty(obj.Part)
    for i=1:size(obj.Part,1)
        Path=obj.Part{i,1}.Path;
        FileName=GetFileName(Path);
        Partprint(obj.Part{i,1},fid,i,FileNamePool);
        FileNamePool{i,1}=FileName;
    end
end

% Change part number
sen=strcat('Set productDocument1 = CATIA.ActiveDocument');
fprintf(fid,'%s\n',sen);

sen=strcat('Set product1 = productDocument1.Product');
fprintf(fid,'%s\n',sen);

sen=strcat('product1.PartNumber = "',obj.Name,'"');
fprintf(fid,'%s\n',sen);

% Save catia part    
FileName=strcat('.\',obj.Name,'.CATProduct');

sen=strcat('productDocument1.SaveAs ','"',FileName,'"');
fprintf(fid,'%s\n',sen);

% End sub
sen=strcat('End Sub');
fprintf(fid,'%s\n',sen);

fclose(fid);


%% Print
if opt.Echo
    fprintf('Successfully output to Catia . \n');
end
end