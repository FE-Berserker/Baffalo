function Fprint(obj,fid)
% Force output to ANSYS
% Author : Xie Yu
if ~isempty(obj.Load)
m=size(obj.Load,1);
for i=1:m
    n=size(obj.Load{i,1}.nodes,1);
    for j=1:n
        for k=1:6
            if obj.Load{i,1}.amp(j,k)~=0
                nnode=obj.Load{i,1}.nodes(j);
                switch k
                    case 1
                        Sen_F=strcat('F,',num2str(nnode),',FX,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 2
                        Sen_F=strcat('F,',num2str(nnode),',FY,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 3
                        Sen_F=strcat('F,',num2str(nnode),',FZ,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 4
                        Sen_F=strcat('F,',num2str(nnode),',MX,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 5
                        Sen_F=strcat('F,',num2str(nnode),',MY,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 6
                        Sen_F=strcat('F,',num2str(nnode),',MZ,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                end
                fprintf(fid, '%s\n',Sen_F);

            end
        end

    end
end
end
end