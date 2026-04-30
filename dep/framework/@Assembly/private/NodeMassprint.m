function [AccET,AccReal]=NodeMassprint(obj,fid,m2,m,varargin)
% Print Node mass to ANSYS
% Author : Xie Yu

p=inputParser;
addParameter(p,'Ori',[]);
addParameter(p,'Rep',[]);
addParameter(p,'ExistSubStrM',0);
parse(p,varargin{:});
opt=p.Results;

% Check substrM
if opt.ExistSubStrM==1
    Ori=opt.Ori;
    Rep=opt.Rep;
    ExistSubStrM=1;
else
    ExistSubStrM=0;
end

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

    if Numpart==0
        num1=obj.Summary.Total_Node+obj.NodeMass(i,2);
    else
        num1=obj.NodeMass(i,2);
    end

    if ExistSubStrM==1
        for j=1:size(Ori,1)
            num1((num1-Ori(j,1))==0,:)=Rep(j,1);
        end
    end

    fprintf(fid, '%s\n',strcat('TYPE,',num2str(m2+i)));
    fprintf(fid, '%s\n',strcat('REAL,',num2str(m+i)));
    fprintf(fid, '%s\n',strcat('E,',num2str(num1)));
end

fprintf(fid, '%s\n','ALLSEL,ALL');
AccET=m2+m1;
AccReal=m+m1;
end