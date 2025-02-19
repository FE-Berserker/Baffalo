function SFprint(obj,fid)
% SF output to ANSYS
% Author : Xie Yu
if ~isempty(obj.SF)
m=size(obj.SF,1);
for i=1:m
    partNum=obj.SF{i,1}.part;
    el=obj.SF{i,1}.elements+obj.Part{partNum,1}.acc_el;
    n=size(el,1);
    Type=obj.SF{i,1}.type;
    switch Type
        case 'SFBEAM'
            for j=1:n
                Sen_SF=strcat(obj.SF{i,1}.type,',',num2str(el(j,1)),','...
                    ,num2str(obj.SF{i,1}.value(1,1)),','...
                    ,obj.SF{i,1}.lab);
                for k=1:size(obj.SF{i,1}.value,2)-1
                    Sen_SF=strcat(Sen_SF,',',num2str(obj.SF{i,1}.value(1,k+1)));
                end
                fprintf(fid, '%s\n',Sen_SF);
            end
        case 'SFE'
            Sen_ESEL=strcat('ESEL,S,ELEM,,',num2str(el(1,1)));
            fprintf(fid, '%s\n',Sen_ESEL);
            if n>=2
                for j=2:n
                    Sen_ESEL=strcat('ESEL,A,ELEM,,',num2str(el(j,1)));
                    fprintf(fid, '%s\n',Sen_ESEL);
                end
            end
            Sen_SFE=strcat('SFE,ALL,,',obj.SF{i,1}.lab,',,',num2str(obj.SF{i,1}.value));
            fprintf(fid, '%s\n',Sen_SFE);

            fprintf(fid, '%s\n','ESEL,ALL');


    end
end
end
end