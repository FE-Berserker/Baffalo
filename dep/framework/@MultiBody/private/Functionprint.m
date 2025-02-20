function Functionprint(obj,fid)
% Print function to simpack
% Author : Xie Yu

% Create function
for i=1:size(obj.Function,1)
    DataType=obj.Function{i, 1}.DataType;
    IntpolType=obj.Function{i, 1}.IntpolType;
    Data=obj.Function{i, 1}.Data;
    Sen=strcat(' Spck.currentModel.createIfctn("',GetFunctionName(obj,i),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' var I_',num2str(i),'_',DataType,' = Spck.currentModel.findElement("',GetFunctionName(obj,i),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' I_',num2str(i),'_',DataType,'.intpol.type.src = ',num2str(IntpolType),';');
    fprintf(fid, '%s\n',Sen);

    switch DataType
        case 'Stiffness'
            for j=1:size(obj.Function{i,1}.Data,1)
                Sen=strcat(' I_',num2str(i),'_',DataType,'.x(',num2str(j-1),').src = ',num2str(Data(j,1)/1000),';');
                fprintf(fid, '%s\n',Sen);
                Sen=strcat(' I_',num2str(i),'_',DataType,'.y(',num2str(j-1),').src = ',num2str(Data(j,2)),';');
                fprintf(fid, '%s\n',Sen);
            end
        case 'Damping'
            for j=1:size(obj.Function{i,1}.Data,1)
                Sen=strcat(' I_',num2str(i),'_',DataType,'.x(',num2str(j-1),').src = ',num2str(Data(j,1)/1000),';');
                fprintf(fid, '%s\n',Sen);
                Sen=strcat(' I_',num2str(i),'_',DataType,'.y(',num2str(j-1),').src = ',num2str(Data(j,2)),';');
                fprintf(fid, '%s\n',Sen);
            end
        case 'RotStiffness'
            Sen=strcat(' I_',num2str(i),'_',DataType,'.x(',num2str(j-1),').src = ',num2str(Data(j,1)/180*pi),';');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat(' I_',num2str(i),'_',DataType,'.y(',num2str(j-1),').src = ',num2str(Data(j,2))/1000,';');
            fprintf(fid, '%s\n',Sen);
        case 'RotDamping'
            Sen=strcat(' I_',num2str(i),'_',DataType,'.x(',num2str(j-1),').src = ',num2str(Data(j,1)/180*pi),';');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat(' I_',num2str(i),'_',DataType,'.y(',num2str(j-1),').src = ',num2str(Data(j,2))/1000,';');
            fprintf(fid, '%s\n',Sen);
    end
    Sen=strcat(' I_',num2str(i),'_',DataType,'.plot.par(0,0).src = 1024;');
    fprintf(fid, '%s\n',Sen);

end

end