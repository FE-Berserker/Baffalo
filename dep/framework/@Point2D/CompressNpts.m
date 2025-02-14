function obj=CompressNpts(obj,varargin)
% CompressNpts Compress number of points
% Author : Xie Yu
p=inputParser;
addParameter(p,'all',0);
parse(p,varargin{:});
opt=p.Results;

NG=GetNgpts(obj);
%% Find points
tol = obj.Dtol;
Dup_k=[];
for i=1:NG
    for j = 1:size(obj.PP{i,1},1)-1
        PQ=obj.PP{i,1}(j,:);
        [k,dist] = dsearchn(obj.PP{i,1}(j+1:end,:),PQ);
        if dist<=tol
            Dup_k=[Dup_k,k+j]; %#ok<AGROW> 
        end
    end
    obj.PP{i,1}(Dup_k,:)=[];
end

if opt.all==1
    Dup_k=[];
    N=GetNpts(obj);
    for i=1:N-1
        PQ=obj.P(i,:);
        [k,dist] = dsearchn(obj.P(i+1:end,:),PQ);
        if dist<=tol
            Dup_k=[Dup_k,k+i]; %#ok<AGROW> 
        end
    end
    obj.P(Dup_k,:)=[];
end

%% Parse
obj.NP=GetNpts(obj);
obj.NG=GetNgpts(obj);
%% Print
if obj.Echo
    fprintf('Successfully compress points. \n');
    tic
end

