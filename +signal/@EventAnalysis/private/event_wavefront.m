function amat=event_wavefront(amat,t,x,tnot,xnot,v,amp,aper)
% EVENT_WAVEFRONT: inserts a wavefront (circle) event in a matrix.
%
% amat=event_wavefront(amat,t,x,tnot,xnot,v,amp,flag,aper)
%
% EVENT_WAVEFRONT inserts a wavefront circle event in a matrix. This is
% done in the time domain so that the reciprocal nature of diffraction
% hyperbolae and wavefront circles can be easily demonstrated.
% EVENT_WAVEFRONT 在矩阵中插入一个波前圆事件。这是在时间域中完成的，
% 以便可以容易地演示双曲线绕射和波前圆的互易性质。
%
% amat ... the matrix of size nrows by ncols
% t ... vector of length nrows giving the matrix t coordinates
% x ... vector of length ncols giving the matrix x coordinates
% tnot ... t coordinate of the wavefront nadir (lowest point)
% xnot ... x coordinate of the wavefront nadir (lowest point)
% v ... velocity of wavefront. Value is divided by two to simulate post
%       stack.
% amp ... amplitude of the wavefront
% aper ... truncate wavefront beyond this aperture
% ******** default is no truncation ********


if( nargin <8 )
	aper = inf;
end

v=v/2;
r=v*tnot;%radius of the circle
% 圆的半径
r=min([r aper]);
x1=xnot-r;
x2=xnot+r;
ix=near(x,x1,x2);%these are the columns of interest

%loop over columns
% 遍历列
[nsamp,nc]=size(amat);

dt=t(2)-t(1);
tmin=t(1);

for k=ix
    xoff=x(k)-xnot;
    tk = sqrt(r^2-xoff^2)/v;
    a=amp;
    ik=(tk-tmin)/dt+1;
    if( between(1,nsamp,ik) )
        ik1=floor(ik);
        ik2=ceil(ik);
        if(ik1==ik2)
            %exactly on a sample
            amat(ik1,k)=amat(ik1,k)+a;
        else
            %a simple interpolation
            amat(ik1,k)=amat(ik1,k)+a*(ik-ik2)/(ik1-ik2);
            amat(ik2,k)=amat(ik2,k)+a*(ik-ik1)/(ik2-ik1);
        end
    end
end