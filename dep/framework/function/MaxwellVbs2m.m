function MaxwellVbs2m(filename)
data=importdata(filename);
for i=1:length(data)
    data{i}=regexprep(data{i},'Array\(','{');
    data{i}=regexprep(data{i},'(?<![Chr\(34,143 175 143])\)','}');
    data{i}=regexprep(data{i},'o([A-Za-z]+?)\.([A-Za-z]+?) (.+)','invoke\($1, "$2",  $3');
    data{i}=regexprep(data{i},'"(.*?)"',"'$1'");
    data{i}=regexprep(data{i},"' \& Chr\(34\) \& '",'"');
    if data{i}(end)=='_'
        data{i}=regexprep(data{i},'_$','...');
    else
        data{i}=regexprep(data{i},'(.)$','$1\);');
    end
end
fid=fopen(filename,'w');
for i=1:length(data)
    fprintf(fid,[data{i},'\n']);
end
fclose(fid);
end