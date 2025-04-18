function glob_dof = get_gdof(obj,direction,Node,varargin)
% Provides the global DoF based on node number and direction
%
%    :parameter direction: Direction ('u_x','u_y','u_z','psi_x','psi_y','psi_z')
%    :type direction: char
%    :parameter Node: Number of desired node
%    :type Node: vector(double)
%    :parameter varargin: Variable input argument (check function)
%    :type varargin: 
%    :return: Global DoF's of the entered nodes with the corresponding orientation
%    :rtype: vector

% get_gdof - get global degree of freedom
% glob_dof = get_gdof(self,direction,Node,varargin)
%  direction: 'u_x','u_y','u_z','psi_x','psi_y','psi_z'
%  node: number of desired node
%  varargin: A -> system matrix in state space
%

% falls weniger als 6 dof benutzt werden
n.nodes = length(obj.Rotor.Mesh.Node);
if nargin == 3
    n.dof = 6*n.nodes;
else
    A = varargin{1};
    n.dof = length(A)/2;
end
n.dofPerNode = n.dof/n.nodes;

dof_name = {'Ux','Uy','Uz','Rotx','Roty','Rotz'};
dof_loc = [3,1,2,6,4,5];

ldof = containers.Map(dof_name,dof_loc);


if ischar(direction) == 1
    entry_nr = ldof(direction);
else
    error('Error: The first entry of get_gdof() has to be a string');
end

if isempty(find(ismember(dof_name,direction))) == 1
    error ('Error: Input not existent as a degree of freedom')
end

glob_dof = (Node-1)*n.dofPerNode+entry_nr;

end