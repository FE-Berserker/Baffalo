function SOLUprint(obj,fid,varargin)
% Print solu to ANSYS
% Author : Xie Yu
p=inputParser;
addParameter(p,'MultiSolve',0);
addParameter(p,'Save',0);
parse(p,varargin{:});
setting=p.Results;

% Output sub structure to ANSYS
if ~isempty(obj.SubStrM.Node)
    for i=1:size(obj.SubStrM.Node,1)
        value=GetSubStrMNum(obj,i);
        fprintf(fid, '%s\n',strcat('M,',num2str(value),',',obj.SubStrM.Type{i,1}));
    end
end


for i=1:size(obj.Solu,1)
    opt=obj.Solu{i,1};
    if isfield(opt,"NEW")
         fprintf(fid, '%s\n','/SOLU');
    end
    Name = fieldnames(opt);
    option=struct2cell(opt);
    for j=1:size(Name,1)
        sen=Name{j,1};
        for k=1:size(option{j,1},2)
            Temp=option{j,1}(1,k);
            if isstring(Temp)
                sen=strcat(sen,',',Temp);
            elseif iscell(Temp)
                if isstring(Temp{1,1})
                    sen=strcat(sen,',',Temp{1,1});
                else
                    sen=strcat(sen,',',num2str(Temp{1,1}));
                end
            else
                sen=strcat(sen,',',num2str(Temp));
            end
        end
        fprintf(fid, '%s\n',sen);
    end
end

if setting.Save==1
    fprintf(fid, '%s\n','SAVE');
end

if setting.MultiSolve==0
    fprintf(fid, '%s\n','SOLVE');
end

end