function obj= AddPointMass(obj,NodeNum,m,JT,JD)
% Add Point Mass to Shaft
% Author : Xie Yu
obj.input.PointMass=[obj.input.PointMass;NodeNum,m,JT,JD];
end

