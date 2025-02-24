function Temperatureprint(obj,fid)
% Print Temperature to ANSYS
% Author : Xie Yu
for i=1:size(obj.Temperature,1)
    Num=obj.Temperature(1,1);
    fprintf(fid, '%s\n','ALLSEL,ALL');
    Sen=strcat('CMSEL,S,Part',num2str(Num));
    fprintf(fid, '%s\n',Sen);
    fprintf(fid, '%s\n','NSLE,S');
    Sen=strcat('BF,ALL,TEMP,',num2str(obj.Temperature(1,2)));
    fprintf(fid, '%s\n',Sen);
end
fprintf(fid, '%s\n','ALLSEL,ALL');
end

