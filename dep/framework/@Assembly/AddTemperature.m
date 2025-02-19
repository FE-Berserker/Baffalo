function obj=AddTemperature(obj,partno,T)
% Add part Temperature to Assembly
obj.Temperature=[obj.Temperature;partno,T];
end

