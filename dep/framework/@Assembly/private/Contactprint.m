function Contactprint(obj,fid)
% Contact print
% Author: Xie Yu

fprintf(fid, '%s\n','ESEL,ALL');
m=GetNET(obj);
[n,~]=size(obj.ContactPair);
for i=1:n
    ETnum=obj.ContactPair{i,1}.Con.ET;
    Matnum=obj.ContactPair{i,1}.mat;
    ConName=obj.ET{ETnum,1}.name;
    switch ConName
        case "173"
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(ETnum)));
            fprintf(fid, '%s\n',strcat('REAL,',num2str(m+i)));
            fprintf(fid, '%s\n',strcat('Mat,',num2str(Matnum)));
            nn=size(obj.ContactPair{i,1}.RealConstants,1);
            fprintf(fid, '%s\n',strcat('R,',num2str(m+i),','));
            for j=1:nn
                R=obj.ContactPair{i,1}.RealConstants;
                fprintf(fid, '%s\n',strcat('RMODIF,',num2str(m+i),',',num2str(R(j,1)),',',num2str(R(j,2))));
            end

            nodes=unique(obj.ContactPair{i,1}.Con.elements);
            fprintf(fid, '%s\n',strcat('NSEL,S,NODE,,',num2str(nodes(1,1))));
            for j=2:size(nodes,1)
                fprintf(fid, '%s\n',strcat('NSEL,A,NODE,,',num2str(nodes(j,1))));
            end
            fprintf(fid, '%s\n','ESURF');
        case "174"
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(ETnum)));
            fprintf(fid, '%s\n',strcat('REAL,',num2str(m+i)));
            fprintf(fid, '%s\n',strcat('Mat,',num2str(Matnum)));
            nn=size(obj.ContactPair{i,1}.RealConstants,1);
            fprintf(fid, '%s\n',strcat('R,',num2str(m+i),','));
            for j=1:nn
                R=obj.ContactPair{i,1}.RealConstants;
                fprintf(fid, '%s\n',strcat('RMODIF,',num2str(m+i),',',num2str(R(j,1)),',',num2str(R(j,2))));
            end

            nodes=unique(obj.ContactPair{i,1}.Con.elements);
            fprintf(fid, '%s\n',strcat('NSEL,S,NODE,,',num2str(nodes(1,1))));
            for j=2:size(nodes,1)
                fprintf(fid, '%s\n',strcat('NSEL,A,NODE,,',num2str(nodes(j,1))));
            end
            fprintf(fid, '%s\n','ESURF');
        case "175"
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(ETnum)));
            fprintf(fid, '%s\n',strcat('REAL,',num2str(m+i)));
            fprintf(fid, '%s\n',strcat('Mat,',num2str(Matnum)));
            nn=size(obj.ContactPair{i,1}.RealConstants,1);
            fprintf(fid, '%s\n',strcat('R,',num2str(m+i),','));
            for j=1:nn
                R=obj.ContactPair{i,1}.RealConstants;
                fprintf(fid, '%s\n',strcat('RMODIF,',num2str(m+i),',',num2str(R(j,1)),',',num2str(R(j,2))));
            end

            nodes=unique(obj.ContactPair{i,1}.Con.elements);
            fprintf(fid, '%s\n','NSEL,ALL');
            for j=1:size(nodes,1)
                fprintf(fid, '%s\n',strcat('E,',num2str(nodes(j,1))));
            end
    end

    ETnum=obj.ContactPair{i,1}.Tar.ET;
    TarPartnum=obj.ContactPair{i,1}.Tar.Part;
    if TarPartnum~=0
        fprintf(fid, '%s\n','NSEL,ALL');
        fprintf(fid, '%s\n',strcat('TYPE,',num2str(ETnum)));
        nodes=unique(obj.ContactPair{i,1}.Tar.elements);
        fprintf(fid, '%s\n',strcat('NSEL,S,NODE,,',num2str(nodes(1,1))));
        for j=2:size(nodes,1)
            fprintf(fid, '%s\n',strcat('NSEL,A,NODE,,',num2str(nodes(j,1))));
        end
        fprintf(fid, '%s\n','ESURF');
    else
        fprintf(fid, '%s\n','NSEL,ALL');
        fprintf(fid, '%s\n',strcat('TYPE,',num2str(ETnum)));
        fprintf(fid, '%s\n','TSHAP,PILO');
        nodes=unique(obj.ContactPair{i,1}.Tar.elements);
        for j=1:size(nodes,1)
            fprintf(fid, '%s\n',strcat('E,',num2str(nodes(j,1))));
        end
    end
end
fprintf(fid, '%s\n','ALLSEL,ALL');
end

