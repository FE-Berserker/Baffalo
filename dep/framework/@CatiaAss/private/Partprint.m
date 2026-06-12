function Partprint(Part,fid,PartNo,Pool)
% Part print to catia
% Author ：Xie Yu

Path=Part.Path;
Offset=Part.Offset;
Seq=Part.Seq;

FileName=GetFileName(Path);
No=GetNo(FileName,Pool);

sen=strcat('Dim arrayOfVariantOfBSTR',num2str(PartNo),'(0)');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfBSTR',num2str(PartNo),'(0) = "',Path,'"');
fprintf(fid,'%s\n',sen);

sen=strcat('products1.AddComponentsFromFiles arrayOfVariantOfBSTR',num2str(PartNo),', "All"');
fprintf(fid,'%s\n',sen);

sen=strcat('Set partproduct',num2str(PartNo),' = products1.Item("',FileName,'.',num2str(No+1),'")');
fprintf(fid,'%s\n',sen);

sen=strcat('Set move',num2str(PartNo),' = partproduct',num2str(PartNo),'.Move');
fprintf(fid,'%s\n',sen);

sen=strcat('Set move',num2str(PartNo),' = move',num2str(PartNo),'.MovableObject');
fprintf(fid,'%s\n',sen);

sen=strcat('Dim arrayOfVariantOfDouble',num2str(PartNo),'(11)');
fprintf(fid,'%s\n',sen);

nodes=[1,0,0;0,1,0;0,0,1];
T=Transform(nodes);
T=Rotate(T,Offset(4),Offset(5),Offset(6),'Seq',Seq);
Temp=Solve(T);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(0) = ',num2str(Temp(1,1)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(1) = ',num2str(Temp(1,2)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(2) = ',num2str(Temp(1,3)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(3) = ',num2str(Temp(2,1)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(4) = ',num2str(Temp(2,2)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(5) = ',num2str(Temp(2,3)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(6) = ',num2str(Temp(3,1)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(7) = ',num2str(Temp(3,2)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(8) = ',num2str(Temp(3,3)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(9) = ',num2str(Offset(1)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(10) = ',num2str(Offset(2)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfDouble',num2str(PartNo),'(11) = ',num2str(Offset(3)),'');
fprintf(fid,'%s\n',sen);

sen=strcat('move',num2str(PartNo),'.Apply arrayOfVariantOfDouble',num2str(PartNo));
fprintf(fid,'%s\n',sen);
end

function No=GetNo(FileName,Pool)
% 检查 FileName 在 Pool 中出现的次数
% 输入：
%   FileName - 文件名（不含路径和扩展名）
%   Pool - 已添加的文件名列表（cell array）
% 输出：
%   No - FileName 在 Pool 中出现的次数

if isempty(Pool)
    No=0;
else
    No=sum(strcmp(FileName, Pool));
end
end