function Disprint(obj,fid,varargin)
% Displacement output to ANSYS
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


if ~isempty(obj.Displacement)
m=size(obj.Displacement,1);
for i=1:m
    n=size(obj.Displacement{i,1}.nodes,1);
    for j=1:n
        for k=1:6
            if obj.Displacement{i,1}.amp(j,k)~=0
                nnode=obj.Displacement{i,1}.nodes(j);

                if ExistSubStrM==1
                    for kk=1:size(Ori,1)
                        nnode((nnode-Ori(kk,1))==0)=Rep(kk,1);
                    end
                end

                switch k
                    case 1
                        Sen_Dis=strcat('D,',num2str(nnode),',UX,',...
                            num2str(obj.Displacement{i,1}.amp(j,k)));
                    case 2
                        Sen_Dis=strcat('D,',num2str(nnode),',UY,',...
                            num2str(obj.Displacement{i,1}.amp(j,k)));
                    case 3
                        Sen_Dis=strcat('D,',num2str(nnode),',UZ,',...
                            num2str(obj.Displacement{i,1}.amp(j,k)));
                    case 4
                        Sen_Dis=strcat('D,',num2str(nnode),',ROTX,',...
                            num2str(obj.Displacement{i,1}.amp(j,k)));
                    case 5
                        Sen_Dis=strcat('D,',num2str(nnode),',ROTY,',...
                            num2str(obj.Displacement{i,1}.amp(j,k)));
                    case 6
                        Sen_Dis=strcat('D,',num2str(nnode),',ROTZ,',...
                            num2str(obj.Displacement{i,1}.amp(j,k)));
                end
                fprintf(fid, '%s\n',Sen_Dis);

            end
        end

    end
end
end

end