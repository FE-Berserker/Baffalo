function F = calculate_controller_force(rotorsystem,time,displacement,velocity)
% Calculate the force of the sensor ControllerForceSensor
%
%    :param rotorsystem: Object of type rotorsystem
%    :type rotorsystem: object
%    :param time: Time-vector of solution
%    :type time: vector
%    :param displacement: Displacement vector
%    :type displacement: vector(double)
%    :param velocity: Velocity vector
%    :type velocity: vector(double)
%    :return: ControllerForceSensor force

%   Uses the displacment and velocity to obtain the force of
%   the corresponding pidControllers
% Licensed under GPL-3.0-or-later, check attached LICENSE file

F = zeros(size(displacement,1),size(displacement,2));

if ~isempty(rotorsystem.PIDController)
    h_ges = zeros(size(displacement,1),size(displacement,2));
    for k = 1:length(time)
        Zk = [displacement(:,k); velocity(:,k)];
        % set the new controller force
        for i =1: length(rotorsystem.PIDController)
            control=rotorsystem.PIDController{i};
            [displacementCntrNode, ~] = find_state_vector(rotorsystem,control.Node, Zk);
            get_controller_current(control,time(k),displacementCntrNode);
            get_controller_force(control,time(k),displacementCntrNode);
        end
        h_ges(:,k) = assemble_system_controller_forces(rotorsystem,time(k),Zk);
    end
    F = h_ges;
end

end