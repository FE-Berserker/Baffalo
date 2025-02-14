function obj = Meshoutput(obj,varargin)
% Output Layer lines to mesh
% Author : Xie Yu

k=inputParser;
addParameter(k,'Lines',[]);
addParameter(k,'Compress',1);
addParameter(k,'Dtol',1e-5);
parse(k,varargin{:});
opt=k.Results;

NumDigits=length(num2str(opt.Dtol));

if isempty(opt.Lines)
    opt.Lines=(1:obj.Summary.TotalLine)';
end

%% Main
NL=size(opt.Lines,1);
nodes=[];
Matrix=cell(NL,1);
elements=[];

for i=1:NL
    preNum=size(nodes,1);
    % postNode=obj.Lines{i,1}.P;
    nodes=[nodes;obj.Lines{i,1}.P]; %#ok<AGROW> 
    nodes=round(nodes,NumDigits);
    Temp_elements1=obj.Lines{i,1}.El+preNum;

    if opt.Compress
        [nodes,~,ic]=unique(nodes,'rows','stable');
        ori=(1:size(ic,1))';
        ic=ic(preNum+1:end,:);
        ori=ori(preNum+1:end,:);
        judge=ic-ori;
        ori=ori(judge~=0,:);
        ic=ic(judge~=0,:);
        for j=1:size(ori,1)
            N=ori(j,1);
            NN=ic(j,1);
            Temp_elements1(Temp_elements1==N)=NN;
        end
        
    end
    
    s1=size(elements,1)+1;
    s2=size(Temp_elements1,1);
    Matrix{i,1}=(s1:s1+s2-1)';
    elements=[elements;Temp_elements1]; %#ok<AGROW> 
end

faces=[];
facesBoundary=[];
elementMaterialID=ones(size(elements,1),1);
faceMaterialID=[];


%% Parse
Num=GetNMeshoutput(obj);
obj.Matrix{Num+1,1}=Matrix;
obj.Meshoutput{Num+1,1}.nodes=nodes;
obj.Meshoutput{Num+1,1}.elements=elements;
obj.Meshoutput{Num+1,1}.elementMaterialID=elementMaterialID;
obj.Meshoutput{Num+1,1}.faces=faces;
obj.Meshoutput{Num+1,1}.facesBoundary=facesBoundary;
obj.Meshoutput{Num+1,1}.boundaryMarker=(1:size(nodes,1))';
obj.Meshoutput{Num+1,1}.faceMaterialID=faceMaterialID;
obj.Meshoutput{Num+1,1}.order=1;
%% Print
if obj.Echo
    fprintf('Successfully output lines to mesh . \n');
end
end

