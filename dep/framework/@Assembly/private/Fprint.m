function Fprint(obj,fid,varargin)
% Force output to ANSYS
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


if ~isempty(obj.Load)
m=size(obj.Load,1);
for i=1:m
    n=size(obj.Load{i,1}.nodes,1);
    for j=1:n
        for k=1:6
            if obj.Load{i,1}.amp(j,k)~=0
                nnode=obj.Load{i,1}.nodes(j);
                
                if ExistSubStrM==1
                    for kk=1:size(Ori,1)
                        nnode((nnode-Ori(kk,1))==0)=Rep(kk,1);
                    end
                end

                switch k
                    case 1
                        Sen_F=strcat('F,',num2str(nnode),',FX,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 2
                        Sen_F=strcat('F,',num2str(nnode),',FY,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 3
                        Sen_F=strcat('F,',num2str(nnode),',FZ,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 4
                        Sen_F=strcat('F,',num2str(nnode),',MX,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 5
                        Sen_F=strcat('F,',num2str(nnode),',MY,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                    case 6
                        Sen_F=strcat('F,',num2str(nnode),',MZ,',...
                            num2str(obj.Load{i,1}.amp(j,k)));
                end
                fprintf(fid, '%s\n',Sen_F);

            end
        end

    end
end
end
end