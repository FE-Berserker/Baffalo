function [tfr,t,f] = WTransform(x,fs,totalscal)
%  WT
%	x       : Signal.
%	hlength : Window length.

%	tfr   : Time-Frequency Representation.

%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
%
%  

[xrow,xcol] = size(x);

if (xcol~=1)
 error('X must be column vector');
end

if (nargin < 3)
totalscal=256;
end

wavename='cmor3-3';
wcf=centfrq(wavename);
cparam=2*wcf*totalscal;
a=totalscal:-1:1;
scal=cparam./a;
s=x';
tfr=cwt(s,scal,wavename);

t=0:1/fs:xrow-1/fs;
f=scal2frq(scal,wavename,1/fs);