function obj= AddBCNode(obj,NodeNum,Bound)
% Add Boundary node to Shaft
% Author : Xie Yu

obj.input.BCNode=[obj.input.BCNode;NodeNum,Bound];

end
