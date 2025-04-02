function [M_A] = compute_axial_mass_matrix(Element)
% Builds the axial mass submatrix 
%
%    :return: Axial mass submatrix M_A

E = Element;
MA11=cellfun(@(x,y,z)1/6*(z*x*y*2),E.Area,E.Length,E.Dens,'UniformOutput',false);
MA12=cellfun(@(x,y,z)1/6*(z*x*y*1),E.Area,E.Length,E.Dens,'UniformOutput',false);
M_A=cellfun(@(x,y)[x,y;y,x],MA11,MA12,'UniformOutput',false);

end