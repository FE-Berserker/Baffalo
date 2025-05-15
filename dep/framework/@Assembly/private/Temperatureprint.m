function Temperatureprint(obj,fid)
% Print Temperature to ANSYS
% Author : Xie Yu
for i=1:size(obj.Temperature,1)
    Num=obj.Temperature(i,1);
    fprintf(fid, '%s\n','ALLSEL,ALL');
    Sen=strcat('CMSEL,S,Part',num2str(Num));
    fprintf(fid, '%s\n',Sen);
    
    switch obj.Temperature(i,3)
        case 1
            fprintf(fid, '%s\n','NSLE,S');
            Sen=strcat('BF,ALL,TEMP,',num2str(obj.Temperature(i,2)));
            fprintf(fid, '%s\n',Sen);
        case 2
            Sen=strcat('BFE,ALL,TEMP,',num2str(obj.Temperature(i,2)));
            fprintf(fid, '%s\n',Sen);
    end
end
fprintf(fid, '%s\n','ALLSEL,ALL');
end

