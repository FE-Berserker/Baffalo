function EndReleaseprint(obj,fid)
m1=size(obj.EndRelease,1);
fprintf(fid, '%s\n','ALLSEL,ALL');
for i=1:m1
    El=obj.EndRelease{i,1}.elements;
% Element Type
Sen=strcat('ESEL,S,ELEM,,',num2str(El(1,1)));
fprintf(fid, '%s\n',Sen);

if size(El,1)>1
for j=2:size(El,1)
    Sen=strcat('ESEL,A,ELEM,,',num2str(El(j,1)));
fprintf(fid, '%s\n',Sen);
end
end

fprintf(fid, '%s\n','ENDRELEASE,,-1,Ball');
end

fprintf(fid, '%s\n','ALLSEL,ALL');
end