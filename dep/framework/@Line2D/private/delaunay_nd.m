function DT=delaunay_nd(varargin)
% Calculate the DELAUNAY triangulation of a set of points in N Dimensions.
%
% Description
%     #DT#=delaunay_nd(#varargin#)
%     gives the point identities defining the Delaunay triangulation of
%     #points#.
%
% Definitions:
%     (1) A triangulation of a finite point set S is a subdivision of the
%     #d#-dimensional domain of the convex hull of S, whose bounded faces
%     are #d#-1 entities (each defined by #d# points) and whose vertices
%     are the points of S.
%     (2) For a point set P in the (#d#-dimensional) Euclidean space, a
%     Delaunay triangulation is a triangulation DT(P) such that no point in
%     P is inside the circum-hypersphere of any simplex in DT(P). There
%     exists a unique Delaunay triangulation for P, if P is a set of points
%     in general position; that is, there exists no k-flat containing k + 2
%     points nor a k-sphere containing k + 3 points, for 1<=k<=#d#-1
%     (e.g., for a point set in R3; no three points are on a line, no four
%     on a plane, no four are on a circle, and no five on a sphere).
%
% Properties:
%     (1) The union of all simplices in the triangulation is the convex
%     hull of the points.
%     (2) The Delaunay triangulation contains O(#n#^(#d#/2)) simplices.
%     (3) In the plane (#d#=2), if there are b vertices on the convex hull,
%     then any triangulation of the points has at most 2#n#-2-b triangles,
%     plus one exterior face.
%     (4) In the plane, each vertex has on average six surrounding
%     triangles.
%     (5) In the plane, the Delaunay triangulation maximizes the minimum
%     angle. Compared to any other triangulation of the points, the
%     smallest angle in the Delaunay triangulation is at least as large as
%     the smallest angle in any other. However, the Delaunay triangulation
%     does not necessarily minimize the maximum angle. The Delaunay
%     triangulation also does not necessarily minimize the length of the
%     edges.
%     (6) A circle circumscribing any Delaunay triangle does not contain
%     any other input points in its interior.
%     (7) If a circle passing through two of the input points does not
%     contain any other of them in its interior, then the segment
%     connecting the two points is an edge of a Delaunay triangulation of
%     the given points.
%     (8) Each simplex of the Delaunay triangulation of a set of points in
%     #d#-dimensional space corresponds to a facet of convex hull of the
%     projection of the points onto a (#d#+1)-dimensional paraboloid, and
%     vice versa (Brown, K. Q., 1979).
%     (9) The closest neighbor b to any point p is on an edge bp in the
%     Delaunay triangulation.
%     (10) The shortest path between two vertices, along Delaunay edges, is
%     known to be no longer than $\frac{4\pi}{3\sqrt{3}} \approx 2.418$
%     times the Euclidean distance between them. The plane tangent to the
%     point (x0,y0,z0) of the paraboloid is used to find the point where
%     this tangent plane crosses the (#d#+1)th axis (w). The facets of the
%     convex hull which are visible from this point are projected
%     appropriately to give the Delaunay triangulation.
%
% Input arguments
%     #varargin# ({#points# #iter2del#}) contains the following arguments:
%         #points# ([#n# x #d#]) is a matrix containing the coordinates of
%         the points the Delaunay triangulation of which is to be
%         calculated. #n# is the number of points and #d# is the
%         dimensionality of the problem.
%         #iter2del# (scalar) is a parameter controlling internal point
%         deletion at the convex hull algorithm. Type |help convhull_nd|
%         for more details.
%
% Output arguments
%     #DT# ([#u# x #d#]) is a matrix containing the identities of the
%     points defining each simplex of the Delaunay triangulation
%     calculated. #u# is the number of simplices of the Delaunay
%     triangulation.
%
% Example:
%     [X,Y,Z]=meshgrid(0:1);
%     points=[X(:),Y(:),Z(:)];
%     points=points+0.001*rand(size(points));
%     DT=delaunay_nd(points);
%     % Plot the mesh
%     tetramesh(DT,points)
%     % Calculate the volume of the mesh
%     V=0;
%     for i=1:size(DT,1)
%         V=V+1/6*abs(det([points(DT(i,:),:) ones(4,1)]));
%     end
% 
% Parents (calling functions)
% 
% Children (called functions)
%     delaunay_nd > convhull_nd
%     delaunay_nd > convhull_nd > ismembc
%     delaunay_nd > convhull_nd > plane_nd
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

points=varargin{1};
if nargin>1
    iter2del=varargin{2};
else
    iter2del=Inf;
end
nd=size(points,2);
% Project points onto the R(d+1) paraboloid
w=sum(points.^2,2);
projpoints=[points w];
% Create convex hull of the the R(d+1) paraboloid
[faces,cf,df]=convhull_nd(projpoints,iter2del);
% Find the coordinates of the point with the maximum (d+1)th coordinate
% (i.e. w coordinate)
[w0,i]=max(w);
p0=points(i,:);
% Find the point where the plane tangent to the point (p0,w0) on the
% paraboloid crosses the w axis. This is the point that can see the entire
% lower hull.
w_optimal=w0-2*sum(p0.^2);
% Subtract 1000 times the absolute value of w_optimal to ensure that the
% point where the tangent plane crosses the w axis will see all points on
% the lower hull. This avoids numerical roundoff errors.
w_optimal2=w_optimal-1000*abs(w_optimal);
% Set the point where the tangent plane crosses the w axis
p=[zeros(nd,1);w_optimal2];
% Find all faces that are visible from this point (with logical indexing)
visible=cf*p+df>0;
% Extract the simplices in the lower hull in R(d)
DT=faces(visible,:);

