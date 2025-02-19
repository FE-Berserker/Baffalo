function BeamPreloadprint(obj,fid,AccET)
% Beampreloadprint
% Author：Xie Yu
Num=GetNBeamPreload(obj);
fprintf(fid, '%s\n','ALLSEL,ALL');
Sen_ET=strcat('ET,',num2str(AccET+1),',179');
fprintf(fid, '%s\n',Sen_ET);
fprintf(fid, '%s\n','CSYS,0');
fprintf(fid, '%s\n','WPCSYS,,0');
AccCS=obj.Summary.Total_CS;
AccSec=obj.Summary.Total_Section;
for i=1:Num
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

fprintf(fid, '%s\n','ALLSEL,ALL');
fprintf(fid, '%s\n','CSYS,0');
fprintf(fid, '%s\n','WPCSYS,,0');
fprintf(fid, '%s\n','/SOLU');
for i=1:Num
    Preload=obj.BeamPreload{i,1}.Preload;
    % fprintf(fid, '%s\n',strcat('SLOAD,',num2str(AccSec+i),',PL01,LOCK,DISP,0.1,1,20'));
    % fprintf(fid, '%s\n',strcat('SLOAD,',num2str(AccSec+i),',PL02,TINNY,FORC,',num2str(Preload),',2,3'));
    fprintf(fid, '%s\n',strcat('SLOAD,',num2str(AccSec+i),',PL01,LOCK,Force,',num2str(Preload),',1,2'));
end

fprintf(fid, '%s\n','SOLVE');
end
