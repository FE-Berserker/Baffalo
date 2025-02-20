function Bodyprint(obj,fid)
% Print body to simpack
% Author : Xie Yu
fprintf(fid, '%s\n','function main(args)');
fprintf(fid, '%s\n','{');
fprintf(fid, '%s\n','try');
fprintf(fid, '%s\n','{');

fprintf(fid, '%s\n',' var myScriptName = Spck.getScriptName();');
fprintf(fid, '%s\n',' var myScriptFile = new File(myScriptName);');
fprintf(fid, '%s\n',' var myModelName = myScriptFile.path + "/" + myScriptFile.baseName + ".spck";');
fprintf(fid, '%s\n',' // Open the model');
fprintf(fid, '%s\n',' var myModel = Spck.openModel(myModelName);');
fprintf(fid, '%s\n',' // Perform Test Call'); 
fprintf(fid, '%s\n',' Spck.Slv.test(myModel);'); 
   
% Create Body
for i=1:size(obj.Body,1)
    Sen=strcat(' var Body',num2str(i),' = myModel.createBody("$B_Body',num2str(i),'",false);');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.flx.file.src = "',obj.Body{i,1}.Path,'\',obj.Body{i,1}.Name,'.fbi";');
    Sen=strrep(Sen,'\','/');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.type.src = 1;');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.flx.eigenmodes.kind.src = 3;');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.flx.eigenmodes.freqrange.min.src = 0.1;');
    fprintf(fid, '%s\n',Sen);
    position=obj.Body{i,1}.Position;
    Sen=strcat(' Body',num2str(i),'.brf.st.pos(0).src = ',num2str(position(1)/1000),';');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.brf.st.pos(1).src = ',num2str(position(2)/1000),';');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.brf.st.pos(2).src = ',num2str(position(3)/1000),';');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.brf.st.pos(3).src = "',num2str(position(4)),'deg";');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.brf.st.pos(4).src = "',num2str(position(5)),'deg";');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'.brf.st.pos(5).src = "',num2str(position(6)),'deg";');
    fprintf(fid, '%s\n',Sen);

    Sen=strcat(' Body',num2str(i),'.createPrim("$P_Body',num2str(i),'_Flex");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' var Body',num2str(i),'_P = Spck.currentModel.findElement("$P_Body',num2str(i),'_Flex");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'_P.type.src = 28;');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'_P.par(2).src = 1;');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'_P.par(3).src = 1;');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' Body',num2str(i),'_P.mp.incl.src = 0;');
    fprintf(fid, '%s\n',Sen);

    for j=1:size(obj.Body{i,1}.Marker,1)
        Marker=obj.Body{i,1}.Marker;
        Sen=strcat(' Body',num2str(i),'.createMarker("$M_Body',num2str(i),'_',num2str(Marker(j,1)),'");');
        fprintf(fid, '%s\n',Sen);
        Sen=strcat(' var Body',num2str(i),'_M',num2str(Marker(j,1)),' = Spck.currentModel.findElement("$M_Body',num2str(i),'_',num2str(Marker(j,1)),'");');
        fprintf(fid, '%s\n',Sen);
        Sen=strcat(' Body',num2str(i),'_M',num2str(Marker(j,1)),'.type.src = 1;');
        fprintf(fid, '%s\n',Sen);
        Sen=strcat(' Body',num2str(i),'_M',num2str(Marker(j,1)),'.flx.type.src = 3;');
        fprintf(fid, '%s\n',Sen);
        Sen=strcat(' Body',num2str(i),'_M',num2str(Marker(j,1)),'.flx.node(0).src = ',num2str(Marker(j,1)),';');
        fprintf(fid, '%s\n',Sen);
    end
 
    Sen=strcat(' Spck.currentModel.destroy("$P_Body',num2str(i),'");');
    fprintf(fid, '%s\n',Sen);

end

end