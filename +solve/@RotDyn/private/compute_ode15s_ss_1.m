function obj=compute_ode15s_ss_1(obj,varargin)
% Carries out an integration of type ode15s
%
%    :return: Integration results in results field of object
k=inputParser;
addParameter(k,'Abstol',1e-5);
addParameter(k,'Reltol',1e-5);
parse(k,varargin{:});
opt=k.Results;

rpm_span = obj.input.SpeedRange;
t_span = [obj.output.Time(1), obj.output.Time(end)];

disp('Compute Hochlauf .... ode15s State Space ....')
obj.output.TimeSeriesResult = containers.Map('KeyType','double','ValueType','any');
n_nodes = length(obj.output.RotorSystem.Rotor.Mesh.Node);

%%init Vector
ndof = 6*n_nodes;
Z0 = zeros(2*ndof,1);     % Mit null belegen:
Z0(1*ndof+6:6:2*ndof)=rpm_span(1)/60*2*pi;        % Drehzahl fuer psi_z

% solver parameters
options = odeset('AbsTol', opt.Abstol, 'RelTol', opt.Reltol,'OutputFcn',@odeOutputFcnController1,'MaxStep',obj.output.Time(2)-obj.output.Time(1));

disp('... integration started...')

TimeSeries=obj.input.TimeSeries;
% Unbalance
if ~isempty(obj.input.UnBalanceForce)
    Omega=rpm_span(1)/60*2*pi+...
        (rpm_span(2)-rpm_span(1))/(obj.output.Time(end)-obj.output.Time(1)).*(obj.output.Time-obj.output.Time(1))/60*2*pi;
    rad=(Omega(2:end)+Omega(1:end-1))/2.*(obj.output.Time(2:end)-obj.output.Time(1:end-1));
    accrad=[0,rad]*triu(ones(length(obj.output.Time),length(obj.output.Time)));
    for i=1:size(obj.input.UnBalanceForce,1)
        % Load
        inputStruct.Time=obj.output.Time;
        inputStruct.Fy=obj.input.UnBalanceForce(i,2)*Omega.^2.*cos(accrad);
        inputStruct.Fz=obj.input.UnBalanceForce(i,2)*Omega.^2.*sin(accrad);
        paramsStruct=struct();
        Load=signal.ForceLoad(paramsStruct, inputStruct);
        Load=Load.solve();
        Temp=Load.output.Load;
        Temp.Node=obj.input.UnBalanceForce(i,1);
        TimeSeries{end+1,1}=Temp; %#ok<AGROW>
    end
end

sol = ode15s(@integrate_function1,obj.output.Time,Z0, options, rpm_span, t_span, obj.output.RotorSystem,TimeSeries);

[Z,Zp] = deval(sol,obj.output.Time);

res.X = Z(1:6*n_nodes,:); % Displacement
res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:); % Velocity
res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:); % Accleration
res.F = calculate_force_load_post_sensor(obj.output.RotorSystem,TimeSeries,obj.output.Time,res.X,res.X_d);
res.FBearing = calculate_bearing_force(obj.output.RotorSystem,obj.output.Time,res.X,res.X_d);
res.Fcontroller = calculate_controller_force(obj.output.RotorSystem,obj.output.Time,res.X,res.X_d);

obj.output.TimeSeriesResult(0)=res;

end