function [AccET,AccReal]=Jointprint(obj,fid,m2,m)
% print Assembly Joint to ANSYS
% Author : Xie Yu
m1=size(obj.Joint,1);
for i=1:m1

    Option=obj.Joint{i,1}.Option;
    % Element Type
    Sen_ET=strcat('ET,',num2str(m2+i),',MPC184');
    fprintf(fid, '%s\n',Sen_ET);
    for j=1:size(Option,1)
        Sen_Opt=strcat('KEYOPT,',num2str(m2+i),',',num2str(Option(j,1)),',',num2str(Option(j,2)));
        fprintf(fid, '%s\n',Sen_Opt);
    end

    fprintf(fid, '%s\n',strcat('TYPE,',num2str(m2+i)));
    Node=obj.Joint{i,1}.Node;

    Sen_E='E,';
    for j=1:length(Node)/2
        if Node(2*j-1)==0
            Sen_E=strcat(Sen_E,num2str(obj.Summary.Total_Node+Node(2*j)),',');
        else
            Sen_E=strcat(Sen_E,num2str(Node(2*j)),',');
        end
    end
    fprintf(fid, '%s\n',Sen_E);

end
fprintf(fid, '%s\n','ALLSEL,ALL');
AccET=m2+m1;
AccReal=m;
end