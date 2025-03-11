function obj = GenerateKeyNode(obj)
% Generate KeyNode
% Author : Xie Yu

if ~isempty(obj.input.Springs)
    Node1=obj.input.Springs(:,1);
else
    Node1=[];
end

if ~isempty(obj.input.PointMass)
    Node2=obj.input.PointMass(:,1);
else
    Node2=[];
end

if ~isempty(obj.input.BCNode)
    Node3=obj.input.BCNode(:,1);
else
    Node3=[];
end

if ~isempty(obj.input.Bearing)
    Node4=obj.input.Bearing(:,1);
else
    Node4=[];
end

if ~isempty(obj.input.UnBalanceForce)
    Node5=obj.input.UnBalanceForce(:,1);
else
    Node5=[];
end

if ~isempty(obj.input.KeyNode)
    Node6=obj.input.KeyNode(:,1);
else
    Node6=[];
end

if ~isempty(obj.input.TorBearing)
    Node7=obj.input.TorBearing(:,1);
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

Node=[Node1;Node2;Node3;Node4;Node5;Node6;Node7;Node8;Node9];
Node=unique(Node);
obj.input.KeyNode=Node;

if obj.params.Echo
    fprintf('Successfully generate keynode .\n');
end

end
