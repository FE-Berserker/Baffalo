function varargout=convhull_nd(varargin)
% Calculate the CONVex HULL of a set of points in N Dimensions.
%
% Description
%     #varargout#=convhull_nd(#varargin#)
%     gives the facets of the convex hull of given points.
%
% Definitions:
%     (1) A set S is convex if for any two points p,q in S, the line
%     segment pq lies into S.
%     (2) For a subset P of Rd, the convex hull conv(P) is defined as:
%         (2.1) The (unique) smallest convex set C in Rd containing P
%         (P<=C)
%         (2.2) The intersection of all convex sets containing P
%         (2.3) The set of all convex combinations of points in P
%         (2.4) The union of all simplices with vertices in P
%     (3) The convex hull computation means the determination of conv(S)
%     for a given finite set of n points (#points#) in Rd.
%
% Properties:
%     The convex-hull operator conv() has the characteristic properties of
%     a closure operator:
%     (1) It is extensive, meaning that the convex hull of every set P is a
%     superset of P.
%     (2) It is non-decreasing, meaning that, for every two sets X and Y
%     with X<=Y, the convex hull of X is a subset of the convex hull of Y.
%     (3) It is idempotent, meaning that for every P, the convex hull of
%     the convex hull of P is the same as the convex hull of P.
%     (4) The Delaunay triangulation of a point set and its dual, the
%     Voronoi diagram, are mathematically related to convex hulls: the
%     Delaunay triangulation of a point set in R(#d#) can be viewed as the
%     projection of a convex hull in R(#d#+1) (Brown, K. Q., 1979).
%
% Algorithm:
%     To compute the convex hull (#faces#) of a set of n points (#points#)
%     this algorithm uses the following scheme:
%     () set #faces#, #cf# and #df# to an arbitrary simplex defined by the
%        first #d#+1 points in #points#
%     () for each face #k# of the convex hull created (#faces#)
%         () define the simplex formed by the face #k# and the remaining
%            point not belonging to the hyperplane defined by the face
%         () calculate its volume
%         () if the volume is negative
%             () reverse the order of the last two vertices of the #k#th
%                face in #faces# to change the volume sign
%             () change the sign of the plane coefficients #cf# and #df# of
%                the #k#th face in #faces#
%         () end if
%     () end for
%     () find the relative distance of the remaining points from the center
%        of the point set. 
%     () sort the remaining points from the highest to the lowest relative
%        distance from the center of the point set. 
%     () set a remaining point vector (#pleft#) equal to the above order
%     () while #pleft# is not empty
%         () select the first point #i# from #pleft#. Delete it from
%            #pleft#.
%         () * find which of the faces of the current convex hull are
%            visible from this point
%         () if there are any visible faces (#visible#)
%             () for each visible face #v# from #visible#
%                 () find the nonvisible faces #u# connected to (i.e.
%                    having one common edge with) the visible face #v#, if
%                    any
%                 () for each nonvisible face #k# from #u#
%                     () add the boundary between the visible face #v# and
%                        the nonvisible face #k# connected to the visible
%                        face #v# to the horizon (#horizon#)
%                 () end for
%             () end for
%             () delete the visible faces (#visible#) and the corresponding
%                plane coefficients #cf# and #df#
%             () for each boundary #j# from #horizon#
%                 () add the face defined by horizon and the selected point
%                    #i# to the convex hull (#faces#)
%                 () calculate the plane coefficients of the above face and
%                    store them appropriately in #cf# and #df#
%             () end for
%             () for each face #k# from the new faces added to the convex
%                hull by the previous for-loop
%                 () choose a point non-coplaner to the face
%                 () define the simplex formed by the face #k# and the
%                    above point
%                 () calculate its volume
%                 () if the volume is negative
%                     () reverse the order of the last two vertices of the
%                        #k#th face to change the volume sign
%                     () change the sign of the plane coefficients #cf# and
%                        #df# of the #k#th face
%                 () end if
%             () end for
%             clear #horizon#
%         () end if
%         () if the number of iterations has reached the specified number
%            #iter2del#
%             () ** delete the points which are not visible by all of the
%                faces of the current convex hull
%         () end if
%     () end while
%
% Input arguments
%     #varargin# ({#points# #iter2del#}) contains the following arguments:
%         #points# ([#n# x #d#]) is a matrix containing the coordinates of
%         the points the convex hull of which is to be calculated. #n# is
%         the number of points and #d# is the dimensionality of the
%         problem.
%         #iter2del# (scalar) is the number of iterations every which
%         deletion of the points inside the current convex hull occurs. It
%         is recommended that it is specified (i.e. it is assigned a finite
%         value) if the number of points becomes relatively large. There is
%         an optimum value for this variable in general. Low values lead to
%         increased number of internal point deletions which minimizes the
%         number of points deleted in each repetition of the deletion
%         process, and is generally more computationally costly if the
%         number of points is small; the same number of iterations (one for
%         each point) would have much lower computational cost. On the
%         other hand, if this argument takes large values, more iterations
%         take place before each deletion, which would possibly check
%         internal points and would not have been done if these points were
%         deleted. The final selection of the value of this parameter is
%         judged according to the ratio of the execution time of step ()*
%         to the execution time of step ()** shown in the algorithm above.
%         If this ratio is large, #iter2del# should be decreased, and in
%         the opposite case #iter2del# should be increased. If the points
%         belonging to the convex hull is a significant portion of the
%         initial point set, point deletion is not large, and
%         consequently this parameter has little or no effect. It should be
%         ignored or set to a large value. The opposite happens if the
%         portion of the initial point set belonging to the convex hull
%         is small.
%
% Output arguments
%     #varargout# ({#faces# #cf# #df# #Vol#}) contains the following
%     arguments:
%         #faces# ([#nfaces# x #d#]) is a matrix containing the identities
%         of the points defining each facet of the convex hull calculated.
%         #nfaces# is the number of facets of the convex hull.
%         #cf# ([#nfaces# x #d#]) contains the coefficients of the planes
%         defined by #faces#. Each row of #cf# contains the coefficients of
%         the corresponding row of #faces#. The equation of the plane #i#
%         is: #cf#(#i#,:)*[x1;x2;...xd]+#df#(#i#)=0 where #d# is the
%         dimension of the problem.
%         #df# ([#nfaces# x 1]) contains the constant terms of the planes
%         defined by #faces#. Each row of #df# contains the constant term
%         of the corresponding row of #faces#. The equation of the plane
%         #i# is: #cf#(#i#,:)*[x1;x2;...xd]+#df#(#i#)=0 where #d# is the
%         dimension of the problem.
%         #Vol# (scalar) is the volume of the convex hull.
%
% Example:
%     [X,Y,Z]=meshgrid(0:1);
%     points=[X(:),Y(:),Z(:)];
%     points=points+0.001*rand(size(points));
%     [faces,~,~,V]=convhull_nd(points)
%     trisurf(faces,points(:,1),points(:,2),points(:,3))
%
% Parents (calling functions)
%     delaunay_nd > convhull_nd
%     voronoi_nd  > convhull_nd
%
% Children (called functions)
%     convhull_nd > ismembc
%     convhull_nd > plane_nd

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
% Span of the point set in the various dimensions
span=max(points)-min(points);
% Delete the dimensions without span (squeeze them and compute the convex
% hull at the remaining dimensions)
points(:,span<100*eps)=[];
span(span<100*eps)=[];
[n,d]=size(points);
% Add a last column of ones. Used only for determinant calculation.
points=[points,ones(n,1)];
% The initial convex hull is a simplex with (d+1) facets
nfaces=d+1;
faces=zeros(d+1,d);
aVec=1:nfaces;
% Each column of cf contains the coefficients of a plane
cf=zeros(d,d+1);
% Each column (or element) of df contains the constant term of a plane
df=zeros(1,d+1);
for i=aVec
    % Set the indices of the points defining the face
    faces(i,:)=aVec(~ismembc(aVec,i));
    % Calculate and store appropriately the plane coefficients of the face
    [cfi,dfi]=plane_nd(points(faces(i,:),1:d));
    cf(:,i)=cfi;
    df(i)=dfi;
end
% Check to make sure that faces are correctly oriented
bVec=1:(d+1);
% A contains the coordinates of the points forming a simplex
A=zeros(d+1,d+1);
for k=aVec
    % Get the point that is not on the current face (point p)
    fVec=sort(faces(k,:));
    p=bVec(~ismembc(bVec,fVec));
    A(1:d,:)=points(faces(k,:),:);
    A(d+1,:)=points(p,:);
    % det(A) determines the orientation of the face
    v=det(A);
    % Orient so that each point on the original simplex can't see the
    % opposite face
    if v < 0
        % Reverse the order of the last two vertices to change the volume
        % sign
        faces(k,(d-1):d)=faces(k,d:-1:(d-1));
        % Modify the plane coefficients of the properly oriented faces
        cf(:,k)=-cf(:,k);
        df(k)=-df(k);
        A(1:d,:)=points(faces(k,:),:);
        A(d+1,:)=points(p,:);
    end
end
% Coordinates of the center of the point set
meanp=sum(points((d+2):n,1:d))/(n-d-1);
% Absolute distance of points from the center
absdist=points((d+2):n,1:d)-meanp(ones(n-d-1,1),:);
% Relative distance of points from the center
reldist=absdist./span(ones(n-d-1,1),:);
reldist=sum(reldist.^2,2);
% Sort from maximum to minimum relative distance
[~,ind]=sort(reldist,'descend');
% Initialize the vector of points left. The points with the larger relative
% distance from the center are scanned first.
pleft=ind'+d+1;
% Loop over all remaining points that are not deleted. Deletion of points
% occurs every #iter2del# iterations of this while loop
A=zeros(d+1,d+1);
% cnt is equal to the points having been selected without deletion of
% nonvisible points (i.e. points inside the current convex hull)
cnt=0;
while ~isempty(pleft)
    % i is the first point of the points left
    i=pleft(1);
    % Delete the point selected
    pleft=pleft(2:end);
    % Update point selection counter
    cnt=cnt+1;
    % Find visible faces
    visible_ind=points(i,1:d)*cf+df>0;
    % If there are any visible faces
    if any(visible_ind)
        % Find visible face indices
        visible=find(visible_ind);
        % Find nonvisible faces
        nonvisible_faces=faces(~visible_ind,:);
        % Create horizon
        % count is the number of the edges of the horizon
        count=0;
        for j=1:length(visible)
            % v is a visible face
            v=visible(j);
            % u are the nonvisible faces connected to the face v, if any
            f0=ismembc(nonvisible_faces,sort(faces(v,:)));
            u=find(sum(f0,2)==d-1);
            for k=1:numel(u)
                % The boundary between the visible face v and the k(th)
                % nonvisible face connected to the face v forms part of the
                % horizon
                count=count+1;
                gVec=nonvisible_faces(u(k),:);
                horizon(count,:)=gVec(f0(u(k),:));
            end
        end
        % Delete visible faces
        faces=faces(~visible_ind,:);
        % Delete the corresponding plane coefficients of the faces
        cf=cf(:,~visible_ind);
        df=df(~visible_ind);
        % Update the number of faces
        nfaces=nfaces-length(visible);
        % start is the first row of the new faces
        start=nfaces+1;
        % Add faces connecting horizon to the new point
        n_newfaces=size(horizon,1);
        for j=1:n_newfaces
            nfaces=nfaces+1;
            faces(nfaces,1:d-1)=horizon(j,:);
            faces(nfaces,d)=i;
            % Calculate and store appropriately the plane coefficients of
            % the faces
            [cfj,dfj]=plane_nd(points(faces(nfaces,:),1:d));
            cf(:,nfaces)=cfj;
            df(nfaces)=dfj;
        end
        % Orient each new face properly
        hVec=1:nfaces;
        for k=start:nfaces
            p=hVec(~ismembc(hVec,sort(faces(k,:))));
            index=1;
            A(1:d,:)=points(faces(k,:),:);
            A(d+1,:)=points(p(index),:);
            % While new point is coplanar, choose another point
            while det(A)==0
                index=index+1;
                A(1:d,:)=points(faces(k,:),:);
                A(d+1,:)=points(p(index),:);
            end
            v=det(A);
            % Orient faces so that each point on the original simplex can't
            % see the opposite face
            if v < 0
                % If orientation is improper, reverse the order to change
                % the volume sign
                faces(k,(d-1):d)=faces(k,d:-1:(d-1));
                % Modify the plane coefficients of the properly oriented
                % faces
                cf(:,k)=-cf(:,k);
                df(k)=-df(k);
                A(1:d,:)=points(faces(k,:),:);
                A(d+1,:)=points(p(index),:);
                if det(A) < 0
                    error('facet is not properly oriented...')
                end
            end
        end
        % Remove the data from horizon before the next iteration
        clear horizon;
    end
    % If the point selection counter has reached the specified number of
    % iterations every which the points inside the current convex hull are
    % deleted
    if cnt==iter2del
        cnt=0;
        % find the points which are visible by at least one face of the
        % current convex hull
        indleft=any(points(pleft,1:d)*cf+df(ones(numel(pleft),1),:)>0,2);
        % redefine pleft by retaining only these points
        pleft=pleft(indleft);
        %
        clear indleft
    end
end
varargout{1}=faces;
% Output of H-representation of the convex hull
if nargout>1
    cf=cf';
    varargout{2}=cf;
end
if nargout>2
    df=df';
    varargout{3}=df;
end
% Volume calculation
if nargout>3
    % Define the reference point belonging to the 1st face
    pref=faces(1);
    % Loop from the 2nd to the last face of the convex hull
    A=zeros(d+1,d+1);
    Vol=0;
    for i=2:nfaces
        A(1:d,:)=points(faces(i,:),:);
        A(d+1,:)=points(pref,:);
        Vol=Vol+abs(det(A));
    end
    Vol=Vol/prod(1:d);
    varargout{4}=Vol;
end

