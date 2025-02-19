function CutBoundaryprint(obj,fid)
Node=obj.CutBoundary;
Sen_N=strcat('NSEL,S,NODE,,',num2str(Node(1,1)));
fprintf(fid, '%s\n',Sen_N);
m=size(Node,1);
for i=2:m
    Sen_N=strcat('NSEL,A,NODE,,',num2str(Node(i,1)));
    fprintf(fid, '%s\n',Sen_N);
end
fprintf(fid, '%s\n','NWRITE');% Write those nodes to Sub.node
fprintf(fid, '%s\n','ALLSEL,ALL'); % Restore full sets of all entities
fprintf(fid, '%s\n','NWRITE,temps,node');% Write all nodes to temps.node (for temperature interpolation)
fprintf(fid, '%s\n','SAVE');% Submodel database file submod.db
fprintf(fid, '%s\n','FINISH');
fprintf(fid, '%s\n','RESUME,coarse,db ');% Resume coarse model database (coarse.db)
fprintf(fid, '%s\n','/POST1');
fprintf(fid, '%s\n','FILE,coarse,rst');% Use coarse model results file
fprintf(fid, '%s\n','SET,LAST');% Read in desired results data
fprintf(fid, '%s\n','CBDOF');% Reads cut boundary nodes from submod.node and writes D commands to submod.cbdo
fprintf(fid, '%s\n','BFINT,temps,node');% Reads all submodel nodes from temps.node and writes BF commands to submod.bfin (for temperature interpolation)
fprintf(fid, '%s\n','FINISH');
fprintf(fid, '%s\n','RESUME');% Resume submodel database (submod.db)
fprintf(fid, '%s\n','/SOLU');

for i=1:size(obj.Solu,1)
    opt=obj.Solu{i,1};
    if isfield(opt,"NEW")
         fprintf(fid, '%s\n','/SOLU');
    end
    Name = fieldnames(opt);
    option=struct2cell(opt);
    for j=1:size(Name,1)
        sen=Name{j,1};
        for k=1:size(option{j,1},2)
            Temp=option{j,1}(1,k);
            if isstring(Temp)
                sen=strcat(sen,',',Temp);
            else
                sen=strcat(sen,',',num2str(Temp));
            end
        end
        fprintf(fid, '%s\n',sen);
    end
    fprintf(fid, '%s\n',' /INPUT,submod,cbdo');% Cut boundary DOF specifications
    fprintf(fid, '%s\n','//INPUT,submod,bfin');% Interpolated temperature specifications
end

fprintf(fid, '%s\n','SOLVE');
fprintf(fid, '%s\n','FINISH');
end