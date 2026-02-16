function ind=surround(x,xtest)
% SURROUND: analyze how a vector surrounds some test points
%
% ind=surround(x,xtest)
%
% SURROUND returns a vector of indicies indicating how the vector
% x surrounds xtest which must be a scalar. If 
% isempty(ind) then xtest lies outside the range of x. Otherwise,
% ind will be the index of a point in x just greater (or less) than 
% xtest. Thus the following will be true:
%	x(ind) <= xtest < x(ind+1)
%		or
%	x(ind) >= xtest > x(ind+1)
%
% So, for if xtest is an interior point for the vector x,
% ind and ind+1 select those points in x which surround (or bracket)
% xtest. Note that x need not be monotonic. If the xtest is surrounded
% more than once by x, then ind will be a vector.
% example: x=1:10;
% >>surround(x,-1)
%    returns []
% >>surround(x,3)
%   returns 3
% now let x=[1:10 9:-1:1]
% >>surround(x,3)
%    returns 3 17
% >>surround(x,pi)
%   returns 3 16

	
	n=length(x);
	x1=x(1:n-1);
	x2=x(2:n);
	
	ind=find( (x1<=xtest & x2>xtest ) | ...
			(x1>=xtest & x2 < xtest ) );