function O=Boundary(Face)
F=Face;
% build directed adjacency matrix
A = sparse(F,F(:,[2:end 1]),1);
% Find single occurance edges
[OI,OJ,OV] = find(A-A');
% Maintain direction
O = [OI(OV>0) OJ(OV>0)];%;OJ(OV<0) OI(OV<0)];
end