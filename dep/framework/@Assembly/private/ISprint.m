function ISprint(obj,fid)
% Intial stress output to ANSYS
% Author : Xie Yu
if ~isempty(obj.IStress)
m=size(obj.IStress,1);
for i=1:m
    el=obj.IStress{i,1}.elements;
    Sen_IS=strcat('ESEL,S,,,',num2str(el(1,1)));
    fprintf(fid, '%s\n',Sen_IS);
    for j=2:size(el,1)
        Sen_IS=strcat('ESEL,A,,,',num2str(el(1,1)));
        fprintf(fid, '%s\n',Sen_IS);
    end
    % Sen_IS=strcat('ISTRESS,',num2str(obj.IStress{i,1}.stress));
     Sen_IS=strcat('INISTATE,DEFINE,,,,,',num2str(obj.IStress{i,1}.stress));
    fprintf(fid, '%s\n',Sen_IS);
end
fprintf(fid, '%s\n','ESEL,ALL');
end
end