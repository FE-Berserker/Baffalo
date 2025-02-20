function Constraintprint(obj,fid)
% Print constraint to simpack
% Author : Xie Yu

% Create Constraint
for i=1:size(obj.Constraint,1)
    % Create constraint
    Sen=strcat(' Spck.currentModel.createConstr("$L_',num2str(i),'");');
    fprintf(fid, '%s\n',Sen);
    Type=obj.Constraint{i, 1}.Type;
    Sen=strcat(' var L_',num2str(i),' = Spck.currentModel.findElement("$L_',num2str(i),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' L_',num2str(i),'.type.src = ',num2str(Type),';');
    fprintf(fid, '%s\n',Sen);

    Sen=strcat(' L_',num2str(i),'.from.src = "',GetMarkerName(obj,obj.Constraint{i, 1}.From(1,1),obj.Constraint{i, 1}.From(1,2)),'";');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' L_',num2str(i),'.to.src = "',GetMarkerName(obj,obj.Constraint{i, 1}.To(1,1),obj.Constraint{i, 1}.To(1,2)),'";');
    fprintf(fid, '%s\n',Sen);
    switch Type
        case 25
            if ~isempty(obj.Constraint{i, 1}.Par)
                for j=1:size(obj.Constraint{i, 1}.Par,1)
                    Judge=obj.Constraint{i, 1}.Par(j,1)-1;
                    Sen=strcat(' L_',num2str(i),'.par(',num2str(Judge),').src = ',num2str(obj.Constraint{i, 1}.Par(j,2)),';');
                    fprintf(fid, '%s\n',Sen);
                end
            end
    end
end

end