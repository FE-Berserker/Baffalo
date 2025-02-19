function [Shell,Beam,Face,MNode,Con]=GetFace(obj,Master)
% Get Face of Assembly
% Author : Xie Yu

Num=GetNPart(obj);
group=(1:Num)';
% Element Type
Shell.V=[];
Shell.el=[];
Shell.Cb=[];
Beam.x=[];
Beam.y=[];
Beam.z=[];
Beam.Cb=[];
Face.el=[];
Face.V=[];
Face.Cb=[];
MNode=[];
for i=1:Num
    PartNum=group(i,1);
    [Shell,Beam,Face,MNode]=PartPlot(obj,Shell,Beam,Face,i,MNode,Num,PartNum);
end

%% connection
coor=GetNodeCoor(obj,Master.PartNum,Master.NodeNum);

Con.X=coor(:,1);
Con.Y=coor(:,2);
Con.Z=coor(:,3);

end

function [Shell,Beam,Face,MNode]=PartPlot(obj,Shell,Beam,Face,i,MNode,Num,PartNum)
% Plot part
Order=obj.Part{PartNum,1}.mesh.order;
FF=obj.Part{PartNum,1}.mesh.facesBoundary;
VV=obj.Part{PartNum,1}.mesh.nodes;
Cb=obj.Part{PartNum,1}.mesh.boundaryMarker;
El=obj.Part{PartNum,1}.mesh.elements;

if and(~isempty(obj.Part{PartNum,1}.mesh.facesBoundary),obj.Part{PartNum,1}.New==0)
    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
elseif and(~isempty(obj.Part{PartNum,1}.mesh.facesBoundary),obj.Part{PartNum,1}.New==1)
    if i==Num
        [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
    elseif obj.Part{PartNum+1,1}.New==0
        [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
    elseif obj.Part{PartNum+1,1}.New==1
        if i~=1
            post=obj.Part{PartNum+1,1}.acc_node;
            if obj.Part{PartNum,1}.acc_node~=post
                [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
            end
        end

        switch Order
            case 1
                if size(FF,2)==2
                    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
                end
            case 2
                if size(FF,2)==3
                    [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i);
                end
        end
    end

elseif isempty(obj.Part{PartNum,1}.mesh.facesBoundary)
    EE=obj.Part{PartNum,1}.mesh.elements(:,1:2);
    EE=mat2cell(EE,ones(1,size(EE,1)));
    VV=obj.Part{PartNum,1}.mesh.nodes;
    X=cellfun(@(x)VV(x',1)',EE,'UniformOutput',false);
    Y=cellfun(@(x)VV(x',2)',EE,'UniformOutput',false);
    Z=cellfun(@(x)VV(x',3)',EE,'UniformOutput',false);
    Beam.x=[Beam.x;X];
    Beam.y=[Beam.y;Y];
    Beam.z=[Beam.z;Z];
    Beam.Cb=[Beam.Cb,i*ones(1,size(X,1))];
end
end

function [Face,Shell,MNode]=OutputPart(Order,FF,VV,Cb,El,Face,Shell,MNode,i)
switch Order
    case 1
        if size(FF,2)==3
            acc=size(Face.V,1);
            Face.el=[Face.el;FF+acc,FF(:,3)+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
        elseif size(FF,2)==4
            acc=size(Face.V,1);
            Face.el=[Face.el;FF+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
        elseif size(FF,2)==2
            acc=size(Shell.V,1);
            Shell.el=[Shell.el;El+acc];
            Shell.V=[Shell.V;VV];
            Shell.Cb=[Shell.Cb;ones(size(El,1),1)*i];
        end
    case 2
        if size(FF,2)==3
            acc=size(Shell.V,1);
            Shell.el=[Shell.el;El(:,1:end/2)+acc];
            Shell.V=[Shell.V;VV];
            Shell.Cb=[Shell.Cb;ones(size(El,1),1)*i];
            MNode=[MNode;VV];
        end

        if size(FF,2)==6
            acc=size(Face.V,1);
            Face.el=[Face.el;FF(:,1:3)+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
            MNode=[MNode;VV];
        end

        if size(FF,2)==8
            acc=size(Face.V,1);
            Face.el=[Face.el;FF(:,1:4)+acc];
            Face.V=[Face.V;VV];
            Face.Cb=[Face.Cb;Cb];
            MNode=[MNode;VV];
        end
end
end

