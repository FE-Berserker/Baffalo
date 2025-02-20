function Refprint(obj,fid)
% Print Reference to simpack
% Author : Xie Yu

% Create Ref
Sen=strcat(' var ISYS = Spck.currentModel.findElement("$R_Isys")');
fprintf(fid, '%s\n',Sen);

for i=2:size(obj.Ref,1)
    Sen=strcat(' ISYS.createMarker("$M_Isys_',num2str(i-1),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' var MSYS_',num2str(i-1),' = Spck.currentModel.findElement("$M_Isys_',num2str(i-1),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' MSYS_',num2str(i-1),'.type.src = ',num2str(obj.Ref{i,1}.Type),';');
    fprintf(fid, '%s\n',Sen);

    if ~isempty(obj.Ref{i,1}.Par)
        for j=1:size(obj.Ref{i,1}.Par,1)
            Judge=obj.Ref{i,1}.Par(j,1)-1;
            Sen=strcat(' MSYS_',num2str(i-1),'.par(',num2str(Judge),').src = ',num2str(obj.Ref{i,1}.Par(j,2)),';');
            fprintf(fid, '%s\n',Sen);
        end
    end

    if ~isempty(obj.Ref{i,1}.Pos)
        for j=1:size(obj.Ref{i,1}.Pos,2)
            Sen=strcat(' MSYS_',num2str(i-1),'.pos(',num2str(j-1),').src = ',num2str(obj.Ref{i,1}.Pos(j)/1000),';');
            fprintf(fid, '%s\n',Sen);
        end
    end

    if ~isempty(obj.Ref{i,1}.Ang)
        for j=1:size(obj.Ref{i,1}.Ang,2)
            Sen=strcat(' MSYS_',num2str(i-1),'.ang(',num2str(j-1),').src = "',num2str(obj.Ref{i,1}.Ang(j)),'deg";');
            fprintf(fid, '%s\n',Sen);
        end
    end

end

end