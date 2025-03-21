function ss_h= compute_system_load_ss(obj, t, Z,load)
% Computes the system load in state space form for time integration: h=[0;F]
%
%    :param t: Time step
%    :type t: double
%    :parameter Z: State-space vector [x; x_dot]
%    :type Z: vector(double)
%    :return: Load vector


h_loads = assemble_system_loads(obj,t,Z,load);
h_controllers = assemble_system_controller_forces(obj,t,Z);

%% Put together
h = h_loads + h_controllers;
% h=h_loads;

ss_h=[zeros(length(h),1);h];
         
end