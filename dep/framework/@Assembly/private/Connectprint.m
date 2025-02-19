function Connectprint(obj,fid)
% print Assembly connection to ANsYS
% Author : Xie Yu
m1=size(obj.Slaver,1);
for i=1:m1
    m2=size(obj.Slaver{i,1},1);
    Sen=strcat('*DIM,SLAVE',num2str(i),',ARRAY,',num2str(m2),',1,1');
    fprintf(fid, '%s\n',Sen);
    for j=1:m2
        Sen_Array=strcat('*SET,SLAVE',num2str(i),'(',num2str(j),',1,1),',num2str(obj.Slaver{i,1}(j)));
        fprintf(fid, '%s\n',Sen_Array);
    end
end

Sen_con=('DOF,UX,UY,UZ,ROTX,ROTY,ROTZ');
fprintf(fid, '%s\n',Sen_con);

for i=1:size(obj.Connection,1)
    Type=obj.Connection(i,3);
    num1=obj.Connection(i,1);
    num2=obj.Connection(i,2);
    m2=size(obj.Slaver{num2,1},1);

    switch Type
        case 1
            num=GetMasterNum(obj,num1);
            Sen_con=strcat('RBE3,',num2str(num),',ALL,SLAVE',num2str(i));
            fprintf(fid, '%s\n',Sen_con);
        case 2
            num=GetMasterNum(obj,num1);
            Sen=strcat('*DO,i,1,',num2str(m2));
            fprintf(fid, '%s\n',Sen);
            Sen_con=strcat('CERIG,',num2str(num),',SLAVE',num2str(num2),'(i,1,1),ALL');
            fprintf(fid, '%s\n',Sen_con);
            fprintf(fid, '%s\n','*ENDDO');
    end

end
fprintf(fid, '%s\n','ALLSEL,ALL');
end