function obj= AddTorBearing(obj,NodeNum,par)
% Add torsional bearing to Shaft
% par=[ktor,ctor]
% Author : Xie Yu
obj.input.TorBearing=[obj.input.TorBearing;NodeNum,par];
end
