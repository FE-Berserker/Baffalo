function obj=ImportResult(obj)
% Load results
%% Load Stress
Stress=importStress('Stress.txt');
U=importU('U.txt');

obj.Sensor.U=U;
obj.Sensor.Stress=Stress;
end