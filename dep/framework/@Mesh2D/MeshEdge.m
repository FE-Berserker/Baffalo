function obj=MeshEdge(obj,edgeno)
% Mesh edge
% Author : Xie Yu

if obj.Meshoutput.order==2
    error('Element order can not be 2 !')
end

% Get number of elements
Acc_El=size(obj.Face,1);
Acc_N=size(obj.Vert,1);
CCb=obj.Cb;
Max_Cb=max(CCb);

[G,~]= EdgeGroup(obj);
% Get edge coordinate
Num=unique(obj.Boundary(G==edgeno,:),'stable');
NN=obj.Vert(Num,:);
% [row,~]=find(G==edgeno);
delta=min(Num)-1;
EE=[(1:size(NN,1))',[2:size(NN,1),1]'];
[VV,~,FF,~] = meshtool.refine2(NN,EE) ;
obj.Vert=[obj.Vert;VV(size(NN,1)+1:end,:)];
FFF=reshape(FF,[],1);
[rr,~]=find(FFF>size(NN,1));
FFF(rr,:)=FFF(rr,:)+Acc_N-size(NN,1);
[rr,~]=find(FFF<=size(NN,1));
FFF(rr,:)=FFF(rr,:)+delta;
FF=reshape(FFF,[],3);
obj.Face=[obj.Face;FF];
% [obj.Face,obj.Vert,~,~]=MergeVertices([obj.Face;FF+Acc_N],[obj.Vert;VV]);

obj.Boundary=FindBoundary(obj);
obj.Cb=[CCb;ones(size(obj.Face,1)-Acc_El,1)*(Max_Cb+1)];

%% Parse
obj.Meshoutput.nodes=[obj.Vert,zeros(size(obj.Vert,1),1)];
obj.Meshoutput.facesBoundary=obj.Boundary;
obj.Meshoutput.boundaryMarker=ones(size(obj.Boundary,1),1);
obj.Meshoutput.faces=[];
obj.Meshoutput.elements=obj.Face;
obj.Meshoutput.elementMaterialID=ones(size(obj.Face,1),1);
obj.Meshoutput.faceMaterialID=[];
obj.Meshoutput.order=1;

%% Print
if obj.Echo
    fprintf('Successfully mesh edge .\n');
end
