function  [AccET,AccReal]=Bearingprint(obj,fid,m1,m)
% Bearing print to ANSYS
% Author : Xie Yu

%Set ET
fprintf(fid, '%s\n',strcat('ET,',num2str(m1+1),',214'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+1),',2,0'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+1),',3,1'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+2),',214'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+2),',2,1'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+2),',3,1'));

fprintf(fid, '%s\n',strcat('ET,',num2str(m1+3),',214'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+3),',2,2'));
fprintf(fid, '%s\n',strcat('KEYOPT,',num2str(m1+3),',3,1'));


acc=0;
% Bearing print
for i=1:size(obj.Bearing,1)
    Node1=GetMasterNum(obj,obj.Bearing(i,1));
    Node2=GetMasterNum(obj,obj.Bearing(i,2));
    acc=acc+1;
    fprintf(fid, '%s\n',strcat('R,',num2str(m+acc),',',num2str(obj.Bearing(i,3)),',',num2str(obj.Bearing(i,4)),...
        ',',num2str(obj.Bearing(i,5)),',',num2str(obj.Bearing(i,6)),',',num2str(obj.Bearing(i,7)),',',num2str(obj.Bearing(i,8))));
    fprintf(fid, '%s\n',strcat('RMORE,',num2str(obj.Bearing(i,9)),',',num2str(obj.Bearing(i,10))));
    switch obj.Bearing(i,11)
        case 0
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+1)));
        case 1
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+2)));
        case 2
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+3)));
    end
    fprintf(fid, '%s\n',strcat('REAL,',num2str(m+acc)));
    fprintf(fid, '%s\n',strcat('E,',num2str(Node1),',',num2str(Node2)));
end

% LUTBearing print
for i=1:size(obj.LUTBearing,1)
    Node1=GetMasterNum(obj,obj.LUTBearing(i,1));
    Node2=GetMasterNum(obj,obj.LUTBearing(i,2));
    acc=acc+1;
    TableNo=obj.LUTBearing(i,3);
    fprintf(fid, '%s\n',strcat('R,',num2str(m+acc),',%LUT',num2str(TableNo),'_K11%,%LUT',num2str(TableNo),...
        '_K22%,%LUT',num2str(TableNo),'_K12%,%LUT',num2str(TableNo),'_K21%,%LUT',num2str(TableNo),'_C11%,%LUT',num2str(TableNo),'_C22%'));
    fprintf(fid, '%s\n',strcat('RMORE,%LUT',num2str(TableNo),'_C12%,%LUT',num2str(TableNo),'_C21%'));

    switch obj.LUTBearing(i,4)
        case 0
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+1)));
        case 1
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+2)));
        case 2
            fprintf(fid, '%s\n',strcat('TYPE,',num2str(m1+3)));
    end
    fprintf(fid, '%s\n',strcat('REAL,',num2str(m+acc)));
    fprintf(fid, '%s\n',strcat('E,',num2str(Node1),',',num2str(Node2)));
end


fprintf(fid, '%s\n','ALLSEL,ALL');

AccET=m1+3;
AccReal=m+acc;
end
