function SECprint(obj,fid)
% Print section to ANSYS
% Author : Xie Yu
m=size(obj.Section,1);
for i=1:m
    if isfield(obj.Section{i,1},"subtype")
        Sen_S=strcat('SECTYPE,',num2str(i),',',obj.Section{i,1}.type,',',obj.Section{i,1}.subtype);
    else
        Sen_S=strcat('SECTYPE,',num2str(i),',',obj.Section{i,1}.type);
    end
    
    fprintf(fid, '%s\n',Sen_S);
    Temp=obj.Section{i,1}.data;
    
    for j=1:size(Temp,1)
        Sen_data='SECDATA';
        for k=1:size(Temp(j,:),2)
            Sen_data=strcat(Sen_data,',',num2str(Temp(j,k)));
        end
        fprintf(fid, '%s\n',Sen_data);
    end

    if isfield(obj.Section{i,1},"offset")
        Sen_offset=strcat('SECOFFSET,',obj.Section{i,1}.offset);
        
        if isfield(obj.Section{i,1},"offsetdata")
            for k=1:size(obj.Section{i,1}.offsetdata,2)
                Sen_offset=strcat(Sen_offset,',',num2str(obj.Section{i,1}.offsetdata(j,k)));
            end

        end
        fprintf(fid, '%s\n',Sen_offset);
    end
    
end

end

