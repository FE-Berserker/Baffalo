function Dprint(obj,fid)
m=size(obj.Boundary,1);
for i=1:m
    n=size(obj.Boundary{i,1}.nodes,1);
    for j=1:n
        for k=1:6
            if obj.Boundary{i,1}.type(j,k)==1
                nnode=obj.Boundary{i,1}.nodes(j);
                switch k
                    case 1
                        Sen_D=strcat('D,',num2str(nnode),',UX,','0');
                    case 2
                        Sen_D=strcat('D,',num2str(nnode),',UY,','0');
                    case 3
                        Sen_D=strcat('D,',num2str(nnode),',UZ,','0');
                    case 4
                        Sen_D=strcat('D,',num2str(nnode),',ROTX,','0');
                    case 5
                        Sen_D=strcat('D,',num2str(nnode),',ROTY,','0');
                    case 6
                        Sen_D=strcat('D,',num2str(nnode),',ROTZ,','0');
                end
                fprintf(fid, '%s\n',Sen_D);
            end
        end
    end
end
end