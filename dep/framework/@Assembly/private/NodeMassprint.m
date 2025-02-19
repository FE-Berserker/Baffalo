function [AccET,AccReal]=NodeMassprint(obj,fid,m2,m)
m1=size(obj.NodeMass,1);
for i=1:m1
    % Element Type
    Sen_ET=strcat('ET,',num2str(m2+i),',21');
    fprintf(fid, '%s\n',Sen_ET);
    Sen_Opt=strcat('KEYOPT,',num2str(m2+i),',3,0');
    fprintf(fid, '%s\n',Sen_Opt);
    Sen_R=strcat('R,',num2str(m+i),',',num2str(obj.NodeMass(i,3)),...
        ',',num2str(obj.NodeMass(i,4)),...
        ',',num2str(obj.NodeMass(i,5)),...
        ',',num2str(obj.NodeMass(i,6)),...
        ',',num2str(obj.NodeMass(i,7)),...
        ',',num2str(obj.NodeMass(i,8)));
    fprintf(fid, '%s\n',Sen_R);

    Numpart=obj.NodeMass(i,1);
    acc=obj.Part{Numpart,1}.acc_node;

    num1=obj.NodeMass(i,2)+acc;
    fprintf(fid, '%s\n',strcat('TYPE,',num2str(m2+i)));
    fprintf(fid, '%s\n',strcat('REAL,',num2str(m+i)));
    fprintf(fid, '%s\n',strcat('E,',num2str(num1)));
end

fprintf(fid, '%s\n','ALLSEL,ALL');
AccET=m2+m1;
AccReal=m+m1;
end