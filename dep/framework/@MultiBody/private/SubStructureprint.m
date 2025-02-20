function SubStructureprint(obj,filename,fid)
% Print SubStructure to simpack
% Author : Xie Yu

fclose(fid);

for i=1:size(obj.SubStructure,1)
    TempSub=obj.SubStructure{i,1}.Multi;
    Simpack_Output(TempSub);
end

fid=fopen(filename,'a');

for i=1:size(obj.SubStructure,1)
    Sen=strcat(' Spck.currentModel.createSubstr("$S_SubStructure_',num2str(i),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' var SubStructure_',num2str(i),' = Spck.currentModel.findElement("$S_SubStructure_',num2str(i),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' SubStructure_',num2str(i),'.id.src = "',num2str(i),'";');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' SubStructure_',num2str(i),'.file.src = "./',obj.SubStructure{i,1}.Multi.Name,'-mod.spck";');
    fprintf(fid, '%s\n',Sen);
end

end