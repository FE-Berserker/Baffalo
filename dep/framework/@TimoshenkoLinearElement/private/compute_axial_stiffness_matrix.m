function K_A = compute_axial_stiffness_matrix(Element)
% Builds axial stiffness submatrix
%
%    :return: Axial stiffness submatrix K_A

E = Element;
KA11=cellfun(@(x,y,z)(z*x)/y,E.Area,E.Length,E.E,'UniformOutput',false);
KA12=cellfun(@(x,y,z)(z*x)/y*-1,E.Area,E.Length,E.E,'UniformOutput',false);
K_A=cellfun(@(x,y)[x,y;y,x],KA11,KA12,'UniformOutput',false);
    
end