function obj=AddDisplacement(obj,Numpart,varargin)
% Add displacement to Assembly
% Author : Xie Yu
k=inputParser;
addParameter(k,'Dtol',1e-5);
addParameter(k,'No',[]);
addParameter(k,'locx',[]);
addParameter(k,'locy',[]);
addParameter(k,'locz',[]);
parse(k,varargin{:});
opt=k.Results;

No=opt.No;
Dtol=opt.Dtol;

if Numpart~=0
    % Define displacement node set
    if ~isempty(No)
        if ~isempty(obj.Part{Numpart,1}.mesh.facesBoundary)
            FFb=obj.Part{Numpart,1}.mesh.facesBoundary;
            acc=obj.Part{Numpart,1}.acc_node;
            Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
            bbcPrescribeList=unique(FFb(Cb==No,:));
        else
            acc=obj.Part{Numpart,1}.acc_node;
            Cb=obj.Part{Numpart,1}.mesh.boundaryMarker;
            bbcPrescribeList=find(Cb==No);
        end
    end

    if ~isempty(opt.locx)
        nodes=obj.Part{Numpart,1}.mesh.nodes;
        select=(1:size(nodes,1))';
        acc=obj.Part{Numpart,1}.acc_node;
        bbcPrescribeList=select(and(nodes(:,1)>=opt.locx-Dtol,...
            nodes(:,1)<=opt.locx+Dtol),:);
    end

    if ~isempty(opt.locy)
        nodes=obj.Part{Numpart,1}.mesh.nodes;
        select=(1:size(nodes,1))';
        acc=obj.Part{Numpart,1}.acc_node;
        bbcPrescribeList=select(and(nodes(:,2)>=opt.locy-Dtol,...
            nodes(:,2)<=opt.locy+Dtol),:);
    end

    if ~isempty(opt.locz)
        nodes=obj.Part{Numpart,1}.mesh.nodes;
        select=(1:size(nodes,1))';
        acc=obj.Part{Numpart,1}.acc_node;
        bbcPrescribeList=select(and(nodes(:,3)>=opt.locz-Dtol,...
            nodes(:,3)<=opt.locz+Dtol),:);
    end

    num=GetNDisplacement(obj)+1;
    obj.Displacement{num,1}.nodes=bbcPrescribeList+acc;
    obj.BcDisplacementList=[obj.BcDisplacementList;obj.Displacement{num,1}.nodes];
end

if Numpart==0
    num=GetNDisplacement(obj)+1;
    obj.Displacement{num,1}.nodes=No+obj.Summary.Total_Node;
    obj.BcDisplacementList=[obj.BcDisplacementList;obj.Displacement{num,1}.nodes];
end
%% Parse
obj.Summary.Total_Displacement=GetNDisplacement(obj);

%% Print
if obj.Echo
    fprintf('Successfully add displacements . \n');
end

end
