function obj= AddHousingTorBearing(obj,NodeNum,par)
% Add torsional bearing to Housing
% par=[ktor,ctor]
% Author : Xie Yu
obj.input.HousingTorBearing=[obj.input.HousingTorBearing;NodeNum,par];
end
