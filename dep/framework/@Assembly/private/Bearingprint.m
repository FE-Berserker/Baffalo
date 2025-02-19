function  [AccET,AccReal]=Bearingprint(obj,fid,m1,m)
% Bearing print to ANSYS
% Author : Xie Yu

%Set ET
fprintf(fid, '%s\n',strcat('ET,',num2str(m1+1),',214'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+1),',2,1'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+1),',3,1'));

acc=0;
for i=1:size(obj.Bearing,1)
    Node1=GetMasterNum(obj,obj.Bearing(i,1));
    Node2=GetMasterNum(obj,obj.Bearing(i,2));
    acc=acc+1;
    fprintf(fid, '%s\n',strcat('R,',num2str(m+acc),',',num2str(obj.Bearing(i,3)),',',num2str(obj.Bearing(i,4)),...
        ',',num2str(obj.Bearing(i,5)),',',num2str(obj.Bearing(i,6)),',',num2str(obj.Bearing(i,7)),',',num2str(obj.Bearing(i,8))));
    fprintf(fid, '%s\n',strcat('RMORE,',num2str(obj.Bearing(i,9)),',',num2str(obj.Bearing(i,10))));
    fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+1)));
    fprintf(fid, '%s\n',strcat('REAL,',num2str(m+acc)));
    fprintf(fid, '%s\n',strcat('E,',num2str(Node1),',',num2str(Node2)));
end
fprintf(fid, '%s\n','ALLSEL,ALL');

AccET=m1+1;
AccReal=m+acc;
end
