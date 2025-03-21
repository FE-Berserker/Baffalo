function dofNo= get_dof_no(RotorSystem,nodeNo)
% Gets the numbers of all degrees of freedom, that correspond to the node numbers.
%
%    :parameter rotor: Object of type AMrotorSIM.Rotor.FEMRotor.FeModel
%    :type rotor: object
%    :parameter nodeNo: Number of the desired node
%    :type nodeNo: vector
%    :return: All global DoF's of the entered node numbers
%    :rtype: vector

%GET_DOF_NO - get the dofs of selected nodes
% dofNo= get_dof_no(rotor,nodeNo)


dofPerNode = length(RotorSystem.Rotor.mass_matrix)/size(RotorSystem.Rotor.Mesh.Node,1);

dofNo = NaN(length(nodeNo)*dofPerNode,1);

for i = 1:length(nodeNo)
    nodeNoCurr = nodeNo(i,1);
    dofNo((i-1)*6+1:i*6) = (nodeNoCurr-1)*dofPerNode+1 : nodeNoCurr*dofPerNode;
end

end