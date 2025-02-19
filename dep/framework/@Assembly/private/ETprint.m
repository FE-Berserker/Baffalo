function ETprint(obj,fid)
[m,~]=size(obj.ET);
for i=1:m
    Sen=strcat('ET,',num2str(i),',',obj.ET{i,1}.name);
    fprintf(fid, '%s\n',Sen);

    if ~isempty(obj.ET{i,1}.opt)
        n=size(obj.ET{i,1}.opt,1);
        for j=1:n
            Sen_Opt=strcat('KEYOPT,',num2str(i),',',...
                num2str(obj.ET{i,1}.opt(j,1)),',',...
                num2str(obj.ET{i,1}.opt(j,2)));
            fprintf(fid, '%s\n',Sen_Opt);
        end
    end

    if ~isempty(obj.ET{i,1}.R)
        n=size(obj.ET{i,1}.R,2);
        Sen_R=strcat('R,',num2str(i));
        k=0;
        Temp_sen=[];
        for j=1:n
            
            Temp_sen=strcat(Temp_sen,',',num2str(obj.ET{i,1}.R(1,j)));
            k=k+1;

            while k==6&&j==6
                Sen_R=strcat(Sen_R,Temp_sen);
                fprintf(fid, '%s\n',Sen_R);
                k=0;
                Temp_sen=[];
            end

            while k==6&&j>6
                Sen_R=strcat('RMORE',Temp_sen);
                fprintf(fid, '%s\n',Sen_R);
                k=0;
                Temp_sen=[];
            end

            while k~=0&&j==n
                if n>6
                    Sen_R=strcat('RMORE',Temp_sen);
                    fprintf(fid, '%s\n',Sen_R);
                    k=0;
                    Temp_sen=[];
                else
                    Sen_R=strcat(Sen_R,Temp_sen);
                    fprintf(fid, '%s\n',Sen_R);
                    k=0;
                    Temp_sen=[];
                end
            end
                        
        end
    end
end

end