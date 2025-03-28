function [AccET,AccReal]=Springprint(obj,fid)
% Print spring to ANSYS
% Author : Xie Yu
m1=GetNET(obj);
m2=GetNContactPair(obj);
m=m1+m2;

%Set ET
fprintf(fid, '%s\n',strcat('ET,',num2str(m1+1),',14'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+1),',2,1'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+2),',14'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+2),',2,2'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+3),',14'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+3),',2,3'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+4),',14'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+4),',2,4'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+5),',14'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+5),',2,5'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+6),',14'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+6),',2,6'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+7),',40'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+7),',3,1'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+8),',40'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+8),',3,2'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+9),',40'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+9),',3,3'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+10),',40'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+10),',3,4'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+11),',40'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+11),',3,5'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+12),',40'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+12),',3,6'));

acc=0;

for i=1:size(obj.Spring,1)
    if and(obj.Spring(i,15)==0,obj.Spring(i,16)==0)
        for j=3:8
            if or(obj.Spring(i,j)~=0,obj.Spring(i,j+6)~=0)
                Node1=GetMasterNum(obj,obj.Spring(i,1));
                Node2=GetMasterNum(obj,obj.Spring(i,2));
                acc=acc+1;
                fprintf(fid, '%s\n',strcat('R,',num2str(m+acc),',',num2str(obj.Spring(i,j)),',',num2str(obj.Spring(i,j+6))));
                fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+j-2)));
                fprintf(fid, '%s\n',strcat('REAL,',num2str(m+acc)));
                fprintf(fid, '%s\n',strcat('E,',num2str(Node1),',',num2str(Node2)));
            end
        end
    else
        for j=3:8
            if or(obj.Spring(i,j)~=0,obj.Spring(i,j+6)~=0)
                Node1=GetMasterNum(obj,obj.Spring(i,1));
                Node2=GetMasterNum(obj,obj.Spring(i,2));
                acc=acc+1;
                fprintf(fid, '%s\n',strcat('R,',num2str(m+acc),',',num2str(obj.Spring(i,j)),',',num2str(obj.Spring(i,j+6)),...
                    ',0,',num2str(obj.Spring(i,15)),',',num2str(obj.Spring(i,16)),',0'));
                fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+j+4)));
                fprintf(fid, '%s\n',strcat('REAL,',num2str(m+acc)));
                fprintf(fid, '%s\n',strcat('E,',num2str(Node1),',',num2str(Node2)));
            end
        end
    end
end
fprintf(fid, '%s\n','ALLSEL,ALL');

AccET=m1+6;
AccReal=m+acc;
end
