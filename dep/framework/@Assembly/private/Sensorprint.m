function Sensorprint(obj,fid)
% Sensor print to ANSYS
% Author : Xie Yu
fprintf(fid, '%s\n','/PAGE, 1E9,, 1E9,,  ! disable headers');
fprintf(fid, '%s\n','/FORMAT, , ,14,5, , ! fix floating point format');
fprintf(fid, '%s\n','/HEADER, off, off, off, off,off, off ! disable summaries');
fprintf(fid, '%s\n','/NERR,0 ! disable warnnings');
Name=obj.Name;
for i=1:size(obj.Sensor,1)
    Type=obj.Sensor{i,1}.Type;
    switch Type
        case "SetList"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            fprintf(fid, '%s\n',strcat('/OUTPUT,',obj.Sensor{i,1}.Name,',txt'));
            fprintf(fid, '%s\n','SET,LIST');
            fprintf(fid, '%s\n','/OUTPUT');
        case "Freq"
            fprintf(fid, '%s\n','ALLSEL,ALL');        
            fprintf(fid, '%s\n',strcat('*CFOPEN,',Name,'_Sensor',num2str(i),'.txt'));
            sen=strcat('*DO,i,',num2str(obj.Sensor{i,1}.Mode(1,1)),',',num2str(obj.Sensor{i,1}.Mode(1,2)));
            fprintf(fid, '%s\n',sen);
            fprintf(fid, '%s\n','SET,,, ,,, ,i');
            fprintf(fid, '%s\n','*Vwrite,FF');
            fprintf(fid, '%s\n','(1f16.3)');
            fprintf(fid, '%s\n','*ENDDO');
            fprintf(fid, '%s\n','*cfclos');
        case "SENE"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            fprintf(fid, '%s\n',strcat('CMSEL,S,Part',num2str(obj.Sensor{i,1}.Part(1,1))));
            if size(obj.Sensor{i,1}.Part,1)>1
                for j=2:size(obj.Sensor{i,1}.Part,1)
                    fprintf(fid, '%s\n',strcat('CMSEL,A,Part',num2str(obj.Sensor{i,1}.Part(j,1))));
                end
            end
            fprintf(fid, '%s\n',strcat('*CFOPEN,',Name,'_Sensor',num2str(i),'.txt'));
            sen=strcat('*DO,i,',num2str(obj.Sensor{i,1}.Mode(1,1)),',',num2str(obj.Sensor{i,1}.Mode(1,2)));
            fprintf(fid, '%s\n',sen);
            fprintf(fid, '%s\n','SET,,, ,,, ,i');
            fprintf(fid, '%s\n','ETABLE,SE,SENE');
            fprintf(fid, '%s\n','SSUM');
            fprintf(fid, '%s\n','*GET,FF,MODE,i,FREQ');
            fprintf(fid, '%s\n','*GET,SS,SSUM,0,ITEM,SE');
            fprintf(fid, '%s\n','*Vwrite,SS');
            fprintf(fid, '%s\n','(1f16.3)');
            fprintf(fid, '%s\n','*ENDDO');
            fprintf(fid, '%s\n','*cfclos');
        case "Campbell"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            fprintf(fid, '%s\n','/OUTPUT,Campbell,txt');
            fprintf(fid, '%s\n','PRCAMP,,,RPM,,,,1');
            fprintf(fid, '%s\n','/OUTPUT');
        case "ORB"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            Set=obj.Sensor{i,1}.Set;
            fprintf(fid, '%s\n',strcat('SET,',num2str(Set(1,1)),',',num2str(Set(1,2))));
            fprintf(fid, '%s\n',strcat('/OUTPUT,ORB',num2str(Set(1,1)),'_',num2str(Set(1,2)),',txt'));
            fprintf(fid, '%s\n','PRORB');
            fprintf(fid, '%s\n','/OUTPUT');
        case "U"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            fprintf(fid, '%s\n','NSLE,R,CORNER');
            Set=obj.Sensor{i,1}.Set;
            if isempty(Set)
                fprintf(fid, '%s\n','SET,LAST');
            elseif size(Set,2)==1
                fprintf(fid, '%s\n',strcat('SET,,,,,,,',num2str(Set)));
            elseif size(Set,2)==2
                fprintf(fid, '%s\n',strcat('SET,',num2str(Set(1)),',',num2str(Set(2))));
            end
            if isempty(obj.Sensor{i,1}.Name)
                fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor',num2str(i),',txt'));
            else
                fprintf(fid, '%s\n',strcat('/OUTPUT,',obj.Sensor{i,1}.Name,',txt'));
            end
            fprintf(fid, '%s\n','PRNSOL,U');
            fprintf(fid, '%s\n','/OUTPUT');
        case "Stress"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            % Sys
            Sys=obj.Sensor{i,1}.Sys;
            if ~isempty(Sys)
                if Sys=="LSYS"
                    fprintf(fid, '%s\n','RSYS,LSYS');
                else
                    fprintf(fid, '%s\n',strcat('RSYS,',num2str(Sys)));
                end
            end
            % Set
            Set=obj.Sensor{i,1}.Set;
            if isempty(Set)
                fprintf(fid, '%s\n','SET,LAST');
            else
                fprintf(fid, '%s\n',strcat('SET,,,,,,,',num2str(Set)));
            end
            % Part
            fprintf(fid, '%s\n',strcat('CMSEL,S,Part',num2str(obj.Sensor{i,1}.Part(1,1))));
            if size(obj.Sensor{i,1}.Part,1)>1
                for j=2:size(obj.Sensor{i,1}.Part,1)
                    fprintf(fid, '%s\n',strcat('CMSEL,A,Part',num2str(obj.Sensor{i,1}.Part(j,1))));
                end
            end
            % Corner
            if obj.Sensor{i,1}.Corner==1
                fprintf(fid, '%s\n','NSLE,R,CORNER');
            end

            if isempty(obj.Sensor{i,1}.Name)
                fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor',num2str(i),',txt'));
            else
                fprintf(fid, '%s\n',strcat('/OUTPUT,',obj.Sensor{i,1}.Name,',txt'));
            end
            fprintf(fid, '%s\n','PRNSOL,S');
            fprintf(fid, '%s\n','/OUTPUT');
        case "Strain"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            % Sys
            Sys=obj.Sensor{i,1}.Sys;
            if ~isempty(Sys)
                if Sys=="LSYS"
                    fprintf(fid, '%s\n','RSYS,LSYS');
                else
                    fprintf(fid, '%s\n',strcat('RSYS,',num2str(Sys)));
                end
            end
            % Set
            Set=obj.Sensor{i,1}.Set;
            if isempty(Set)
                fprintf(fid, '%s\n','SET,LAST');
            else
                fprintf(fid, '%s\n',strcat('SET,,,,,,,',num2str(Set)));
            end
            % Part
            fprintf(fid, '%s\n',strcat('CMSEL,S,Part',num2str(obj.Sensor{i,1}.Part(1,1))));
            if size(obj.Sensor{i,1}.Part,1)>1
                for j=2:size(obj.Sensor{i,1}.Part,1)
                    fprintf(fid, '%s\n',strcat('CMSEL,A,Part',num2str(obj.Sensor{i,1}.Part(j,1))));
                end
            end
            % Corner
            if obj.Sensor{i,1}.Corner==1
                fprintf(fid, '%s\n','NSLE,R,CORNER');
            end

            if isempty(obj.Sensor{i,1}.Name)
                fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor',num2str(i),',txt'));
            else
                fprintf(fid, '%s\n',strcat('/OUTPUT,',obj.Sensor{i,1}.Name,',txt'));
            end
            fprintf(fid, '%s\n','PRNSOL,EPEL');
            fprintf(fid, '%s\n','/OUTPUT');

        case "Etable"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            % Set
            Set=obj.Sensor{i,1}.Set;
            if isempty(Set)
                fprintf(fid, '%s\n','SET,LAST');
            else
                fprintf(fid, '%s\n',strcat('SET,,,,,,,',num2str(Set)));
            end
            % Part
            fprintf(fid, '%s\n',strcat('CMSEL,S,Part',num2str(obj.Sensor{i,1}.Part(1,1))));
            if size(obj.Sensor{i,1}.Part,1)>1
                for j=2:size(obj.Sensor{i,1}.Part,1)
                    fprintf(fid, '%s\n',strcat('CMSEL,A,Part',num2str(obj.Sensor{i,1}.Part(j,1))));
                end
            end
            fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor',num2str(i),',txt'));
            Option=obj.Sensor{i,1}.Option;
            Num=obj.Sensor{i,1}.TableNum;
            Name=strcat(Option,num2str(obj.Sensor{i,1}.Part(1,1)));
            fprintf(fid, '%s\n',strcat('ETABLE,',Name,',',Option,',',num2str(Num)));
            fprintf(fid, '%s\n',strcat('PRETAB,',Name));
            fprintf(fid, '%s\n','/OUTPUT');
        case "FAIL"
            fprintf(fid, '%s\n','ALLSEL,ALL');
            % Set
             Set=obj.Sensor{i,1}.Set;
            if isempty(Set)
                fprintf(fid, '%s\n','SET,LAST');
            else
                fprintf(fid, '%s\n',strcat('SET,,,,,,,',num2str(Set)));
            end
            % Part
            fprintf(fid, '%s\n',strcat('CMSEL,S,Part',num2str(obj.Sensor{i,1}.Part(1,1))));
            if size(obj.Sensor{i,1}.Part,1)>1
                for j=2:size(obj.Sensor{i,1}.Part,1)
                    fprintf(fid, '%s\n',strcat('CMSEL,A,Part',num2str(obj.Sensor{i,1}.Part(j,1))));
                end
            end
            fprintf(fid, '%s\n','NSLE,R,CORNER');
            fprintf(fid, '%s\n','FCTYP,DELE,ALL');
            fprintf(fid, '%s\n',strcat('FCTYP,ADD,',obj.Sensor{i,1}.Lab));
            fprintf(fid, '%s\n',strcat('/OUTPUT,',Name,'_Sensor',num2str(i),',txt'));
            fprintf(fid, '%s\n',strcat('PRESOL,FAIL,',obj.Sensor{i,1}.Lab));
            fprintf(fid, '%s\n','/OUTPUT');
    end
end
end