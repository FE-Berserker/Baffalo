function yi=pwlint(x,y,xi)
% PWLINT: piecewise linear interpolation (much faster than interp1)
%
% yi=pwlint(x,y,xi)
%
% PWLINT performs linear interpolation when it is known that that
% input function (x,y) is piecewise linear. If length(x) is much less than
% the length(xi), this is MUCH faster than the built in INTERP1. Points
% in xi which are outside the bounds of x will return nans.
%
if(length(x)<=length(xi))
    nsegs=length(x)-1;
    yi=nan*zeros(size(xi));

    for k=1:nsegs

        %find the points in this line segment
        ii=between(x(k),x(k+1),xi,2);

        if( ii )
            % interpolate
            yi(ii)=y(k)+(y(k+1)-y(k))*(xi(ii)-x(k))/(x(k+1)-x(k));
        end

    end
else
    yi=nan*zeros(size(xi));
    for k=1:length(xi)
        ii=surround(x,xi(k));
        if(~isempty(ii))
            yi(k) = y(ii)*(x(ii+1)-xi(k))/(x(ii+1)-x(ii))+y(ii+1)*(xi(k)-x(ii))/(x(ii+1)-x(ii));
        else
            yi(k)=nan;
        end
    end
end