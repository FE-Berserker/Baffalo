function y = hilbm(x)
% HILBM: Hilbert transform
%
% HILBERT Hilbert transform.
%
% Modified from Matlab's version to require the input to be
% a power of 2 in length. by GFM 
%
%	HILBERT(X) is the Hilbert transform of the real part
%	of vector X.  The real part of the result is the original
%	real data; the imaginary part is the actual Hilbert
%	transform.  See also FFT and IFFT.
%
%	Charles R. Denham, January 7, 1988.
%	Revised by LS, 11-19-88.
%	Copyright (C) 1988 the MathWorks, Inc.
%


nx=length(x);
nx2=2.^nextpow2(length(x));

yy = fft(real(x),nx2);
m = length(yy);
if m ~= 1
	h = [1; 2*ones(m/2,1); zeros(m-m/2-1,1)];
	yy(:) = yy(:).*h;
end
tmp = ifft(yy);
y=tmp(1:nx);