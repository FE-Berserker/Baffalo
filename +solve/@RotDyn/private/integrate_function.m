function dZ= integrate_function(t,Z,Omega, rotorsystem,load, mat)
% Provides integration function
%
%    :param t: Time step
%    :type t: double
%    :param Z: State vector
%    :type Z: vector
%    :param Omega:
%    :type Omega:
%    :param rotorsystem: Object of type Rotorsystem
%    :type rotorsystem: object
%    :param mat: State space matrices A,B in form mat.A, mat.B
%    :type mat: struct
%    :return: Derivative of state vector (dZ) for integration (check Matlab's odefun)

A=mat.A;
B=mat.B;
ndof = length(A)/2;

%% Loadvector
h_ges = compute_system_load_ss(rotorsystem,t,Z(1:2*ndof),load);

%% DGL
dZ = A*Z+B*h_ges; 
dZ(ndof+6:6:2*ndof) = 0; % angular acceleration = 0 for stationary rpm

end

