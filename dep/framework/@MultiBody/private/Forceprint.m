function Forceprint(obj,fid)
% Print force to simpack
% Author : Xie Yu

% Create force
for i=1:size(obj.Force,1)
    Sen=strcat(' Spck.currentModel.createForce("$F_',num2str(i),'");');
    fprintf(fid, '%s\n',Sen);

    Sen=strcat(' var F_',num2str(i),' = Spck.currentModel.findElement("$F_',num2str(i),'");');
    fprintf(fid, '%s\n',Sen);
    Type=obj.Force{i, 1}.Type;
    Sen=strcat(' F_',num2str(i),'.type.src = ',num2str(Type),';');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' F_',num2str(i),'.from.src = "',GetMarkerName(obj,obj.Force{i, 1}.From(1,1),obj.Force{i, 1}.From(1,2)),'";');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' F_',num2str(i),'.to.src = "',GetMarkerName(obj,obj.Force{i, 1}.To(1,1),obj.Force{i, 1}.To(1,2)),'";');
    fprintf(fid, '%s\n',Sen);

    switch Type
        case 4
            if ~isempty(obj.Force{i, 1}.Par)
                Par=obj.Force{i, 1}.Par;
                for j=1:size(Par,1)                 
                    Judge=ConvertData(Par(j,1));
                    if Judge<=1
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))/1000),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=3
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))*1000),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=5
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',Par(j,2),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge==10
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))),';');
                        fprintf(fid, '%s\n',Sen);
                    end
                end
            end
        case 5
            if ~isempty(obj.Force{i, 1}.Par)
                Par=obj.Force{i, 1}.Par;
                for j=1:size(Par,1)
                    Judge=ConvertData(Par(j,1));
                    if Judge<=3
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=9
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))*1000),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=15
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',Par(j,2),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge==18
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2)))/1000,';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=23
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',Par(j,2),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge==27
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))),';');
                        fprintf(fid, '%s\n',Sen);
                    end
                end
            end

        case 43
            if ~isempty(obj.Force{i, 1}.Par)
                Par=obj.Force{i, 1}.Par;
                for j=1:size(Par,1)
                    Judge=ConvertData(Par(j,1));
                    if Judge<=3
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=6
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))/1000),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=9
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))*1000),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=12
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))/1000/pi*180),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=15
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))*1000),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=18
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))/1000/pi*180),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=30
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = "',Par(j,2),'";');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge==31
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=39
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = "',Par(j,2),'";');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=42
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))/1000),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge<=45
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))/180*pi),';');
                        fprintf(fid, '%s\n',Sen);
                    elseif Judge==46
                        Sen=strcat(' F_',num2str(i),'.par(',num2str(Judge-1),').src = ',num2str(ConvertData(Par(j,2))),';');
                        fprintf(fid, '%s\n',Sen);
                    end
                end
            end
            


    end
end

end

function ConvertData=ConvertData(data)
if isstring(data)
    ConvertData=str2double(data);
else
    ConvertData=data;
end
end