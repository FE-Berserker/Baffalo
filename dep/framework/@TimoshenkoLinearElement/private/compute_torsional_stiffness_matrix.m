function [K_T] = compute_torsional_stiffness_matrix(Element)
% Builds the torsional stiffness submatrix 
%
%    :return: Torsional stiffness submatrix K_T

E = Element;
KT11=cellfun(@(x,y,z)(z*x)/y,E.I_p,E.Length,E.G,'UniformOutput',false);
KT12=cellfun(@(x,y,z)(z*x)/y*-1,E.I_p,E.Length,E.G,'UniformOutput',false);
K_T=cellfun(@(x,y)[x,y;y,x],KT11,KT12,'UniformOutput',false);
 
end