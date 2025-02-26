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

if ~isempty(obj.input.Support)
    Node4=obj.input.Support(:,1);
else
    Node4=[];
end

if ~isempty(obj.input.KeyNode)
    Node6=obj.input.KeyNode(:,1);
else
    Node6=[];
end

Node=[Node1;Node2;Node3;Node4;Node6];
Node=unique(Node);
obj.input.KeyNode=Node;

end
