function [M_T] = compute_torsional_mass_matrix(Element)
% Builds the torsional mass submatrix 
%
%    :return: Torsional mass submatrix M_T

E = Element;
MT11=cellfun(@(x,y,z)(z*x*y)/6*2,E.I_p,E.Length,E.Dens,'UniformOutput',false);
MT12=cellfun(@(x,y,z)(z*x*y)/6*1,E.I_p,E.Length,E.Dens,'UniformOutput',false);
M_T=cellfun(@(x,y)[x,y;y,x],MT11,MT12,'UniformOutput',false);

end