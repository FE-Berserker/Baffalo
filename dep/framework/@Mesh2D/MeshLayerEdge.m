function obj=MeshLayerEdge(obj,edgeno,Thickness,varargin)
% Mesh layer edge
% Author : Xie Yu

k=inputParser;
addParameter(k,'Num',3);
addParameter(k,'ElementType','tri');
addParameter(k,'Dir',1);
parse(k,varargin{:});
opt=k.Results;

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

a=Point2D('Temp','Echo',0);
a=AddPoint(a,NN(:,1),NN(:,2));
b=Line2D('Temp','Echo',0);
b=AddCurve(b,a,1);
if opt.Dir==1
    for i=1:opt.Num
        AddLineThickness(b,i,repmat(Thickness/opt.Num,size(NN,1)-1,1),90,'close',1);
    end
else
    for i=1:opt.Num
        AddLineThickness(b,i,repmat(Thickness/opt.Num,size(NN,1)-1,1),-90,'close',1);
    end
end

% Generate Mesh
Seg=size(Num,1);
obj.Vert=[obj.Vert;b.Point.P(Seg+1:end,:)];
col1=[Num;(Acc_N+1:Acc_N+Seg*(opt.Num-1))'];
col2=[Num(2:end,:);Num(1,1);(Acc_N+1:Acc_N+Seg*(opt.Num-1))'+1];
col2(Seg*2:Seg:end,:)=...
    col2(Seg*2:Seg:end,:)-Seg;

col4=(Acc_N+1:Acc_N+Seg*(opt.Num))';
col3=col4+1;
col3(Seg:Seg:end,:)=col3(Seg:Seg:end,:)-Seg;

switch opt.ElementType
    case 'quad'
    case 'tri'
        obj=AddElements(obj,[[col1,col2,col3];[col3,col4,col1]]);
end

[N,~,~]=patchNormal(obj.Face,obj.Vert);
% Reverse normal
FF=obj.Face;
FF(N(:,3)==-1,:)=[FF(N(:,3)==-1,1),FF(N(:,3)==-1,3),FF(N(:,3)==-1,2)];
obj.Face=FF;

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

end

