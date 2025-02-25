function [AccET,AccReal,AccCS,AccSec]=Jointprint(obj,fid,m2,m)
% print Assembly Joint to ANSYS
% Author : Xie Yu

m1=size(obj.Joint,1);
AccCS=obj.Summary.Total_CS;
AccSec=obj.Summary.Total_Section;

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
    if Option(1,2)==6
        % Create section
        AccSec=AccSec+1;
        Sen_Sec=strcat('SECTYPE,',num2str(AccSec),',joint,revo');
        fprintf(fid, '%s\n',Sen_Sec);
        Sen_Secdata='SECDATA,,,,0';
        fprintf(fid, '%s\n',Sen_Secdata);
        % CS
        if isempty(obj.Joint{i,1}.CS)
            AccCS=AccCS+1;
            Sen_CS=strcat('LOCAL,',num2str(AccCS+10),',0');
            fprintf(fid, '%s\n',Sen_CS);
            Sen_SecJoint=strcat('SECJOINT,lsys,',num2str(AccCS+10));
            fprintf(fid, '%s\n',Sen_SecJoint);
            Sen_SecNum=strcat('SECNUM,',num2str(AccSec));
            fprintf(fid, '%s\n',Sen_SecNum);
        else
            Sen_SecJoint=strcat('SECJOINT,lsys,',num2str(obj.Joint{i,1}.CS));
            fprintf(fid, '%s\n',Sen_SecJoint);
            Sen_SecNum=strcat('SECNUM,',num2str(AccSec));
            fprintf(fid, '%s\n',Sen_SecNum);
        end
 
    end

    % Build mesh
    fprintf(fid, '%s\n','ESEL,NONE');
    Sen_E='E,';
    for j=1:length(Node)/2
        if Node(2*j-1)==0
            Sen_E=strcat(Sen_E,num2str(obj.Summary.Total_Node+Node(2*j)),',');
        else
            Sen_E=strcat(Sen_E,num2str(Node(2*j)),',');
        end
    end
    fprintf(fid, '%s\n',Sen_E);

    if ~isempty(obj.Joint{i,1}.DJType)
        Sen_DJ=strcat('DJ,ALL,',obj.Joint{i,1}.DJType,',',num2str(obj.Joint{i,1}.DJValue));
        fprintf(fid, '%s\n',Sen_DJ);
    end

    fprintf(fid, '%s\n','CSYS,0');
    fprintf(fid, '%s\n','ALLSEL,ALL');

end

AccET=m2+m1;
AccReal=m;
end