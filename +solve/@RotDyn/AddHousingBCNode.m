function obj= AddHousingBCNode(obj,NodeNum,Bound)
% Add Boundary node to Housing
% Author : Xie Yu
obj.input.HousingBCNode=[obj.input.HousingBCNode;NodeNum,Bound];
end
