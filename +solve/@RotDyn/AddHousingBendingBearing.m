function obj= AddHousingBendingBearing(obj,NodeNum,par)
% Add bending bearing to Housing
% par=[kroty,krotz,croty,ctotz]
% Author : Xie Yu
obj.input.HousingBendingBearing=[obj.input.HousingBendingBearing;NodeNum,par];
end
