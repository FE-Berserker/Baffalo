function Vpos = get_position_entries1(obj,V)
% Extracts the elements of the eigenvector matrix referring to the position
%
%    :param V: Eigenvectors columnwise
%    :type V: matrix
%    :return: Eigenvectormatrix with only position entries


    n.nodes = length(obj.Rotor.Mesh.Node);
    ind = n.nodes*2*2+1:n.nodes*2*4;
    Vpos = V(ind,:);
end