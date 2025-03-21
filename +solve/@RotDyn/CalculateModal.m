function obj = CalculateModal(obj)
% Calculate modal analysis of shaft
% Author : Xie Yu

n_ew = obj.params.NMode;
if isempty(obj.input.Speed)
    omega=0;
else
    omega = obj.input.Speed/60*2*pi;
end

%==========================================================================
% aus Experiments.Campbell
[mat.A,mat.B] = get_state_space_matrices(obj.output.RotorSystem,omega);
[V,D] = perform_eigenanalysis(mat,n_ew);
%==========================================================================

D_tmp = imag(D);

% negative D / V Eintr鋑e wegwerfen --> nModes=nModes

tmp = find(D_tmp >=0);
tmp2 = sparse(size(V,1),length(tmp));
for i = 1:length(tmp)
    EV_nr = tmp(i,1);
    tmp2(:,i) = V(:,EV_nr); %#ok<SPRIX>
end
D = D(tmp);
D_tmp = D_tmp(tmp); %#ok<NASGU>
V = tmp2;

V = get_position_entries(obj.output.RotorSystem,V,mat);
[M,~,~,~]= assemble_system_matrices(obj.output.RotorSystem,omega*60/2/pi);
V = do_mass_normalization(V,M);
V_real = real(V);

%% Aussortierung der x werte aus dem EV mithilfe der get_dof Implementierung
nNodes = obj.output.RotorSystem.Rotor.Mesh.Node;

Ev_lat_x = zeros(length(nNodes),size(V_real,2));
Ev_lat_y = Ev_lat_x;
Ev_lat_z = Ev_lat_x;
Ev_tor_psi_z = Ev_lat_x;
CEv_lat_x = Ev_lat_x;
CEv_lat_y = Ev_lat_x;
CEv_lat_z = Ev_lat_x;
CEv_tor_psi_z = Ev_lat_x;

for mode = 1:n_ew
    for node = 1:length(nNodes)
        dof_u_x = get_gdof(obj.output.RotorSystem,'Uy',node,mat.A);
        dof_u_y = get_gdof(obj.output.RotorSystem,'Uz',node,mat.A);
        dof_u_z = get_gdof(obj.output.RotorSystem,'Ux',node,mat.A);
        dof_psi_z = get_gdof(obj.output.RotorSystem,'Rotx',node,mat.A);

        Ev_lat_x(node,mode)=V_real(dof_u_x,mode);
        Ev_lat_y(node,mode)=V_real(dof_u_y,mode);
        Ev_lat_z(node,mode)=V_real(dof_u_z,mode);
        Ev_tor_psi_z(node,mode)=V_real(dof_psi_z,mode);

        CEv_lat_x(node,mode)=V(dof_u_x,mode);
        CEv_lat_y(node,mode)=V(dof_u_y,mode);
        CEv_lat_z(node,mode)=V(dof_u_z,mode);
        CEv_tor_psi_z(node,mode)=V(dof_psi_z,mode);
    end
end
obj.output.eigenVectors.lateral_x=Ev_lat_x;
obj.output.eigenVectors.lateral_y=Ev_lat_y;
obj.output.eigenVectors.lateral_z=Ev_lat_z;
obj.output.eigenVectors.torsional_psi_z=Ev_tor_psi_z;
obj.output.eigenValues.lateral =D;
% obj.eigenValues.full = V;

obj.output.eigenVectors.lat_complex.x=CEv_lat_x;
obj.output.eigenVectors.lat_complex.y=CEv_lat_y;
obj.output.eigenVectors.lat_complex.z=CEv_lat_z;
obj.output.eigenVectors.lat_complex.psi_z=CEv_tor_psi_z;

obj.output.eigenVectors.complex = V;
% Calculate frequency
Frequency=NaN(n_ew,2);

for s=1:n_ew
    D = imag(obj.output.eigenValues.lateral(s));
    Frequency(s,1)=D/2/pi;
    delta = -real(obj.output.eigenValues.lateral(s));
    omegad = imag(obj.output.eigenValues.lateral(s));
    D = delta/omegad; % Lehr damping
    Frequency(s,2)=D; % Damping ratio
end

obj.output.Frequency=Frequency;

end
