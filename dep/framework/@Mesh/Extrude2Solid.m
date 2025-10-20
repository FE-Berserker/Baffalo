function obj=Extrude2Solid(obj,mesh2D,Height,Levels,varargin)
% Extrude Mesh2D to Mesh
% Author : Xie Yu
p=inputParser;
addParameter(p,'Cb',[]);
parse(p,varargin{:});
opt=p.Results;

V=mesh2D.Vert;

if isempty(opt.Cb)
    F=mesh2D.Face;
    [V,Seq]=CompressNode(F,V);
else
    F=mesh2D.Face(mesh2D.Cb==opt.Cb,:);
    [V,Seq]=CompressNode(F,V);
end

Acc=size(obj.Vert,1);
Num_node_2D=size(V,1);



if size(Height,1)~=1
    warning('The levels input will be ignored !')
    Levels=size(Height,1);
    V=repmat(V,Levels+1,1);
    TotalHeight=sum(Height);
    Temp=[0;tril(ones(size(Height,1)))*Height]/TotalHeight;
    Temp=repmat(Temp',Num_node_2D,1);
    nodes=[V,reshape(Temp,(Levels+1)*Num_node_2D,1).*TotalHeight];

else
    V=repmat(V,Levels+1,1);
    Temp=0:1/Levels:1;
    Temp=repmat(Temp,Num_node_2D,1);
    nodes=[V,reshape(Temp,(Levels+1)*Num_node_2D,1).*Height];
end


Temp=cell(Levels,1);

if Acc==0
    if size(F,2)==3
        Temp{1,1}=[F,F(:,3),...
            Seq+Num_node_2D+Acc,Seq(:,3)+Num_node_2D+Acc];
        for i=2:Levels
            Temp{i}=[Seq+(i-1)*Num_node_2D+Acc,Seq(:,3)+(i-1)*Num_node_2D+Acc,...
                Seq+Num_node_2D*i+Acc,Seq(:,3)+Num_node_2D*i+Acc];
        end
    else
        Temp{1,1}=[F,...
            Seq+Num_node_2D+Acc];
        for i=2:Levels
            Temp{i}=[Seq+(i-1)*Num_node_2D+Acc,...
                Seq+Num_node_2D*i+Acc];
        end
    end
else
    if size(F,2)==3
        Temp{1,1}=[F,F(:,3),...
            Seq+Acc,Seq(:,3)+Acc];
        for i=1:Levels-1
            Temp{i+1}=[Seq+(i-1)*Num_node_2D+Acc,Seq(:,3)+(i-1)*Num_node_2D+Acc,...
                Seq+Num_node_2D*i+Acc,Seq(:,3)+Num_node_2D*i+Acc];
        end
    else
        Temp{1,1}=[F,...
            Seq+Acc];
        for i=1:Levels-1
            Temp{i+1}=[Seq+(i-1)*Num_node_2D+Acc,...
                Seq+Num_node_2D*i+Acc];
        end
    end
end

if ~isempty(obj.Meshoutput)
    obj.Meshoutput.nodes=[obj.Meshoutput.nodes;nodes(Num_node_2D+1:end,:)];
    obj.Meshoutput.elements=[obj.Meshoutput.elements;cell2mat(Temp)];
else
    obj.Meshoutput.nodes=nodes;
    obj.Meshoutput.elements=cell2mat(Temp);
end

%Convert elements to faces
[obj.Meshoutput.faces,~]=element2patch(obj.Meshoutput.elements,[],'hex8');
%Find boundary faces
[indFree]=freeBoundaryPatch(obj.Meshoutput.faces);
obj.Meshoutput.facesBoundary=obj.Meshoutput.faces(indFree,:);

%Create faceBoundaryMarkers based on normals
%N.B. Change of convention changes meaning of front, top etc.
[N]=patchNormal(obj.Meshoutput.facesBoundary,obj.Meshoutput.nodes); 
faceBoundaryMarker=zeros(size(obj.Meshoutput.facesBoundary,1),1)+1;

faceBoundaryMarker(N(:,3)==-1)=2; %Bottom
faceBoundaryMarker(N(:,3)==1)=3; %Top
obj.Meshoutput.boundaryMarker=faceBoundaryMarker;
obj.Meshoutput.elementMaterialID=ones(size(obj.Meshoutput.elements,1),1);
obj.Meshoutput.faceMaterialID=ones(size(obj.Meshoutput.faces,1),1);
obj.Meshoutput.order=1;

obj.Vert=obj.Meshoutput.nodes;
obj.El=obj.Meshoutput.elements; %The elements
obj.Face=obj.Meshoutput.facesBoundary; %The boundary faces
obj.Cb=obj.Meshoutput.boundaryMarker; %The "colors" or labels for the boundary faces

 %% Print
if obj.Echo
    fprintf('Successfully extrude mesh . \n');
end

end

function [V,Seq]=CompressNode(F,V)
[N,~,ic]=unique(F);
V=V(N,:);
N=(1:size(N,1))';
Seq=reshape(N(ic),[],size(F,2));
end