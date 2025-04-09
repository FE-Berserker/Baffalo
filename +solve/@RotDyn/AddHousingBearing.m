function obj= AddHousingBearing(obj,NodeNum,Par)
% Add housingbearing to Housing
% Par=[Kx,K11,K22,K12,K,21,Cx,C11,C22,C12,C21]
% Author : Xie Yu
obj.input.HousingBearing=[obj.input.HousingBearing;NodeNum,Par];
end
