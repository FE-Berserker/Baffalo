function obj=compute_ode15s_ss(obj,varargin)
% Carries out an integration of type ode15s
% return: Integration results in results field of object

k=inputParser;
addParameter(k,'Abstol',1e-5);
addParameter(k,'Reltol',1e-5);
parse(k,varargin{:});
opt=k.Results;


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
    options = odeset('AbsTol', opt.Abstol, 'RelTol', opt.Reltol,'OutputFcn',@odeOutputFcnController,'MaxStep',obj.output.Time(2)-obj.output.Time(1));

    % Timer.restart();
    disp('... integration started...')
    TimeSeries=obj.input.TimeSeries;
    % Unbalance
    if ~isempty(obj.input.UnBalanceForce)
        for i=1:size(obj.input.UnBalanceForce,1)
            % Load
            inputStruct.Time=obj.output.Time;
            inputStruct.Fy=obj.input.UnBalanceForce(i,2)*Omega^2*cos(Omega.*obj.output.Time);
            inputStruct.Fz=obj.input.UnBalanceForce(i,2)*Omega^2*sin(Omega.*obj.output.Time);
            paramsStruct=struct();
            Load=signal.ForceLoad(paramsStruct, inputStruct);
            Load=Load.solve();
            Temp=Load.output.Load;
            Temp.Node=obj.input.UnBalanceForce(i,1);
            TimeSeries{end+1,1}=Temp; %#ok<AGROW>
        end
    end

    sol = ode15s(@integrate_function,obj.output.Time,Z0, options, Omega, obj.output.RotorSystem,TimeSeries, mat);
    [Z,Zp] = deval(sol,obj.output.Time);

    res.X = Z(1:6*n_nodes,:); % Displacement
    res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:); % Velocity
    res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:); % Accleration
    res.F = calculate_force_load_post_sensor(obj.output.RotorSystem,TimeSeries,obj.output.Time,res.X,res.X_d);
    res.FBearing = calculate_bearing_force(obj.output.RotorSystem,obj.output.Time,res.X,res.X_d);
    res.Fcontroller = calculate_controller_force(obj.output.RotorSystem,obj.output.Time,res.X,res.X_d);

    obj.output.TimeSeriesResult(rpm)=res;

end

end