function obj=compute_ode15s_ss(obj)
% Carries out an integration of type ode15s
% return: Integration results in results field of object

% Timer = AMrotorTools.Timer();

disp('Compute.... ode15s State Space ....')
obj.output.TimeSeriesResult = containers.Map('KeyType','double','ValueType','any');


for rpm = obj.input.Speed
    disp(['... rotational speed: ',num2str(rpm),' U/min'])

    n_nodes = length(obj.output.RotorSystem.Rotor.Mesh.Node);

    Omega = rpm*pi/30;

    [mat.A,mat.B] = get_state_space_matrices3(obj.output.RotorSystem,Omega);

    %%init Vector
    ndof = length(mat.A)/2;
    Z0 = zeros(2*ndof,1);     % Mit null belegen:
    Z0(1*ndof+6:6:2*ndof)=Omega;        % Drehzahl fuer psi_z


    % solver parameters
    options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5,'OutputFcn',@odeOutputFcnController,'MaxStep',obj.output.Time(2)-obj.output.Time(1));

    % Timer.restart();
    disp('... integration started...')

    sol = ode15s(@integrate_function,obj.output.Time,Z0, options, Omega, obj.output.RotorSystem,obj.input.TimeSeries, mat);
    [Z,Zp] = deval(sol,obj.output.Time);

    res.X = Z(1:6*n_nodes,:); % Displacement
    res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:); % Velocity
    res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:); % Accleration
    res.F = calculate_force_load_post_sensor(obj.output.RotorSystem,obj.input.TimeSeries,obj.output.Time,res.X,res.X_d);
    res.FBearing = calculate_bearing_force(obj.output.RotorSystem,obj.output.Time,res.X,res.X_d);
    res.Fcontroller = calculate_controller_force(obj.output.RotorSystem,obj.output.Time,res.X,res.X_d);

    res.X = Z(1:6*n_nodes,:)*1000; % Unit m --> mm
    res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:)*1000; % Unit m/s --> mm/s
    res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:)*1000; % Unit m/s2 --> mm/s2
    
    obj.output.TimeSeriesResult(rpm)=res;

end

end