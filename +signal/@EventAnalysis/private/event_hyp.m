function amat=event_hyp(amat,t,x,tnot,xnot,v,amp,flag,aper)
% EVENT_HYP: inserts a hyperbolic event in a matrix.
% EVENT_HYP: 在矩阵中插入一个双曲线事件
%
% amat=event_hyp(amat,t,x,tnot,xnot,v,amp,flag,aper)
%
% EVENT_HYP inserts a hyperbolic event in a matrix.
% EVENT_HYP 在矩阵中插入一个双曲线事件
%
% amat ... the matrix of size nrows by ncols
% t ... vector of length nrows giving the matrix t coordinates
% x ... vector of length ncols giving the matrix x coordinates
% tnot ... t coordinate of the hyperbola apex
% xnot ... x coordinate of the hyperbola apex
% v ... velocity of hyperbola. Value is divided by two to simulate post
%       stack. If you are doing prestack, double your velocity.
% amp ... amplitude at the apex
% flag ... determines amplitude decay on hyperbola
%		1 -> no decay
%		2 -> decay as to/tx (obliquity)
%     3 -> decay as to/(tx^1.5) (2D)
%		4 -> decay as to/(tx^2) (3D)
% ******** default is 3 ********
% aper ... truncate hyperbola beyond this aperture
% ******** default is no truncation ********
%

%
if(nargin<8)
	flag=3;
end
if( nargin < 9 )
	aper = inf;
end

v=v/2;

%loop over columns
[nsamp,nc]=size(amat);

dt=t(2)-t(1);
tmin=t(1);
for k=1:nc
	xoff=x(k)-xnot;
	if(abs(xoff) < aper)
		tk = sqrt(tnot^2+(xoff/v)^2);
		a=amp;
		if(flag==2)
			a = tnot*a/tk;
		elseif(flag==3)
			a = tnot*a/(tk^1.5);
		elseif(flag==4)
			a = tnot*a/(tk*tk);
		end
		ik=(tk-tmin)/dt+1;
		if( between(1,nsamp,ik) )
			ik1=floor(ik);
			ik2=ceil(ik);
			if(ik1==ik2)
				amat(ik1,k)=amat(ik1,k)+a;
			else
				amat(ik1,k)=amat(ik1,k)+a*(ik-ik2)/(ik1-ik2);
				amat(ik2,k)=amat(ik2,k)+a*(ik-ik1)/(ik2-ik1);
			end
		end
	end
end