function obj=CombineMeshPair(obj,meshno1,meshno2,varargin)
% Combine mesh pair
% Author ： Xie Yu
p=inputParser;
addParameter(p,'remesh',[]);
addParameter(p,'reverse',0);

parse(p,varargin{:});
opt=p.Results;
%% Parse input
Num=size(obj.Meshes{meshno1,1}.Vert,1);

edge1=obj.Meshes{meshno1,1}.Boundary;
edge2=obj.Meshes{meshno2,1}.Boundary+Num;

m=Mesh('Combine','Echo',0);
m.Vert=[obj.Meshes{meshno1,1}.Vert;obj.Meshes{meshno2,1}.Vert];
m.Face=[obj.Meshes{meshno1,1}.Face;obj.Meshes{meshno2,1}.Face+Num];
m.Cb=[obj.Meshes{meshno1,1}.Cb;obj.Meshes{meshno2,1}.Cb];

EdgeFace=GenerateEdgeFace(edge1,edge2,m.Vert,opt.reverse);
m.Face=[m.Face;EdgeFace];
m.Cb=[m.Cb;ones(size(EdgeFace,1),1)*3];

if ~isempty(opt.remesh)
    m=Remesh(m,opt.remesh);
end
obj=AddElement(obj,m);

%% Print
if obj.Echo
    fprintf('Successfully combin meshes . \n');
end
end

function Face=GenerateEdgeFace(edge1,edge2,Vert,reverse)
Num1=size(edge1,1);
Num2=size(edge2,1);
if reverse==1
    Temp1=edge2(:,2);
    Temp2=edge2(:,1);
    edge2=[Temp1,Temp2];
end
Face=NaN(Num1+Num2,3);
%% Rearrange the seqence
ee1=NaN(Num1,2);
ee1(1,:)=edge1(1,:);
pool=edge1(2:end,:);
for i=2:Num1
    last=ee1(i-1,2);
    row=pool(:,1)==last;
    ee1(i,:)=pool(row,:);
    pool(row,:)=[];
end
%% Find closest point
node1=repmat(Vert(ee1(1,1),:),size(edge2,1),1);
node=Vert(edge2(:,1),:);
dis=sqrt((node(:,1)-node1(:,1)).^2+(node(:,2)-node1(:,2)).^2+(node(:,3)-node1(:,3)).^2);
row=find(dis==min(dis),1);
%% Rearrange the seqence
ee2=NaN(Num2,2);
ee2(1,:)=edge2(row,:);
pool=edge2;
pool(row,:)=[];
for i=2:Num2
    last=ee2(i-1,2);
    row=pool(:,1)==last;
    ee2(i,:)=pool(row,:);
    pool(row,:)=[];
end
Face(1,:)=[ee1(1,:),ee2(1,1)];
Step1=1/Num1;
Step2=1/Num2;
acc1=Step1;
acc2=0;
for i=2:Num1+Num2
    if acc2<=acc1
        node1=ee2(round(acc2/Step2)+1,2);
        node2=ee2(round(acc2/Step2)+1,1);
        node3=ee1(round(acc1/Step1)+1,1);
%         k=k+1;
         acc2=acc2+Step2;
    else
        node1=ee1(round(acc1/Step1)+1,2);
        node2=ee1(round(acc1/Step1),2);
        node3=ee2(round(acc2/Step2),2);   
%         k=k-1;
         acc1=acc1+Step1;
    end
    Face(i,:)=[node1,node2,node3];


end

end