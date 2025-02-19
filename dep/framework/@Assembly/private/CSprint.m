function CSprint(obj,fid)
[m,~]=size(obj.CS);
for i=1:m
    Sen=strcat('LOCAL,',num2str(i+10));
    for j=1:7
        Sen=strcat(Sen,',',num2str(obj.CS(i,j)));
    end
    fprintf(fid, '%s\n',Sen);
end
end

