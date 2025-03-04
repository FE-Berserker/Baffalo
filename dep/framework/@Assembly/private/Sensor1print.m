function Sensor1print(obj,fid)
% Sensor1 print to ANSYS
% Author : Xie Yu
fprintf(fid, '%s\n','/PAGE, 1E9,, 1E9,,  ! disable headers');
fprintf(fid, '%s\n','/FORMAT, , ,14,5, , ! fix floating point format');
fprintf(fid, '%s\n','/HEADER, off, off, off, off,off, off ! disable summaries');
fprintf(fid, '%s\n','/NERR,0 ! disable warnnings');
Name=obj.Name;

if size(obj.Sensor1,1)+1>200
error('Please reduce the number of sensor1 ! The number can not larger than 200 !')
end
fprintf(fid, '%s\n',strcat('NUMVAR,',num2str(size(obj.Sensor1,1)+1)));

for i=1:size(obj.Sensor1,1)
    Type=obj.Sensor1{i,1}.Type;
    switch Type
        case "Ux"
            fprintf(fid, '%s\n','ALLSEL,ALL'); 
            if isfield(obj.Sensor1{i,1},"Name")
                fprintf(fid, '%s\n',strcat('/OUTPUT,',obj.Sensor1{i,1}.Name,',txt'));
            else
                fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor1',num2str(i),',txt'));
            end
            fprintf(fid, '%s\n',strcat('NSOL,',num2str(i+1),',',num2str(obj.Sensor1{i,1}.Node),',U,X'));
            fprintf(fid, '%s\n',strcat('PRVAR,',num2str(i+1)));
            fprintf(fid, '%s\n','/OUTPUT');
        case "Uy"
            fprintf(fid, '%s\n','ALLSEL,ALL'); 
            if isfield(obj.Sensor1{i,1},"Name")
                fprintf(fid, '%s\n',strcat('/OUTPUT,',obj.Sensor1{i,1}.Name,',txt'));
            else
                fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor1',num2str(i),',txt'));
            end
            fprintf(fid, '%s\n',strcat('NSOL,',num2str(i+1),',',num2str(obj.Sensor1{i,1}.Node),',U,Y'));
            fprintf(fid, '%s\n',strcat('PRVAR,',num2str(i+1)));  
            fprintf(fid, '%s\n','/OUTPUT');
        case "Uz"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            if isfield(obj.Sensor1{i,1},"Name")
                fprintf(fid, '%s\n',strcat('/OUTPUT,',obj.Sensor1{i,1}.Name,',txt'));
            else
                fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor1',num2str(i),',txt'));
            end
            fprintf(fid, '%s\n',strcat('NSOL,',num2str(i+1),',',num2str(obj.Sensor1{i,1}.Node),',U,Z'));
            fprintf(fid, '%s\n',strcat('PRVAR,',num2str(i+1)));  
            fprintf(fid, '%s\n','/OUTPUT');
    end
end
end