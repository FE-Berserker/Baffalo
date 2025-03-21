function h = assemble_system_loads(obj,time,Z,load)
% Assembles the system loads
%
%    :param time: Time step
%    :type time: double
%    :param Z: State vector
%    :type Z: vector
%    :return: System load vector h


n_nodes=length(obj.Rotor.Mesh.Node);
h = sparse(6*n_nodes,1);

for i=1:size(load,1)
    
    load_node = load{i,1}.Node;
    [node.q, node.qd] = find_state_vector(obj,load_node,Z);
    node.omega = node.qd(6);
    
    load{i,1}.localisation_matrix=create_ele_loc_matrix;
    load{i,1}.h=get_loc_load_vec(load{i,1},time,node);


    L_ele = sparse(6,6*n_nodes);
    L_ele(1:6,(load_node-1)*6+1:(load_node-1)*6+6)=load{i,1}.localisation_matrix; %#ok<SPRIX>
    
    h = h + L_ele'*load{i,1}.h;
    
end

end

function localisation_matrix =create_ele_loc_matrix
% Builds a simple local localisation matrix in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Localisation matrix


%Vektorversion der Localisierungsmatrix:
Lv0_ele = [1,2,3,4,5,6];

%Matrixversion:
L_ele = sparse(6,6);
for k = 1:6
    L_ele(k,Lv0_ele(k)) = 1; %#ok<SPRIX>
end

localisation_matrix = L_ele;
end

function h = get_loc_load_vec(obj,time,varargin)
% Assembles load vector for specific load type from Config-file (cnfg) in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :parameter time: Time step
%    :type time: double
%    :parameter varargin: Placeholder
%    :type varargin: 
%    :return: Load vector h

% Licensed under GPL-3.0-or-later, check attached LICENSE file

h = sparse(6,1);

% dof-order: ux,uy,uz,psix,psiy,psiz
Type=obj.Type;
switch Type
    case 'ForceLoad'
        h(1,:) = interp1(obj.Time, obj.Fy, time, 'linear');
        h(2,:) = interp1(obj.Time, obj.Fz, time, 'linear');
        h(3,:) = interp1(obj.Time, obj.Fx, time, 'linear');
        h(4,:) = interp1(obj.Time, obj.My, time, 'linear')/1000;% unit Nmm-->Nm
        h(5,:) = interp1(obj.Time, obj.Mz, time, 'linear')/1000;% unit Nmm-->Nm
        h(6,:) = interp1(obj.Time, obj.Mx, time, 'linear')/1000;% unit Nmm-->Nm
end

end