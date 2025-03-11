function obj= AddBearing(obj,NodeNum,Par)
% Add bearing to Shaft
% Par=[Kx,K11,K22,K12,K,21,Cx,C11,C22,C12,C21]
% Author : Xie Yu
obj.input.Bearing=[obj.input.Bearing;NodeNum,Par];
end
