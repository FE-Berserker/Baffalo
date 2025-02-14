function [c,d]=plane_nd(p)
% Calculate the coefficients of the equation of a PLANE in N Dimensions.
%
% Description
%     [#c#,#d#]=plane_nd(#p#)
%     gives the coefficients of the equation of the implicit form of the
%     plane defined by the points #p#. The explicit form of a plane in n
%     dimensions is defined as the points p1,p2,...pn defining the plane
%     (it passes through all of them). The implicit form of a plane in n
%     dimensions is defined as the equation c1*x1+c2*x2+...+cn*xn+d=0, in
%     which c1,c2,...cn,d are constant coefficients depending on the
%     orientation and the position of the plane, and x1,x2...,xn are the
%     coordinates of any point in n dimensions. If the above equation is
%     satisfied, the point belongs to the plane.
%
% Input arguments
%     #p# ([#n# x #n#]) is the matrix containing the coordinates of the
%         points defining the plane. #n# is the dimensionality of the
%         problem. #p# matrix must be square.
%
% Output arguments
%     #c# ([#m# x 1]) is the column vector containing the coefficients of
%         the equation of the plane in the implicit form.
%     #d# (scalar) is the constant term of the equation of the plane in the
%         implicit form. It determines the offset of the plane from the
%         origin.
%
% Examples:
%     p2=eye(2);
%     [c2,d2] = plane_nd(p2)
% 
%     p3=eye(3);
%     [c3,d3] = plane_nd(p3)
% 
%     p4=eye(4);
%     [c4,d4] = plane_nd(p4)
%
% Parents (calling functions)
%     convhull_nd > plane_nd
%     delaunay_nd > convhull_nd > plane_nd
%     voronoi_nd  > convhull_nd > plane_nd
%
% Children (called functions)
%

%__________________________________________________________________________
% Contact author
%
%  (c) 2014 by George Papazafeiropoulos
%  First Lieutenant, Infrastructure Engineer, Hellenic Air Force
%  Civil Engineer, M.Sc., Ph.D. candidate, NTUA
%
% Email: gpapazafeiropoulos@yahoo.gr
%
% Website: http://users.ntua.gr/gpapazaf/
%

[~,m]=size(p);
pdiff=diff(p);
c=zeros(m,1);
sign=1;
r=1:m;
for i=r
    c(i)=sign*det(pdiff(:,r~=i));
    sign=-sign;
end
c=c/norm(c);
d=-p(1,:)*c;
    
