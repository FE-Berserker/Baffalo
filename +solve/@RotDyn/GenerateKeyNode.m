function obj = GenerateKeyNode(obj)
% Generate KeyNode
% Author : Xie Yu

NumNode=size(obj.input.Shaft.Meshoutput.nodes,1);

if ~isempty(obj.input.PointMass)
    Node1=obj.input.PointMass(:,1);
else
    Node1=[];
end

if ~isempty(obj.input.BCNode)
    Node2=obj.input.BCNode(:,1);
else
    Node2=[];
end

if ~isempty(obj.input.Bearing)
    Node3=[obj.input.Bearing(:,1);obj.input.Bearing(:,13)+NumNode*2-1];
else
    Node3=[];
end

if ~isempty(obj.input.UnBalanceForce)
    Node4=obj.input.UnBalanceForce(:,1);
else
    Node4=[];
end

if ~isempty(obj.input.KeyNode)
    Node5=obj.input.KeyNode(:,1);
else
    Node5=[];
end

if ~isempty(obj.input.TorBearing)
    Node6=[obj.input.TorBearing(:,1);obj.input.TorBearing(:,5)+NumNode*2-1];
else
    Node6=[];
end

if ~isempty(obj.input.BendingBearing)
    Node7=[obj.input.BendingBearing(:,1);obj.input.BendingBearing(:,7)+NumNode*2-1];
else
    Node7=[];
end

if ~isempty(obj.input.InNode)
    Node8=obj.input.InNode(:,1);
else
    Node8=[];
end

if ~isempty(obj.input.OutNode)
    Node9=obj.input.OutNode(:,1);
else
    Node9=[];
end

if ~isempty(obj.input.LUTBearing)
    Node10=[obj.input.LUTBearing(:,1);obj.input.LUTBearing(:,4)+NumNode*2-1];
else
    Node10=[];
end


if ~isempty(obj.input.HousingBCNode)
    Node11=obj.input.HousingBCNode(:,1)+NumNode*2-1;
else
    Node11=[];
end

if ~isempty(obj.input.HousingBearing)
    Node12=obj.input.HousingBearing(:,1)+NumNode*2-1;
else
    Node12=[];
end

if ~isempty(obj.input.HousingTorBearing)
    Node13=obj.input.HousingTorBearing(:,1)+NumNode*2-1;
else
    Node13=[];
end

if ~isempty(obj.input.HousingBendingBearing)
    Node14=obj.input.HousingBendingBearing(:,1)+NumNode*2-1;
else
    Node14=[];
end

Node=[Node1;Node2;Node3;Node4;Node5;Node6;Node7;Node8;Node9;Node10;...
    Node11;Node12;Node13;Node14];
Node=unique(Node);

row=find(Node==NumNode*2-1);

if ~isempty(row)
    Node(row,:)=[];
end

 obj.input.KeyNode=Node;

if obj.params.Echo
    fprintf('Successfully generate keynode .\n');
end

end
