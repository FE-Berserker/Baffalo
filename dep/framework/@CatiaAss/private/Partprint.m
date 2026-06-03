function Partprint(Part,fid,PartNo)
% Part print to catia
% Author ：Xie Yu

Path=Part.Path;
Offset=Part.Offset;
Seq=Part.Seq;

FileName=GetFileName(Path);

sen=strcat('Dim arrayOfVariantOfBSTR',num2str(PartNo),'(0)');
fprintf(fid,'%s\n',sen);

sen=strcat('arrayOfVariantOfBSTR',num2str(PartNo),'(0) = "',Path,'"');
fprintf(fid,'%s\n',sen);

sen=strcat('products1.AddComponentsFromFiles arrayOfVariantOfBSTR',num2str(PartNo),', "All"');
fprintf(fid,'%s\n',sen);

sen=strcat('Set product2 = products1.Item("',FileName,'.1")');
fprintf(fid,'%s\n',sen);

sen=strcat('Set move1 = product2.Move');
fprintf(fid,'%s\n',sen);

sen=strcat('Set move1 = move1.MovableObject');
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

sen=strcat('move1.Apply arrayOfVariantOfDouble',num2str(PartNo));
fprintf(fid,'%s\n',sen);
end