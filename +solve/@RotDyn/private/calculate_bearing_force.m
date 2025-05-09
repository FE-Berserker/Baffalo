function F = calculate_bearing_force(rotorsystem,time,displacement,velocity)
% Calculates the force of the sensor BearingForceSensor
%
%    :param rotorsystem: Object of type rotorsystem
%    :type rotorsystem: object
%    :param time: Time step
%    :type time: double
%    :param displacement: Displacement vector
%    :type displacement: vector(double)
%    :param velocity: Velocity vector
%    :type velocity: vector(double)
%    :return: BearingForceSensor force

%   Uses the displacment and velocity to obtain the force of
%   the corresponding bearings; does not use an inertia term
%   Calculates the forces of the bearing acting ON the rotor:
%   F_bearing = - (k*x + d*x_dot)
%

h_ges = zeros(size(displacement,1),size(displacement,2));

for k = 1:length(time)
    currDisplacement = displacement(:,k);
    currVelocity = velocity(:,k);

    node_nr = 1; %leftmost node
    dof_psiz = get_gdof(rotorsystem,'Rotx',node_nr);
    Omega = velocity(dof_psiz,k);
    rpm = Omega / (2*pi) *60;
    [~,C_Comp,G_Comp,K_Comp]= get_component_matrices(rotorsystem,rpm);
    D_Comp = C_Comp + Omega*G_Comp;

    h_ges(:,k) = -(D_Comp*currVelocity + K_Comp*currDisplacement);
end
F = h_ges;

end