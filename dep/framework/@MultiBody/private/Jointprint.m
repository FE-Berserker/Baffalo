function Jointprint(obj,fid)
% Print joint to simpack
% Author : Xie Yu

% Create Joint
for i=1:size(obj.Joint,1)
    ToNo=obj.Joint{i, 1}.To(1,1);
    Sen=strcat(' Body',num2str(ToNo),'.createJoint("$J_Body',num2str(ToNo),'");');
    fprintf(fid, '%s\n',Sen);
    Type=obj.Joint{i, 1}.Type;
    Sen=strcat(' var JBody_',num2str(ToNo),' = Spck.currentModel.findElement("$J_Body',num2str(ToNo),'");');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' JBody_',num2str(ToNo),'.type.src = ',num2str(Type),';');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' JBody_',num2str(ToNo),'.from.src = "',GetMarkerName(obj,obj.Joint{i, 1}.From(1,1),obj.Joint{i, 1}.From(1,2)),'";');
    fprintf(fid, '%s\n',Sen);
    Sen=strcat(' JBody_',num2str(ToNo),'.to.src = "',GetMarkerName(obj,obj.Joint{i, 1}.To(1,1),obj.Joint{i, 1}.To(1,2)),'";');
    fprintf(fid, '%s\n',Sen);
    switch Type
        case 0
            if ~isempty(obj.Joint{i, 1}.Par)
                for j=1:size(obj.Joint{i, 1}.Par,1)
                    Judge=obj.Joint{i, 1}.Par(j,1);
                    if Judge<=3
                        Sen=strcat(' JBody_',num2str(ToNo),'.par(',num2str(Judge-1),').src = "',num2str(obj.Joint{i, 1}.Par(j,2)),'deg";');
                        fprintf(fid, '%s\n',Sen);
                    else
                        Sen=strcat(' JBody_',num2str(ToNo),'.par(',num2str(Judge-1),').src = ',num2str(obj.Joint{i, 1}.Par(j,2))/1000,';');
                        fprintf(fid, '%s\n',Sen);
                    end
                end
            end
        case 1
            if ~isempty(obj.Joint{i, 1}.Pos)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.pos(0).src = "',num2str(obj.Joint{i, 1}.Pos),'deg";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Vel)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.vel(0).src = "',num2str(obj.Joint{i, 1}.Vel),'rpm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Dep)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.dep(0).src = ',num2str(obj.Joint{i, 1}.Dep),';');
                fprintf(fid, '%s\n',Sen);
            end
        case 2
            if ~isempty(obj.Joint{i, 1}.Pos)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.pos(0).src = "',num2str(obj.Joint{i, 1}.Pos),'deg";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Vel)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.vel(0).src = "',num2str(obj.Joint{i, 1}.Vel),'rpm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Dep)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.dep(0).src = ',num2str(obj.Joint{i, 1}.Dep),';');
                fprintf(fid, '%s\n',Sen);
            end

        case 3
            if ~isempty(obj.Joint{i, 1}.Pos)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.pos(0).src = "',num2str(obj.Joint{i, 1}.Pos),'deg";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Vel)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.vel(0).src = "',num2str(obj.Joint{i, 1}.Vel),'rpm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Dep)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.dep(0).src = ',num2str(obj.Joint{i, 1}.Dep),';');
                fprintf(fid, '%s\n',Sen);
            end
        case 4
            if ~isempty(obj.Joint{i, 1}.Pos)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.pos(0).src = "',num2str(obj.Joint{i, 1}.Pos),'mm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Vel)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.vel(0).src = "',num2str(obj.Joint{i, 1}.Vel),'rpm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Dep)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.dep(0).src = ',num2str(obj.Joint{i, 1}.Dep),';');
                fprintf(fid, '%s\n',Sen);
            end
        case 5
            if ~isempty(obj.Joint{i, 1}.Pos)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.pos(0).src = "',num2str(obj.Joint{i, 1}.Pos),'mm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Vel)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.vel(0).src = "',num2str(obj.Joint{i, 1}.Vel),'rpm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Dep)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.dep(0).src = ',num2str(obj.Joint{i, 1}.Dep),';');
                fprintf(fid, '%s\n',Sen);
            end
        case 6
            if ~isempty(obj.Joint{i, 1}.Pos)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.pos(0).src = "',num2str(obj.Joint{i, 1}.Pos),'mm";');
                fprintf(fid, '%s\n',Sen);
            end

            if ~isempty(obj.Joint{i, 1}.Vel)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.vel(0).src = "',num2str(obj.Joint{i, 1}.Vel),'rpm";');
                fprintf(fid, '%s\n',Sen);
            end
            if ~isempty(obj.Joint{i, 1}.Dep)
                Sen=strcat(' JBody_',num2str(ToNo),'.st.dep(0).src = ',num2str(obj.Joint{i, 1}.Dep),';');
                fprintf(fid, '%s\n',Sen);
            end

    end
end

end