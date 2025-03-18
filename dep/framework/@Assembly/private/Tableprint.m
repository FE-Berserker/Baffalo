function Tableprint(obj,fid)
% Output table to ANSYS
% Author : Xie Yu

[m,~]=size(obj.Table);
for i=1:m
    Type=obj.Table{i,1}.Type;
    switch Type
        case 'OMEGS'
            Data=obj.Table{i, 1}.Data;
            row=size(Data,1);

            if row>8
               error('Please reduce the size of table !')
            end

            Temp=Data.RPM/60*2*pi;
            
            Rot=num2str(Temp(1,1));
            for j=2:row
                Rot=strcat(Rot,',',num2str(Temp(j,1)));
            end

            % K11 print
            Sen=strcat('*DIM,LUT',num2str(i),'_K11,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_K11(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.K11(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.K11(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_K11(1,1)=',K);
            fprintf(fid, '%s\n',Sen);

            % K22 print
            Sen=strcat('*DIM,LUT',num2str(i),'_K22,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_K22(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.K22(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.K22(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_K22(1,1)=',K);
            fprintf(fid, '%s\n',Sen);

            % K12 print
            Sen=strcat('*DIM,LUT',num2str(i),'_K12,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_K12(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.K12(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.K12(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_K12(1,1)=',K);
            fprintf(fid, '%s\n',Sen);

            % K21 print
            Sen=strcat('*DIM,LUT',num2str(i),'_K21,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_K21(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.K21(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.K21(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_K21(1,1)=',K);
            fprintf(fid, '%s\n',Sen);

            % C11 print
            Sen=strcat('*DIM,LUT',num2str(i),'_C11,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_C11(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.C11(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.C11(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_C11(1,1)=',K);
            fprintf(fid, '%s\n',Sen);

            % C22 print
            Sen=strcat('*DIM,LUT',num2str(i),'_C22,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_C22(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.C22(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.C22(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_C22(1,1)=',K);
            fprintf(fid, '%s\n',Sen);

            % C12 print
            Sen=strcat('*DIM,LUT',num2str(i),'_C12,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_C12(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.C12(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.C12(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_C12(1,1)=',K);
            fprintf(fid, '%s\n',Sen);

            % C21 print
            Sen=strcat('*DIM,LUT',num2str(i),'_C21,TABLE,',num2str(row),',1,1,OMEGS');
            fprintf(fid, '%s\n',Sen);
            Sen=strcat('LUT',num2str(i),'_C21(1,0)=',Rot);
            fprintf(fid, '%s\n',Sen);

            K=num2str(Data.C21(1,1));
            for j=2:row
                K=strcat(K,',',num2str(Data.C21(j,1)));
            end

            Sen=strcat('LUT',num2str(i),'_C21(1,1)=',K);
            fprintf(fid, '%s\n',Sen);     
    end

end

