function F = calculate_force_load_post_sensor(rotorsystem,TimeSeries,time,displacement,velocity)
% Calculate the force of the sensor ForceLoadPostSensor
%
%    :param rotorsystem: Object of type rotorsystem
%    :type rotorsystem: object
%    :param time: Time step
%    :type time: double
%    :param displacement: Displacement vector
%    :type displacement: vector(double)
%    :param velocity: Velocity vector
%    :type velocity: vector(double)
%    :return: ControllerForceSensor force

%   Uses the displacment and velocity to obtain the force of
%   the corresponding load-objects, through their force laws

% F = zeros(size(displacement,1),size(displacement,2));
% Kraftberechnung

h_ges = zeros(size(displacement,1),size(displacement,2));
for k = 1:length(time)
    h_ges(:,k) = assemble_system_loads(rotorsystem,time(k), [displacement(:,k); velocity(:,k)],TimeSeries);
end
F = h_ges;

end