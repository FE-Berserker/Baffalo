function Preloadprint(obj,fid,AccET,AccCS,AccSec)
% Preloadprint
% Author：Xie Yu
Num1=GetNBeamPreload(obj);
Num2=GetNSolidPreload(obj);
fprintf(fid, '%s\n','ALLSEL,ALL');
Sen_ET=strcat('ET,',num2str(AccET+1),',179');
fprintf(fid, '%s\n',Sen_ET);
fprintf(fid, '%s\n','CSYS,0');
fprintf(fid, '%s\n','WPCSYS,,0');

if Num1~=0
    for i=1:Num1
        ElNum=obj.BeamPreload{i,1}.El;
        Node=obj.BeamPreload{i,1}.Node;

        fprintf(fid, '%s\n',strcat('ESEL,S,ELEM,,',num2str(ElNum)));
        fprintf(fid, '%s\n','NSLE,S');
        fprintf(fid, '%s\n',strcat('CS,',num2str(AccCS+10+i),',0,',num2str(Node(1)),',',num2str(Node(2)),',',num2str(Node(3))));
        fprintf(fid, '%s\n',strcat('WPCSYS,,',num2str(AccCS+10+i)));
        fprintf(fid, '%s\n',strcat('CSYS,',num2str(AccCS+10+i)));
        fprintf(fid, '%s\n','NROTAT,all');
        fprintf(fid, '%s\n','ESLN,S');
        fprintf(fid, '%s\n',strcat('PSMESH,',num2str(AccSec+i),',Bolt',num2str(i),',,ALL,,',num2str(AccCS+10+i),',X,0,',num2str(Node(1)),',1,',num2str(AccET+1)));
    end

end

if Num2~=0
    for i=1:Num2
        ElNum=obj.SolidPreload{i,1}.El;
        Node=obj.SolidPreload{i,1}.Node;

        fprintf(fid, '%s\n',strcat('ESEL,S,ELEM,,',num2str(ElNum(1)),',',num2str(ElNum(2))));
        fprintf(fid, '%s\n','NSLE,S');
        fprintf(fid, '%s\n','CSYS,0');

        fprintf(fid, '%s\n',strcat('K,',num2str(3*(i-1)+1),',',num2str(Node(1,1)),',',num2str(Node(1,2)),',',num2str(Node(1,3))));
        fprintf(fid, '%s\n',strcat('K,',num2str(3*(i-1)+2),',',num2str(Node(2,1)),',',num2str(Node(2,2)),',',num2str(Node(2,3))));
        fprintf(fid, '%s\n',strcat('K,',num2str(3*(i-1)+3),',',num2str(Node(3,1)),',',num2str(Node(3,2)),',',num2str(Node(3,3))));

        % fprintf(fid, '%s\n',strcat('N,',num2str(accNode+3*(i-1)+1),',',num2str(Node(1,1)),',',num2str(Node(1,2)),',',num2str(Node(1,3))));
        % fprintf(fid, '%s\n',strcat('N,',num2str(accNode+3*(i-1)+2),',',num2str(Node(2,1)),',',num2str(Node(2,2)),',',num2str(Node(2,3))));
        % fprintf(fid, '%s\n',strcat('N,',num2str(accNode+3*(i-1)+3),',',num2str(Node(3,1)),',',num2str(Node(3,2)),',',num2str(Node(3,3))));

        fprintf(fid, '%s\n',strcat('CSKP,',num2str(AccCS+Num1+10+i),',0,',num2str(3*(i-1)+1),',',num2str(3*(i-1)+2),',',num2str(3*(i-1)+3)));
        % fprintf(fid, '%s\n',strcat('CS,',num2str(AccCS+Num1+10+i),',0,',num2str(accNode+3*(i-1)+1),',',num2str(accNode+3*(i-1)+2),',',num2str(accNode+3*(i-1)+3)));
        fprintf(fid, '%s\n',strcat('WPCSYS,,',num2str(AccCS+Num1+10+i)));
        fprintf(fid, '%s\n',strcat('CSYS,',num2str(AccCS+Num1+10+i)));
        fprintf(fid, '%s\n','NROTAT,all');
        fprintf(fid, '%s\n','ESLN,S');
        fprintf(fid, '%s\n',strcat('PSMESH,',num2str(AccSec+Num1+i),',Bolt',num2str(Num1+i),',,ALL,,',num2str(AccCS+Num1+10+i),',X,0,,,',num2str(AccET+Num1+1)));
    end

end

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','CSYS,0');
fprintf(fid, '%s\n','WPCSYS,,0');
fprintf(fid, '%s\n','/SOLU');

if Num1~=0
    for i=1:Num1
        Preload=obj.BeamPreload{i,1}.Preload;
        fprintf(fid, '%s\n',strcat('SLOAD,',num2str(AccSec+i),',PL01,LOCK,Force,',num2str(Preload),',1,2'));
    end
end

if Num2~=0
    for i=1:Num2
        Preload=obj.SolidPreload{i,1}.Preload;
        fprintf(fid, '%s\n',strcat('SLOAD,',num2str(AccSec+Num1+i),',PL01,LOCK,Force,',num2str(Preload),',1,2'));
    end
end

fprintf(fid, '%s\n','SOLVE');
end
